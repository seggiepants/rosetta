#include "settings.h"
#include "Grid.h"
#include <math.h>
#include <numeric>


Grid::Grid(olc::PixelGameEngine* app, const std::string gameTitle, int width, int height, int maxGuesses, int textSize, int borderWidth, int borderHeight)
{
	this->body_colors.clear();
	this->body_colors.push_back(PINK);
	this->body_colors.push_back(VIOLET);
	this->body_colors.push_back(LIGHT_BLUE);
	this->body_colors.push_back(ORANGE);

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
	this->y = (int)((this->screenHeight - (this->cellH * this->height)) / 2);

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
		int px = (int)(gridX / this->cellW);
		int py = (int)(gridY / this->cellH);
		this->pos = { px, py };
		this->Select();
	}
}

bool Grid::isGameOver()
{	
	int mugwumpsFound = std::accumulate(this->mugwumps->begin(), this->mugwumps->end(), 0, [](int total, Mugwump* mugwump) { return total + (mugwump->getFound() ? 1 : 0); });
	return (this->guesses->size() <= (size_t)this->maxGuesses) || ((size_t)mugwumpsFound == this->mugwumps->size());
}

bool Grid::isGameWon()
{
	int mugwumpsFound = std::accumulate(this->mugwumps->begin(), this->mugwumps->end(), 0, [](int total, Mugwump* mugwump) { return total + (mugwump->getFound() ? 1 : 0); });
	return (this->guesses->size() <= (size_t)this->maxGuesses) && ((size_t)mugwumpsFound == this->mugwumps->size());
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

void Grid::NewGame(int numMugwumps)
{
	this->guesses->clear();
	this->mugwumps->clear();
	for (int i = 0; i < numMugwumps; i++)
	{
		bool positionOK = false;
		int x = 0;
		int y = 0;
		olc::Pixel color;

		while (!positionOK)
		{
			x = rand() % 10; // ZZZ fix with grid size
			y = rand() % 10; // ZZZ fix with grid size
			color = body_colors[i % body_colors.size()];
			auto position = std::find_if(this->mugwumps->begin(), this->mugwumps->end(), [x, y](Mugwump* mugwump) {return mugwump->isAt(x, y); });
			positionOK = (position == this->mugwumps->end());
		}
		this->mugwumps->push_back(new Mugwump(false, x, y, color, WHITE, BLACK, BLACK));
	}
}

void Grid::Select()
{
	int x = this->pos.x;
	int y = this->pos.y;
	if (this->isGuessOK(x, y))
	{
		this->guesses->push_back({ x, y });
		auto position = std::find_if(this->mugwumps->begin(), this->mugwumps->end(), [x, y](Mugwump* mugwump) {return mugwump->isAt(x, y); });
		if (position != this->mugwumps->end())
			(*position)->setFound(true);
	}
}

void Grid::Draw(olc::PixelGameEngine* app)
{
	this->console->Draw(app, this->guesses, this->maxGuesses, this->mugwumps);
	int i;
	std::stringstream buffer;
	std::string digits;
	olc::vi2d textPos;
	
	for (i = 0; i <= this->height; ++i)
	{
		app->DrawLine(this->x, this->y + (this->cellH * i), this->x + (this->cellW * this->width) , this->y + (this->cellH * i), WHITE);
		if (i < this->height)
		{
			buffer.str("");
			buffer << i;
			digits = buffer.str();
			textPos = { this->x - (this->textSize * FONT_SIZE_PX * (int)digits.length()) - this->borderWidth, this->y + ((this->height - i) * this->cellH) - (int)(this->cellH / 2) - ((FONT_SIZE_PX * this->textSize) / 2) };
			app->DrawString(textPos, digits, WHITE, this->textSize);
		}
	}

	for (i = 0; i <= this->width; ++i)
	{
		app->DrawLine(this->x + (this->cellW * i), this->y, this->x + (this->cellW * i), this->y + (this->cellH * this->height), WHITE);
		if (i < this->width)
		{
			buffer.str("");
			buffer << i;
			digits = buffer.str();
			textPos = { this->x + (int)(this->cellW / 2) + (i * this->cellW) - ((this->textSize * (int)digits.length() * FONT_SIZE_PX) / 2), this->y + (this->height * this->cellH) + this->borderHeight };
			app->DrawString(textPos, digits, WHITE, this->textSize);
		}
	}
}
