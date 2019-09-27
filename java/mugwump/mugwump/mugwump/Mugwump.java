package mugwump;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Random;

/**
 * MUGWUMP
 * Find four mugwumps on a 10x10 grid.
 * @author BASIC COMPUTER GAMES edited by David H. Ahl. Ported to Java by SeggiePants
 *
 */


public class Mugwump {
	
	private static final int CONSOLE_W = 80;
	private static final int GRID_W = 10;
	private static final int GRID_H = GRID_W;
	private static final int MAX_MUGWUMPS = 4;
	private static final int MAX_TURNS = 10;
	
	/**
	 * System entry point to the game.
	 * @param args Arguments to the program (not used).
	 */
	public static void main(String[] args)
	{
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
		Position[] mugwumps = new Position[MAX_MUGWUMPS];
		String line;
		int remaining;
		int turn;
		int x, y;
		for(int i = 0; i < mugwumps.length; i++)
		{
			mugwumps[i] = new Position();
		}
		
		print_introduction();
		while(true)	// Iterate per game.
		{
			turn = 0;
			init_mugwumps(mugwumps);
			while(true) // Iterate per turn.
			{
				turn++;
				System.out.println();
				System.out.println();
				do {
					System.out.print(String.format("Turn No. %d, what is your guess? ",  turn));
					try {
						line = in.readLine();
					} 
					catch (IOException e)
					{
						line = "";
					}
					String[] numbers = line.split(",");
					if (numbers.length >= 2)
					{
						try
						{
							x = Integer.parseInt(numbers[0].trim());
							y = Integer.parseInt(numbers[1].trim());
						}
						catch (NumberFormatException ex)
						{
							x = -1;
							y = -1;
						}
					}
					else
					{
						x = -1;
						y = -1;
					}
				} while ((x < 0) || (x >= GRID_W) || (y < 0) || (y >= GRID_H));
								
				remaining = 0;
				for (int i = 0; i < mugwumps.length; i++) 
				{
					if (!mugwumps[i].getFound()) 
					{
						if ((mugwumps[i].getX() != x) || (mugwumps[i].getY() != y))
						{
							double distance = Math.sqrt(Math.pow((mugwumps[i].getX() - x), 2) + Math.pow((mugwumps[i].getY() - y), 2));
							System.out.println(String.format("You are %1.2f units from mugwump %d", distance, i + 1));
							remaining++;
						}
						else
						{
							mugwumps[i].setFound(true);
							System.out.println(String.format("YOU HAVE FOUND MUGWUMP %d",  i + 1));							
						}
					}
					
				}
				
				if (remaining == 0)
				{
					System.out.println(String.format("YOU GOT THEM ALL IN %d TURNS.",  turn));
					break;
				}
				else if (turn >= MAX_TURNS) 
				{
					System.out.println();
					System.out.println(String.format("Sorry, that's %d tries. Here is where they're hiding.",  turn));
					for(int i = 0; i < mugwumps.length; i++)
					{
						if (!mugwumps[i].getFound())
						{
							System.out.println(String.format("Mugwump %d is at (%d, %d)", i, mugwumps[i].getX(), mugwumps[i].getY()));
						}
					}
					break;
				}
				
			}
			System.out.println("THAT WAS FUN!");
			do
			{
				System.out.print("Would you like to play again (Y/N)? ");
				try {
					line = in.readLine();
				} 
				catch (IOException e)
				{
					line = "";
				}
				line = line.trim().toUpperCase();				
			} while ((line.length() == 0) || ((!line.substring(0, 1).equals("Y")) && (!line.substring(0, 1).equals("N"))));
			
			if (line.substring(0, 1).equals("N"))
			{
				break;
			}

		}		
		
	}
	
	/**
	 * Print out a message to the console centered on the screen.
	 * @param message The message to print centered. Currently assumes an 80 column console width
	 */
	private static void center_print(String message) 
	{
		int left = Math.max(0,  (CONSOLE_W - message.length()) / 2);
		for(int i = 0; i < left; i++) {
			System.out.print(' ');
		}
		System.out.println(message);		
	}
	
	/**
	 * Position the mugwumps randomly on the grid (they may overlap).
	 * @param mugwumps array of position objects to place on the grid.
	 */
	private static void init_mugwumps(Position[] mugwumps)
	{
		Random r = new Random();
		for(Position mugwump: mugwumps)
		{
			mugwump.RandomPosition(r, GRID_W, GRID_H);
		}
	}
	
	/**
	 * Print out a string to the console taking care to wrap on word boundaries.
	 * @param left The current cursor x-coordinate on the console screen.
	 * @param message The message to print on the screen in a "pretty" way.
	 * @return updated x-coordinate on the screen. should be used like left = pretty_print(left, "value");
	 */
	private static int pretty_print(int left, String message)
	{
		for (String word : message.split("\\s"))
		{
			if (left > 0 && left < CONSOLE_W)
			{
				System.out.print(" ");
				left++;
			}
			
			if (left + word.length() > CONSOLE_W)
			{
				System.out.println();
				left = 0;
			}
			
			System.out.print(word);
			left += word.length();
		}
		return left;
	}
	
	/**
	 * Print out the introduction to the program.
	 */
	private static void print_introduction() 
	{
		center_print("MUGWUMP");
		center_print("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY");
		System.out.println();
		System.out.println();
		System.out.println();
		// Courtesy People's Computer Company
		int left = 0;
		left = pretty_print(left, "The object of this game is to find four mugwumps.");
		left = pretty_print(left, "hidden on a 10 by 10 grid. Home base is position 0, 0");
		left = pretty_print(left, "any guess you make must be two numbers with each");
		left = pretty_print(left, "number between 0, and 9, inclusive. First number");
		left = pretty_print(left, "is distance to right of home base, and second number");
		left = pretty_print(left, "is distance above home base.");
		System.out.println();
		System.out.println();
		left = 0;
		left = pretty_print(left, "You get 10 tries. After each try, I will tell");
		left = pretty_print(left, "you how far you are from each mugwump.");
		System.out.println();
		System.out.println();
	}
}
