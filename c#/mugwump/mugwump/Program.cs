using System;

namespace mugwump_cs
{
    class mugwump
    {
        //  MUGWUMP
        // =======
        // CREATIVE COMPUTING  MORRISTOWN, New JERSEY
        // Courtesy People's Computer Company
        // 
        // Adapted by SeggiePants from the book "BASIC COMPUTER GAMES" Edited by David H. Ahl
        // 
        // Can be found online at:  https://www.atariarchives.org/basicgames/showpage.php?page=114

        // Global Constants
        const int NUM_MUGWUMPS = 4;
        const int GRID_W = 10;
        const int GRID_H = GRID_W;

        static Position[] Pos = new Position[NUM_MUGWUMPS];

        static void Main(string[] args)
        {

            char[] delim = { ',' };
            double distance;
            int i;
            string[] items;
            string line;
            string playAgain;
            int remaining;
            int turn;
            int x = 0;
            int y = 0;

            for(i = 0; i < NUM_MUGWUMPS; i++)
            {
                Pos[i] = new Position();
            }

            // Show the introductory text.
            PrintIntroduction();

            while (true) // Loop for each game run
            {
                // Position the MugWumps
                InitMugwumps();
                turn = 1; // First turn

                while (true) // Single Game loop
                {
                    Console.WriteLine("");
                    Console.WriteLine("");

                    // Get coordinates from the user.
                    do
                    {
                        Console.Write(string.Format("Turn No. {0} what is your guess? ", turn));
                        // Input location
                        line = Console.ReadLine();
                        items = line.Split(delim);
                        if (items.Length >= 2)
                        {
                            if (!int.TryParse(items[0], out x))
                            {
                                x = -1;
                            }

                            if (!int.TryParse(items[1], out y))
                            {
                                y = -1;
                            }
                        }
                    }
                    while (x < 0 || x >= GRID_W || y < 0 || y >= GRID_H);

                    // Check to see if you found a mugwump, report how far away you are otherwise.
                    for (i = 0; i < Pos.Length; i++) {
                        if (!Pos[i].Found) {
                            if (Pos[i].X != x || Pos[i].Y != y) {
                                distance = Math.Sqrt(Math.Pow(Pos[i].X - x, 2) + Math.Pow(Pos[i].Y - y, 2));
                                Console.WriteLine("You are {0} units from Mugwump {1}", distance.ToString("0.##"), i + 1, x, y);
                            } else {
                                Pos[i].Found = true;
                                Console.WriteLine(String.Format("YOU HAVE FOUND MUGWUMP {0}", i + 1));
                            }
                        }
                    }

                    // Increment turn And find how many mugwumps remaining.
                    turn++;
                    remaining = 0;
                    foreach (Position mugwump in Pos)
                    {
                        if (!mugwump.Found) {
                            remaining++;
                        }
                    }

                    if (remaining == 0) {
                        // Win State
                        Console.WriteLine();
                        Console.WriteLine(String.Format("YOU GOT THEM ALL IN {0} TURNS!", turn));
                        break;
                    }
                    else if (turn >= 10)
                    {
                        // Lose State
                        Console.WriteLine();
                        PrettyPrint("SORRY, THAT'S 10 TRIES, HERE IS WHERE THEY'RE HIDING");
                        Console.WriteLine();
                        for (i = 0; i < Pos.Length; i++)
                        {
                            if (Pos[i].Found == false) {
                                Console.WriteLine(String.Format("MUGWUMP {0} IS AT ({1}, {2})", i + 1, Pos[i].X, Pos[i].Y));
                            }
                        }
                        break;
                    }
                }
                    
                // Would you Like to play again.
                Console.WriteLine();
                Console.WriteLine("THAT WAS FUN!");

                // Loop until you get Y Or N
                do
                {
                    Console.Write("Would you like to play again? (Y/N) ");
                    playAgain = Console.ReadLine().Trim().ToUpper().Substring(0, 1);
                } while (playAgain != "Y" && playAgain != "N");

                // Break out if you don't want to play anymore.
                if (playAgain == "N") {
                    break;
                }

                // Prepare to restart the game.
                Console.WriteLine("FOUR MORE MUGWUMPS ARE NOW IN HIDING.");
            }
        }

        /// <summary>
        /// Print MESSAGE$ centered on the display.
        /// </summary>
        /// <param name="message">The value to print centered on the display.</param>
        /// 
        static void CenterPrint(string message) {
            Console.CursorLeft = Math.Max(0, (Console.WindowWidth - message.Length) / 2);
            Console.WriteLine(message);
        }

        /// <summary>
        /// Initialize the position of the MUGWUMPS
        /// </summary>
        static void InitMugwumps() {
            Random r = new Random();

            foreach (Position mugwump in Pos)
            {
                mugwump.RandomPosition(r, GRID_W, GRID_H);
            }

        }

        /// <summary>
        /// Print out a message in a pretty way by splitting characters on word
        /// boundaries And attempting to keep whole words on a line.
        /// </summary>
        /// <param name="message">The message to print.</param>
        static void PrettyPrint(string message)
        {
            string[] words;
            char[] delim = { ' ' }; // Will let tab, carriage return and line feed pass through as-is

            words = message.Split(delim);
            foreach (string word in words) {
                if (Console.CursorLeft > 0 && Console.CursorLeft < Console.WindowWidth)
                {
                    Console.Write(" ");
                }
                if (Console.CursorLeft + word.Length >= Console.WindowWidth)
                {
                    Console.WriteLine();
                }
                Console.Write(word);
            }
        }

        /// <summary>
        /// Print the program introduction
        /// </summary>
        static void PrintIntroduction() {
            Console.Clear();
            CenterPrint("MUGWUMP");
            CenterPrint("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY");
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine();

            // Courtesy People's Computer Company
            PrettyPrint("The object of this game is to find four Mugwumps ");
            PrettyPrint("hidden on a 10 by 10 grid. Home base is position 0, 0. ");
            PrettyPrint("Any guess you make must be two numbers with each ");
            PrettyPrint("number between 0 and 9 inclusive. The first number ");
            PrettyPrint("is the distance to the right of home base and the second number ");
            PrettyPrint("is distance above home base.");
            Console.WriteLine();
            Console.WriteLine();
            PrettyPrint("You get 10 tries. After each try, I will tell ");
            PrettyPrint("you how far you are from each Mugwump.");
            Console.WriteLine();
            Console.WriteLine();
        }
    }
}
