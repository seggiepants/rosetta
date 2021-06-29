using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace Mugwump_2d
{
	class Grid
	{
		Canvas surface;
		List<Color> body_colors;
		int borderWidth;
		int borderHeight;
		int cellH;
		int cellW;
		List<Point> guesses;
		int height;
		int maxGuesses;
		int textSize;
		int width;

		public Grid(Canvas app, int maxGuesses, int textSize, int borderWidth, int borderHeight)
		{
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

			this.body_colors = new List<Color>();
			this.body_colors.Add(Settings.PINK);
			this.body_colors.Add(Settings.VIOLET);
			this.body_colors.Add(Settings.LIGHT_BLUE);
			this.body_colors.Add(Settings.ORANGE);

			this.surface = app;
			this.width = (int)this.surface.ActualWidth;
			this.height = (int)this.surface.ActualHeight;
			this.textSize = textSize;
			this.borderWidth = borderWidth;
			this.borderHeight = borderHeight;
			this.maxGuesses = maxGuesses;
			//this.mugwumps = new Liist<Mugwump>();
			this.guesses = new List<Point>();
			//this->console = new Console(gameTitle, 1, this->borderWidth, this->borderHeight);
			h_ticks = new List<TextBlock>();
			v_ticks = new List<TextBlock>();
			int tick_width = 0;
			int tick_height = 0;
			for (int i = 0; i < Settings.GRID_W; i++)
			{
				TextBlock t = new TextBlock();
				t.Text = i.ToString();
				t.FontSize = this.textSize;
				tick_width = Math.Max(tick_width, (int)t.ActualWidth);
				h_ticks.Add(t);
				this.surface.Children.Add(t);
			}
			for (int i = 0; i < Settings.GRID_H; i++)
			{
				TextBlock t = new TextBlock();
				t.Text = i.ToString();
				t.FontSize = this.textSize;
				tick_height = Math.Max(tick_height, (int)t.ActualHeight);
				v_ticks.Add(t);
				this.surface.Children.Add(t);
			}

			this.cellW = (this.width - (this.borderWidth * 3) - tick_width) / Settings.GRID_W;
			this.cellH = (this.height - (this.borderHeight * 3) - tick_height) / Settings.GRID_H;
			this.cellW = this.cellH = Math.Min(this.cellW, this.cellH);

			int x = (this.width - tick_width - this.borderWidth - (this.cellW * Settings.GRID_W)) / 2;
			int y = (this.height - tick_height - this.borderHeight - (this.cellH * Settings.GRID_H)) / 2;

			for (int i = 0; i <= Settings.GRID_H; ++i)
			{
				Line line = new Line();
				line.X1 = x;
				line.X2 = x + (this.cellW * Settings.GRID_W);
				line.Y1 = y + (this.cellH * i);
				line.Y2 = y + (this.cellH * i);
				this.surface.Children.Add(line);
				if (i < Settings.GRID_H)
				{
					// Move tick to x - tick_height - this.border_width, y + (Settings.GRID_H - i) * this.cellH) - (this.cellH / 2);
				}
			}

			for (int i = 0; i <= Settings.GRID_W; ++i)
			{
				Line line = new Line();
				line.X1 = x + (this.cellW * i);
				line.X2 = x + (this.cellW * i);
				line.Y1 = y;
				line.Y2 = y + (this.cellH * Settings.GRID_H);
				this.surface.Children.Add(line);
				if (i < Settings.GRID_W)
				{
					// Move tick to x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2), y + (Settings.GRID_H - i) * this.cellH) + (this.borderWidth);
				}
			}
		}

		public void Resize()
        {
			this.surface.Children.Clear();
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

			this.width = (int)this.surface.ActualWidth;
			this.height = (int)this.surface.ActualHeight;
			h_ticks = new List<TextBlock>();
			v_ticks = new List<TextBlock>();
			int tick_width = 0;
			int tick_height = 0;
			for (int i = 0; i < Settings.GRID_W; i++)
			{
				TextBlock t = new TextBlock();
				t.Text = i.ToString();
				t.FontSize = this.textSize;
				tick_width = Math.Max(tick_width, (int)t.ActualWidth);
                h_ticks.Add(t);
            }
			for (int i = 0; i < Settings.GRID_H; i++)
			{
				TextBlock t = new TextBlock();
				t.Text = i.ToString();
				t.FontSize = this.textSize;
				tick_height = Math.Max(tick_height, (int)t.ActualHeight);
				v_ticks.Add(t);
			}

			this.cellW = (this.width - (this.borderWidth * 3) - tick_width) / Settings.GRID_W;
			this.cellH = (this.height - (this.borderHeight * 3) - tick_height) / Settings.GRID_H;
			this.cellW = this.cellH = Math.Min(this.cellW, this.cellH);

			int x = (this.width - tick_width - (this.borderWidth * 3) - (this.cellW * Settings.GRID_W)) / 2;
			int y = (this.height - tick_height - (this.borderHeight * 3) - (this.cellH * Settings.GRID_H)) / 2;

			for (int i = 0; i <= Settings.GRID_H; ++i)
			{
				Line line = new Line();
				line.X1 = x;
				line.X2 = x + (this.cellW * Settings.GRID_W);
				line.Y1 = y + (this.cellH * i);
				line.Y2 = y + (this.cellH * i);
				line.Stroke = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(0, 0, 0));
				this.surface.Children.Add(line);
				if (i < Settings.GRID_H)
				{
					// Move tick to x - tick_height - this.border_width, y + (Settings.GRID_H - i) * this.cellH) - (this.cellH / 2);
					h_ticks[i].Foreground = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(0, 0, 0));
					Canvas.SetLeft(v_ticks[i], x - tick_width - (this.borderWidth * 2));
					Canvas.SetTop(v_ticks[i], y + ((Settings.GRID_H - i) * this.cellH) - (this.cellH / 2) - this.borderWidth);
					this.surface.Children.Add(v_ticks[i]);
				}
			}

			for (int i = 0; i <= Settings.GRID_W; ++i)
			{
				Line line = new Line();
				line.X1 = x + (this.cellW * i);
				line.X2 = x + (this.cellW * i);
				line.Y1 = y;
				line.Y2 = y + (this.cellH * Settings.GRID_H);
				line.Stroke = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(0, 0, 0));
				this.surface.Children.Add(line);
				if (i < Settings.GRID_W)
				{
					// Move tick to x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2), y + (Settings.GRID_H - i) * this.cellH) + (this.borderWidth);
					h_ticks[i].Foreground = new System.Windows.Media.SolidColorBrush(System.Windows.Media.Color.FromRgb(0, 0, 0));
					Canvas.SetLeft(h_ticks[i], x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2));
					Canvas.SetTop(h_ticks[i], y + (Settings.GRID_H * this.cellH) + this.borderWidth);
					this.surface.Children.Add(h_ticks[i]);
				}
			}
		}



		/*
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
		*/
		/*
		void Click(int x, int y)
		{
			bool isGridLine = ((x % this->cellW == 0) || (y % this->cellH == 0));
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
	return (this->guesses->size() >= (size_t)this->maxGuesses) || ((size_t)mugwumpsFound == this->mugwumps->size());
}

bool Grid::isGameWon()
{
	int mugwumpsFound = std::accumulate(this->mugwumps->begin(), this->mugwumps->end(), 0, [](int total, Mugwump* mugwump) { return total + (mugwump->getFound() ? 1 : 0); });
	return (this->guesses->size() <= (size_t)this->maxGuesses) && ((size_t)mugwumpsFound == this->mugwumps->size());
}

bool Grid::isGuessOK(int x, int y)
{
	auto position = std::find_if(this->guesses->begin(), this->guesses->end(), [x, y](olc::vi2d guess) {return guess.x == x && guess.y == y; });
	return (position == this->guesses->end());
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
	this->pos.x = (int)(this->width / 2);
	this->pos.y = (int)(this->height / 2);

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

	if (this->pos.x >= 0 && this->pos.x < this->width && this->pos.y >= 0 && this->pos.y < this->height)
	{
		app->FillRect(this->x + (this->cellW * this->pos.x) + INSET_1, this->y + (this->cellH * this->pos.y) + INSET_1, this->cellW - (2 * INSET_1), this->cellH - (2 * INSET_1), TEAL);
	}

	std::for_each(this->guesses->begin(), this->guesses->end(), [app, this](olc::vi2d guess) {
		app->FillRect(this->x + (this->cellW * guess.x) + INSET_2, this->y + (this->cellH * guess.y) + INSET_2, this->cellW - (2 * INSET_2), this->cellH - (2 * INSET_2), RED);
	});

	std::for_each(this->mugwumps->begin(), this->mugwumps->end(), [app, this](Mugwump* mugwump) {
		if (mugwump->getFound())
			mugwump->Draw(app, { this->x + (this->cellW * mugwump->getX()) + 1, this->y + (this->cellH * mugwump->getY()) + 1 }, this->cellW - 2);
	});
}

         * */
	}
}
