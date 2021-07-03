using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;

namespace Mugwump_2d
{
    class Mugwump
    {
        public int X { get; set; }
        public int Y { get; set; }
        public bool Found { get; set; }
        Color color;
        Color eyeColor;
        Color pupilColor;
        Color mouthColor;

        public Mugwump(int x, int y, bool found, Color color, Color eyeColor, Color pupilColor, Color mouthColor)
        {
            this.X = x;
            this.Y = y;
            this.Found = found;
            this.color = color;
            this.eyeColor = eyeColor;
            this.pupilColor = pupilColor;
            this.mouthColor = mouthColor;
        }

        public void Draw(Canvas surface, int x, int y, int size)
        {
            int centerX = x + (int)(size / 2.0);
            int centerY = y + (int)(size / 2.0);
            int eyeDx = (int)(size / 4.0);
            int eyeDy = (int)(size / 4.0);

            DrawUtil.Circle(surface, centerX, centerY, (int)(size / 2), color);                         // Body
            DrawUtil.Circle(surface, centerX - eyeDx, centerY - eyeDy, (int)(size / 5), eyeColor);      // Eyes
            DrawUtil.Circle(surface, centerX + eyeDx, centerY - eyeDy, (int)(size / 5), eyeColor);
            DrawUtil.Circle(surface, centerX - eyeDx, centerY - eyeDy, (int)(size / 10), pupilColor);   // Pupils
            DrawUtil.Circle(surface, centerX + eyeDx, centerY - eyeDy, (int)(size / 10), pupilColor);
            DrawUtil.Circle(surface, centerX, centerY + (int)(eyeDy / 2), (int)(size / 6), mouthColor); // Mouth
        }


        public bool IsAt(int x, int y)
        {
            return this.X == x && this.Y == y;
        }        
    }
}
