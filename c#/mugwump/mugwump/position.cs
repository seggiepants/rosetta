using System;

namespace mugwump_cs
{
    class Position
    {
        public Position()
        {
            X = 0;
            Y = 0;
            Found = false;
        }

        public void RandomPosition(Random random, int Width, int Height)
        {
            X = random.Next(0, Width - 1);
            Y = random.Next(0, Height - 1);
            Found = false;

        }

        public int X { get; private set; }

        public int Y { get; private set; }

        public bool Found { get; set; }

    }
}
