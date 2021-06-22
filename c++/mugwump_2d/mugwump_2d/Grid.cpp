#include "Grid.h"
#include <math.h>


Grid::Grid(olc::PixelGameEngine* app, const std::string gameTitle, int width, int height, int maxGuesses, int textSize, int borderWidth, int borderHeight)
{
	this->width = width;
	this->height = height;
	this->textSize = textSize;
	this->borderWidth = borderWidth;
	this->borderHeight = borderHeight;
	this->maxGuesses = maxGuesses;
	this->mugwumps = new std::vector<Mugwump*>();
	this->guesses = new std::vector<olc::vi2d>();
	this->console = new Console(gameTitle, this->textSize, this->borderWidth, this->borderHeight);
	this->screenWidth = app->ScreenWidth();
	this->screenHeight = app->ScreenHeight();

	this->cellW = (this->screenWidth - (this->borderWidth * 2)) / this->width;
	this->cellH = (this->screenHeight - (this->borderHeight * 3) - (this->textSize * FONT_SIZE_PX)) / this->height;
	this->cellW = this->cellH = std::min<int>(this->cellW, this->cellH);

	this->x = this->screenWidth - (this->cellW * this->width) - this->borderWidth;
	this->y = std::floor<int>((this->screenHeight - (this->cellH * this->height)) / 2);

}


Grid::~Grid()
{
	if (this->mugwumps != nullptr)
	{
		for (auto iter = this->mugwumps->begin(); iter != this->mugwumps->end(); ++iter)
		{
			delete *iter;
		}
		this->mugwumps->clear();
		delete this->mugwumps;
	}

	if (this->guesses != nullptr)	
	{
		this->guesses->clear();
		delete this->guesses;
	}

}

void Grid::Click(int x, int y)
{
	int gridX = x - this->x;
	int gridY = y - this->y;
	bool isGridLine = ((gridX % this->cellW == 0) || (gridY % this->cellH == 0));
	if (gridX > 0 && gridX < this->cellW * this->width && gridY > 0 && gridY < this->cellH * this->height)
	{
		int px = std::floor<int>(gridX / this->cellW);
		int py = std::floor<int>(gridY / this->cellH);
		this->pos = { px, py };
		this->Select();
	}
}

bool Grid::isGuessOK(int x, int y)
{
	auto position = std::find_if(this->mugwumps->begin(), this->mugwumps->end(), [x, y](Mugwump* mugwump) {return mugwump->isAt(x, y); });
	return (position == this->mugwumps->end());
}

void Grid::MoveDown()
{
	this->pos.y = std::min<int>(this->height - 1, this->pos.y + 1);
}

void Grid::MoveLeft()
{
	this->pos.x = std::max<int>(0, this->pos.x - 1);
}

void Grid::MoveRight()
{
	this->pos.x = std::min<int>(this->width - 1, this->pos.x + 1);
}


void Grid::MoveUp()
{
	this->pos.y = std::max<int>(0, this->pos.y - 1);
}

void Grid::Select()
{
	int x = this->pos.x;
	int y = this->pos.y;
	if (this->isGuessOK(x, y))
	{
		this->guesses->push_back({ x, y });
		for (auto iter = this->mugwumps->begin(); iter != this->mugwumps->end(); ++iter)
		{
			Mugwump* mugwump = (*iter);
			if (mugwump->isAt(x, y))
			{
				mugwump->setFound(true);
			}
		}
	}
}

void Grid::Draw(olc::PixelGameEngine* app)
{
}
