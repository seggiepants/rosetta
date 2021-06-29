using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace Mugwump_2d
{

    class Settings
    {
        public const string GAME_TITLE = "MUGWUMP 2D";
        public const int COUNT_MUGWUMPS = 4;
        public const int MAX_GUESSES = 10;
        public const int GRID_W = 10;
        public const int GRID_H = 10;
        public const int INSET_1 = 4;
        public const int INSET_2 = 8;
        public const int FONT_SIZE_PX = 8;

        public static Color BLACK = Color.FromArgb(0, 0, 0);
        public static Color DARK_GRAY = Color.FromArgb(64, 64, 64);
        public static Color LIGHT_BLUE = Color.FromArgb(128, 128, 255);
        public static Color LIGHT_GRAY = Color.FromArgb(192, 192, 192);
        public static Color ORANGE = Color.FromArgb(255, 128, 0);
        public static Color PINK = Color.FromArgb(255, 0, 128);
        public static Color RED = Color.FromArgb(255, 0, 0);
        public static Color TEAL = Color.FromArgb(12, 140, 127);
        public static Color VIOLET = Color.FromArgb(192, 0, 255);
        public static Color WHITE = Color.FromArgb(255, 255, 255);
    }

    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
    }
}
