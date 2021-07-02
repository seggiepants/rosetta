using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;

namespace Mugwump_2d
{
	class Grid
	{
		Canvas surface;
		List<System.Windows.Media.Color> body_colors;
		int borderWidth;
		int borderHeight;
		int cellH;
		int cellW;
		List<Point> guesses;
		int height;
		int maxGuesses;
		List<Mugwump> mugwumps;
		int textSize;
		int width;
		Point pos;
		int x;
		int y;

		public Grid(Canvas app, int maxGuesses, int textSize, int borderWidth, int borderHeight)
		{
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

			this.body_colors = new List<System.Windows.Media.Color>();
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
			this.mugwumps = new List<Mugwump>();
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

			this.NewGame(Settings.COUNT_MUGWUMPS);
		}		

		public void Draw()
        {
			this.surface.Children.Clear();
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

			this.width = (int)this.surface.ActualWidth;
			this.height = (int)this.surface.ActualHeight;
			if (this.width <= 0 || this.height <= 0)
				return;

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
			this.x = x;
			this.y = y;

			for (int i = 0; i <= Settings.GRID_H; ++i)
			{
				Line line = new Line();
				line.X1 = x;
				line.X2 = x + (this.cellW * Settings.GRID_W);
				line.Y1 = y + (this.cellH * i);
				line.Y2 = y + (this.cellH * i);
				line.Stroke = DrawUtil.CreateBrush(SystemColors.WindowText);
				this.surface.Children.Add(line);
				if (i < Settings.GRID_H)
				{

					// Move tick to x - tick_height - this.border_width, y + (Settings.GRID_H - i) * this.cellH) - (this.cellH / 2);
					h_ticks[i].Foreground = DrawUtil.CreateBrush(SystemColors.WindowText);
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
				line.Stroke = DrawUtil.CreateBrush(SystemColors.WindowText);
				this.surface.Children.Add(line);
				if (i < Settings.GRID_W)
				{
					// Move tick to x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2), y + (Settings.GRID_H - i) * this.cellH) + (this.borderWidth);
					h_ticks[i].Foreground = DrawUtil.CreateBrush(SystemColors.WindowText);
					Canvas.SetLeft(h_ticks[i], x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2));
					Canvas.SetTop(h_ticks[i], y + (Settings.GRID_H * this.cellH) + this.borderWidth);
					this.surface.Children.Add(h_ticks[i]);
				}
			}

			if (this.pos.X >= 0 && this.pos.X < Settings.GRID_W && this.pos.Y >= 0 && this.pos.Y < Settings.GRID_H)
			{
				DrawUtil.Rectangle(this.surface, x + (this.cellW * this.pos.X) + Settings.INSET_1, y + (this.cellH * this.pos.Y) + Settings.INSET_1, this.cellW - (2 * Settings.INSET_1), this.cellH - (2 * Settings.INSET_1), Settings.TEAL);
			}

			foreach(Point guess in this.guesses)
            {
				DrawUtil.Rectangle(this.surface, x + (this.cellW * guess.X) + Settings.INSET_2, y + (this.cellH * guess.Y) + Settings.INSET_2, this.cellW - (2 * Settings.INSET_2), this.cellH - (2 * Settings.INSET_2), Settings.RED);
			}

			foreach(Mugwump mugwump in this.mugwumps)
            {
				if (mugwump.found)
                {
					mugwump.Draw(this.surface, x + (this.cellW * mugwump.x) + 1, y + (this.cellH * mugwump.y) + 1, this.cellW - 2);
                }
			}

			/*
			Mugwump test = new Mugwump(1, 1, true, Settings.VIOLET, Settings.WHITE, Settings.RED, Settings.BLACK);
			test.Draw(this.surface, 100, 100, 100);
			*/
		}


