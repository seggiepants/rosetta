package mugwump

import kotlin.math.floor
import kotlin.math.max
import kotlin.math.pow
import kotlin.math.sqrt
import kotlin.random.Random

/**
 * MUGWUMP
 * Find four mugwumps on a 10x10 grid.
 * @author BASIC COMPUTER GAMES edited by David H. Ahl. Ported to Java by SeggiePants
 *
 */

val CONSOLE_W: Int = 80;
val GRID_W: Int = 10;
val GRID_H: Int = GRID_W;
val MAX_MUGWUMPS: Int = 4;
val MAX_TURNS: Int = 10;


fun main(args: Array<String>) {
	var mugwumps = Array<position>(MAX_MUGWUMPS) { _ -> position()}
	var line: String?
	var remaining: Int
	var turn: Int
	var x: Int
	var y: Int
	
	printIntroduction()
	while(true)	{// Iterate per game.
		turn = 0
		initMugwumps(mugwumps)
		while(true) { // Iterate per turn.
			turn++
			println()
			println()
			do {
				print("Turn No. ${turn}, what is your guess? ")
				try {
					line = readLine()
				} 
				catch (ex: Exception) {
					line = ""
				}
				var numbers: List<String> = line!!.split("\\s*,\\s*".toRegex())
				if (numbers.size >= 2) {
					try
					{
						x = numbers[0].toInt()
						y = numbers[1].toInt()
					}
					catch (ex: NumberFormatException)
					{
						x = -1
						y = -1
					}
				}
				else
				{
					x = -1
					y = -1
				}
			} while ((x < 0) || (x >= GRID_W) || (y < 0) || (y >= GRID_H))
							
			remaining = 0
			for (i in 0 until mugwumps.size) {
				if (!mugwumps[i].found) 
				{
					if ((mugwumps[i].x != x) || (mugwumps[i].y != y))
					{
						var distance: Double =  sqrt((mugwumps[i].x - x).toDouble().pow(2) + (mugwumps[i].y - y).toDouble().pow(2))
						distance = floor(distance * 100.0) / 100.0
						println("You are ${distance} units from mugwump ${i + 1}")
						remaining++
					}
					else
					{
						mugwumps[i].found = true
						println("YOU HAVE FOUND MUGWUMP ${i + 1}")							
					}
				}				
			}
			
			if (remaining == 0) {
				println("YOU GOT THEM ALL IN ${turn} TURNS.")
				break
			}
			else if (turn >= MAX_TURNS) {
				println()
				println("Sorry, that's ${turn} tries. Here is where they're hiding.")
				for(i in 0 until mugwumps.size) {
					if (!mugwumps[i].found) {
						println("Mugwump ${i} is at (${mugwumps[i].x}, ${mugwumps[i].y})")
					}
				}
				break;
			}
			
		}
		println("THAT WAS FUN!")
		do {
			print("Would you like to play again (Y/N)? ")
			try {
				line = readLine()
			} 
			catch (ex: Exception)
			{
				line = ""
			}
			line = line!!.trim().toUpperCase();				
		} while ((line!!.length == 0) || ((!line.substring(0, 1).equals("Y")) && (!line.substring(0, 1).equals("N"))))
		
		if (line.substring(0, 1).equals("N"))
		{
			break
		}
	
	}
}

/**
 * Print out a message to the console centered on the screen.
 * @param message The message to print centered. Currently assumes an 80 column console width
 */
fun centerPrint(message: String) {
	var left: Int = max(0,  (CONSOLE_W - message.length) / 2)
	for(i in 0 until left) {
		print(' ')
	}
	println(message)
}
	
/**
 * Position the mugwumps randomly on the grid (they may overlap).
 * @param mugwumps array of position objects to place on the grid.
 */
fun initMugwumps(mugwumps: Array<position>) {
	for(mugwump in mugwumps) {
		mugwump.randomPosition(GRID_W, GRID_H)
	}
}
	
/**
 * Print out a string to the console taking care to wrap on word boundaries.
 * @param left The current cursor x-coordinate on the console screen.
 * @param message The message to print on the screen in a "pretty" way.
 * @return updated x-coordinate on the screen. should be used like left = pretty_print(left, "value");
 */
fun prettyPrint(left: Int, message: String): Int {
	var x: Int = left
	for (word in message.split(Regex("\\s"))) {
		if ((x > 0) && (x < CONSOLE_W)) {
			print(" ")
			x++
		}
		
		if (x + word.length > CONSOLE_W) {
			println()
			x = 0
		}
		
		print(word)
		x += word.length
	}
	return x
}
	
/**
 * Print out the introduction to the program.
 */
fun printIntroduction() {
	centerPrint("MUGWUMP")
	centerPrint("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY")
	println()
	println()
	println()
	// Courtesy People's Computer Company
	var left: Int = 0
	left = prettyPrint(left, "The object of this game is to find four mugwumps.")
	left = prettyPrint(left, "hidden on a 10 by 10 grid. Home base is position 0, 0")
	left = prettyPrint(left, "any guess you make must be two numbers with each")
	left = prettyPrint(left, "number between 0, and 9, inclusive. First number")
	left = prettyPrint(left, "is distance to right of home base, and second number")
	prettyPrint(left, "is distance above home base.")
	println()
	println()
	left = 0
	left = prettyPrint(left, "You get 10 tries. After each try, I will tell")
	prettyPrint(left, "you how far you are from each mugwump.")
	println()
	println()
}



