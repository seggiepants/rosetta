﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace Mugwump_2d
{
    public class DrawUtil
    {
        public static void Circle(Canvas canvas, int x, int y, int radius, Color color)
        {
            if (radius <= 0)
                return;
            Ellipse circle = new Ellipse
            {
                Fill = CreateBrush(color),
                Width = radius * 2,
                Height = radius * 2
            };
            Canvas.SetLeft(circle, x - radius);
            Canvas.SetTop(circle, y - radius);
            canvas.Children.Add(circle);
        }

        public static void Circle(Canvas canvas, int x, int y, int radius, System.Drawing.Color color)
        {
            Circle(canvas, x, y, radius, AdaptColor(color));
        }

        public static void Rectangle(Canvas canvas, int x, int y, int w, int h, Color color)
        {
            if (w <= 0 || h <= 0)
                return;
            Rectangle rect = new Rectangle
            {
                Fill = CreateBrush(color),
                Width = w,
                Height = h
            };
            Canvas.SetLeft(rect, x);
            Canvas.SetTop(rect, y);
            canvas.Children.Add(rect);
        }

        public static void Rectangle(Canvas canvas, int x, int y, int w, int h, System.Drawing.Color color)
        {
            Rectangle(canvas, x, y, w, h, AdaptColor(color));
        }

        private static System.Windows.Media.Color AdaptColor(System.Drawing.Color color)
        {
            return System.Windows.Media.Color.FromArgb(color.A, color.R, color.G, color.B);
        }

        public static SolidColorBrush CreateBrush(System.Drawing.Color clr)
        {
            return new SolidColorBrush(AdaptColor(clr));
        }

        public static SolidColorBrush CreateBrush(System.Windows.Media.Color clr)
        {
            return new SolidColorBrush(clr);
        }
    }

    class Settings
    {
        public const string GAME_TITLE = "MUGWUMP 2D";
        public const int COUNT_MUGWUMPS = 4;
        public const int MAX_GUESSES = 10;
        public const int GRID_W = 10;
        public const int GRID_H = 10;
        public const int INSET_1 = 4;
        public const int INSET_2 = 8;
        public const int FONT_SIZE_PX = 12;

        public static Color BLACK = Color.FromRgb(0, 0, 0);
        public static Color DARK_GRAY = Color.FromRgb(64, 64, 64);
        public static Color LIGHT_BLUE = Color.FromRgb(128, 128, 255);
        public static Color LIGHT_GRAY = Color.FromRgb(192, 192, 192);
        public static Color ORANGE = Color.FromRgb(255, 128, 0);
        public static Color PINK = Color.FromRgb(255, 0, 128);
        public static Color RED = Color.FromRgb(255, 0, 0);
        public static Color TEAL = Color.FromRgb(12, 140, 127);
        public static Color VIOLET = Color.FromRgb(192, 0, 255);
        public static Color WHITE = Color.FromRgb(255, 255, 255);
    }

    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
    }
}