		~Grid()
        {

			if (this.mugwumps.Count > 0)
			{
				this.mugwumps.Clear();
			}

			if (this.guesses.Count > 0)	
			{
				this.guesses.Clear();
			}
		}
		void Click(int x, int y)
		{
			int gridX = x - this.x;
			int gridY = y - this.y;
			bool isGridLine = ((gridX % this.cellW == 0) || (gridY % this.cellH == 0));
			if (gridX > 0 && gridX < this.cellW * Settings.GRID_W && gridY > 0 && gridY < this.cellH * Settings.GRID_H)
			{
				int px = (int)(gridX / this.cellW);
				int py = (int)(gridY / this.cellH);
				this.pos.X = px;
				this.pos.Y = py; 
				this.Select();
			}
		}

		public int GuessCount
        {
			get
            {
				return this.guesses.Count;
            }
        }

		private int MugwumpsFound
        {
			get
            {
				int mugwumpsFound = 0;
				foreach (Mugwump mugwump in this.mugwumps)
				{
					if (mugwump.found)
					{
						mugwumpsFound++;
					}
				}
				return mugwumpsFound;
			}
        }

		public List<Point> Guesses
        {
			get
            {
				return this.guesses;
            }
        }

		public List<Mugwump> Mugwumps
        {
			get
            {
				return this.mugwumps;
            }
        }

		private int FindMugwumpAt(int x, int y)
        {
			for (int i = 0; i < this.mugwumps.Count; ++i)
			{
				if (this.mugwumps[i].isAt(x, y))
				{
					return i;
				}
			}
			return -1;
        }

		bool isGameOver()
		{
			int mugwumpsFound = MugwumpsFound;
			return (this.guesses.Count >= this.maxGuesses) || (mugwumpsFound == this.mugwumps.Count);
		}

		bool isGameWon()
		{
			int mugwumpsFound = MugwumpsFound;
			return (this.guesses.Count <= this.maxGuesses) && (mugwumpsFound == this.mugwumps.Count);
		}

		bool isGuessOK(int x, int y)
		{
			bool matchFound = false;
			foreach (Point guess in this.guesses)
			{
				if (guess.X == x && guess.Y == y)
				{
					matchFound = true;
					break;
				}
			}
			return !matchFound;
		}

		public void MoveDown()
		{
			this.pos.Y = Math.Min(Settings.GRID_H - 1, this.pos.Y + 1);
			this.Draw();
		}

		public void MoveLeft()
		{
			this.pos.X = Math.Max(0, this.pos.X - 1);
			this.Draw();
		}

		public void MoveRight()
		{
			this.pos.X = Math.Min(Settings.GRID_W - 1, this.pos.X + 1);
			this.Draw();
		}

		public void MoveUp()
		{
			this.pos.Y = Math.Max(0, this.pos.Y - 1);
			this.Draw();
		}

		public void NewGame(int numMugwumps)
		{
			Random rnd = new Random();
			this.guesses.Clear();
			this.mugwumps.Clear();
			this.pos.X = (int)(Settings.GRID_W / 2);
			this.pos.Y = (int)(Settings.GRID_H / 2);

			for (int i = 0; i < numMugwumps; i++)
			{
				bool positionOK = false;
				int x = 0;
				int y = 0;
				System.Windows.Media.Color color;

				while (!positionOK)
				{
					x = rnd.Next(0, Settings.GRID_W);
					y = rnd.Next(0, Settings.GRID_H);
					color = body_colors[i % body_colors.Count];
					positionOK = true;
					int mugwumpIDX = this.FindMugwumpAt(x, y);
					positionOK = (mugwumpIDX < 0);
				}
				this.mugwumps.Add(new Mugwump(x, y, false, color, Settings.WHITE, Settings.BLACK, Settings.BLACK));
			}
			this.pos.X = (int)(Settings.GRID_W / 2);
			this.pos.Y = (int)(Settings.GRID_H / 2);
			this.Draw();
		}

		public void Select()
		{
			int x = this.pos.X;
			int y = this.pos.Y;
			if (this.isGuessOK(this.pos.X, this.pos.Y))
			{
				this.guesses.Add(new Point(this.pos.X, this.pos.Y));
				int mugwumpIDX = FindMugwumpAt(this.pos.X, this.pos.Y);
				if (mugwumpIDX >= 0)
                {
					this.mugwumps[mugwumpIDX].found = true;
                }
				this.Draw();
			}
		}
	}
}
