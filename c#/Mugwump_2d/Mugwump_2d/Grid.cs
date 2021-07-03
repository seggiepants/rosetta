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
		readonly Canvas surface;
		readonly List<System.Windows.Media.Color> body_colors;
		readonly int borderWidth;
		readonly int borderHeight;
		int cellH;
		int cellW;
		readonly List<Point> guesses;
		int height;
		readonly int maxGuesses;
		readonly List<Mugwump> mugwumps;
		readonly int textSize;
		int width;
		Point pos;
		int x;
		int y;

		public Grid(Canvas app, int maxGuesses, int textSize, int borderWidth, int borderHeight)
		{
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

            body_colors = new List<System.Windows.Media.Color>
            {
                Settings.PINK,
                Settings.VIOLET,
                Settings.LIGHT_BLUE,
                Settings.ORANGE
            };

            surface = app;
			width = (int)surface.ActualWidth;
			height = (int)surface.ActualHeight;
			this.textSize = textSize;
			this.borderWidth = borderWidth;
			this.borderHeight = borderHeight;
			this.maxGuesses = maxGuesses;
			mugwumps = new List<Mugwump>();
			guesses = new List<Point>();
			//this->console = new Console(gameTitle, 1, this->borderWidth, this->borderHeight);
			h_ticks = new List<TextBlock>();
			v_ticks = new List<TextBlock>();
			int tick_width = 0;
			int tick_height = 0;
			for (int i = 0; i < Settings.GRID_W; i++)
			{
                TextBlock t = new TextBlock
                {
                    Text = i.ToString(),
                    FontSize = this.textSize
                };
                tick_width = Math.Max(tick_width, (int)t.ActualWidth);
				h_ticks.Add(t);
				surface.Children.Add(t);
			}
			for (int i = 0; i < Settings.GRID_H; i++)
			{
                TextBlock t = new TextBlock
                {
                    Text = i.ToString(),
                    FontSize = this.textSize
                };
                tick_height = Math.Max(tick_height, (int)t.ActualHeight);
				v_ticks.Add(t);
				surface.Children.Add(t);
			}

			cellW = (width - (this.borderWidth * 3) - tick_width) / Settings.GRID_W;
			cellH = (height - (this.borderHeight * 3) - tick_height) / Settings.GRID_H;
			cellW = cellH = Math.Min(cellW, cellH);

			NewGame(Settings.COUNT_MUGWUMPS);
		}		

		public void Draw()
        {
			surface.Children.Clear();
			List<TextBlock> h_ticks;
			List<TextBlock> v_ticks;

			width = (int)surface.ActualWidth;
			height = (int)surface.ActualHeight;
			if (width <= 0 || height <= 0)
				return;

			h_ticks = new List<TextBlock>();
			v_ticks = new List<TextBlock>();
			int tick_width = 0;
			int tick_height = 0;
			for (int i = 0; i < Settings.GRID_W; i++)
			{
                TextBlock t = new TextBlock
                {
                    Text = i.ToString(),
                    FontSize = textSize
                };
                t.Measure(new System.Windows.Size(Double.PositiveInfinity, Double.PositiveInfinity));
				tick_width = Math.Max(tick_width, (int)t.DesiredSize.Width);
                h_ticks.Add(t);
            }
			for (int i = 0; i < Settings.GRID_H; i++)
			{
                TextBlock t = new TextBlock
                {
                    Text = i.ToString(),
                    FontSize = textSize
                };
                t.Measure(new System.Windows.Size(Double.PositiveInfinity, Double.PositiveInfinity));
				tick_height = Math.Max(tick_height, (int)t.DesiredSize.Height);
				v_ticks.Add(t);
			}

			cellW = (width - (borderWidth * 3) - tick_width) / Settings.GRID_W;
			cellH = (height - (borderHeight * 3) - tick_height) / Settings.GRID_H;
			cellW = cellH = Math.Min(cellW, cellH);

			int x = (width - tick_width - (borderWidth * 3) - (cellW * Settings.GRID_W)) / 2;
			int y = (height - tick_height - (borderHeight *3) - (cellH * Settings.GRID_H)) / 2;
			this.x = x;
			this.y = y;

			// Won't get a click event for any part of the canvas you haven't drawn on, so fill the background with window background color.
			DrawUtil.Rectangle(surface, this.x, this.y, cellW * Settings.GRID_W, cellH * Settings.GRID_H, SystemColors.Window);

			for (int i = 0; i <= Settings.GRID_H; ++i)
			{
                Line line = new Line
                {
                    X1 = x,
                    X2 = x + (cellW * Settings.GRID_W),
                    Y1 = y + (cellH * i),
                    Y2 = y + (cellH * i),
                    Stroke = DrawUtil.CreateBrush(SystemColors.WindowText)
                };
                surface.Children.Add(line);
				if (i < Settings.GRID_H)
				{

					// Move tick to x - tick_height - this.border_width, y + (Settings.GRID_H - i) * this.cellH) - (this.cellH / 2);
					v_ticks[i].Foreground = DrawUtil.CreateBrush(SystemColors.WindowText);
					Canvas.SetLeft(v_ticks[i], x - tick_width - (borderWidth * 2));
					Canvas.SetTop(v_ticks[i], y + ((Settings.GRID_H - i) * cellH) - (cellH / 2) - borderWidth);
					surface.Children.Add(v_ticks[i]);
				}
			}

			for (int i = 0; i <= Settings.GRID_W; ++i)
			{
                Line line = new Line
                {
                    X1 = x + (cellW * i),
                    X2 = x + (cellW * i),
                    Y1 = y,
                    Y2 = y + (cellH * Settings.GRID_H),
                    Stroke = DrawUtil.CreateBrush(SystemColors.WindowText)
                };
                surface.Children.Add(line);
				if (i < Settings.GRID_W)
				{
					// Move tick to x + (this.cellW / 2) + (i * this.cellW) - (tick_width / 2), y + (Settings.GRID_H - i) * this.cellH) + (this.borderWidth);
					h_ticks[i].Foreground = DrawUtil.CreateBrush(SystemColors.WindowText);
					Canvas.SetLeft(h_ticks[i], x + (cellW / 2) + (i * cellW) - (tick_width / 2));
					Canvas.SetTop(h_ticks[i], y + (Settings.GRID_H * cellH) + borderWidth);
					surface.Children.Add(h_ticks[i]);
				}
			}

			if (pos.X >= 0 && pos.X < Settings.GRID_W && pos.Y >= 0 && pos.Y < Settings.GRID_H)
			{
				DrawUtil.Rectangle(surface, x + (cellW * pos.X) + Settings.INSET_1, y + (cellH * pos.Y) + Settings.INSET_1, cellW - (2 * Settings.INSET_1), cellH - (2 * Settings.INSET_1), Settings.TEAL);
			}

			foreach(Point guess in guesses)
            {
				DrawUtil.Rectangle(surface, x + (cellW * guess.X) + Settings.INSET_2, y + (cellH * guess.Y) + Settings.INSET_2, cellW - (2 * Settings.INSET_2), cellH - (2 * Settings.INSET_2), Settings.RED);
			}

			foreach(Mugwump mugwump in mugwumps)
            {
				if (mugwump.Found)
                {
					mugwump.Draw(surface, x + (cellW * mugwump.X) + 1, y + (cellH * mugwump.Y) + 1, cellW - 2);
                }
			}

			/*
			Mugwump test = new Mugwump(1, 1, true, Settings.VIOLET, Settings.WHITE, Settings.RED, Settings.BLACK);
			test.Draw(this.surface, 100, 100, 100);
			*/
		}


		~Grid()
        {

			if (mugwumps.Count > 0)
			{
				mugwumps.Clear();
			}

			if (guesses.Count > 0)	
			{
				guesses.Clear();
			}
		}
		public void Click(int x, int y)
		{
			int gridX = x - this.x;
			int gridY = y - this.y;
			bool isGridLine = ((gridX % cellW == 0) || (gridY % cellH == 0));
			if (!isGridLine && gridX > 0 && gridX < cellW * Settings.GRID_W && gridY > 0 && gridY < cellH * Settings.GRID_H)
			{
				int px = (int)(gridX / cellW);
				int py = (int)(gridY / cellH);
				pos.X = px;
				pos.Y = py; 
				Select();
			}
		}

		public int GuessCount
        {
			get
            {
				return guesses.Count;
            }
        }

		private int MugwumpsFound
        {
			get
            {
				int mugwumpsFound = 0;
				foreach (Mugwump mugwump in mugwumps)
				{
					if (mugwump.Found)
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
				return guesses;
            }
        }

		public List<Mugwump> Mugwumps
        {
			get
            {
				return mugwumps;
            }
        }

		private int FindMugwumpAt(int x, int y)
        {
			for (int i = 0; i < mugwumps.Count; ++i)
			{
				if (mugwumps[i].IsAt(x, y))
				{
					return i;
				}
			}
			return -1;
        }

		public bool IsGameOver()
		{
			int mugwumpsFound = MugwumpsFound;
			return (guesses.Count >= maxGuesses) || (mugwumpsFound == mugwumps.Count);
		}

		public bool IsGameWon()
		{
			int mugwumpsFound = MugwumpsFound;
			return (guesses.Count <= maxGuesses) && (mugwumpsFound == mugwumps.Count);
		}

		bool IsGuessOK(int x, int y)
		{
			bool matchFound = false;
			foreach (Point guess in guesses)
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
			pos.Y = Math.Min(Settings.GRID_H - 1, pos.Y + 1);
			Draw();
		}

		public void MoveLeft()
		{
			pos.X = Math.Max(0, pos.X - 1);
			Draw();
		}

		public void MoveRight()
		{
			pos.X = Math.Min(Settings.GRID_W - 1, pos.X + 1);
			Draw();
		}

		public void MoveUp()
		{
			pos.Y = Math.Max(0, pos.Y - 1);
			Draw();
		}

		public void NewGame(int numMugwumps)
		{
			Random rnd = new Random();
			guesses.Clear();
			mugwumps.Clear();
			pos.X = (int)(Settings.GRID_W / 2);
			pos.Y = (int)(Settings.GRID_H / 2);

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
					int mugwumpIDX = FindMugwumpAt(x, y);
					positionOK = (mugwumpIDX < 0);
				}
				mugwumps.Add(new Mugwump(x, y, false, color, Settings.WHITE, Settings.BLACK, Settings.BLACK));
			}
			pos.X = (int)(Settings.GRID_W / 2);
			pos.Y = (int)(Settings.GRID_H / 2);
			Draw();
		}

		public void Select()
		{
			if (IsGuessOK(pos.X, pos.Y))
			{
				guesses.Add(new Point(pos.X, pos.Y));
				int mugwumpIDX = FindMugwumpAt(pos.X, pos.Y);
				if (mugwumpIDX >= 0)
                {
					mugwumps[mugwumpIDX].Found = true;
                }
				Draw();
			}
		}
	}
}
