// mugwump.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdlib>
#include <iostream>
#include <iomanip>
#include <time.h>
#include <vector>

#ifdef _WIN32
#include <Windows.h>
#else
#include <sys/ioctl.h>
#include <unistd.h>
#endif

#include "mugwump.h"

#define MAX(a,b) ((a) > (b) ? (a) : (b))

/*
Print out a string centered on the console.
Parameters:
* message: The string to print.
Notes:
* Assumes console is currently at horizontal position 0.
* Will not center if the string is too wide to fit on one line.
*/
void center_print(std::string message)
{
	int con_width, con_height;
	get_console_size(con_width, con_height);
	int padding;
	padding = MAX(0, (int)std::floor((con_width - message.length()) / 2.0));
	std::cout << std::string(padding, ' ') << message << std::endl;
}

/*
Returns the width and height of the console.
Parameters:
* width: Filled with the console width
* height: Filled with the console height
*/
void get_console_size(int& width, int& height) {
#ifdef _WIN32
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
	width = (csbi.srWindow.Right - csbi.srWindow.Left + 1);
	height = (csbi.srWindow.Bottom - csbi.srWindow.Top + 1);
#else
	struct winsize w;
	ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);

	width = w.ws_col;
	height = w.ws_row;
#endif
}

/*
Initialize the vector of mugwumps to random positions on the grid.
Parameters:
* mugwumps: vector of position pointers
* GRID_W: width of the mugwump grid, goes from 0 to GRID_W - 1.
* GRID_H: height of the mugwump grid, goes from 0 to GRID_H - 1.
*/
void init_mugwumps(std::vector<Position*>& mugwumps, int GRID_W, int GRID_H)
{
	for (std::vector<Position*>::iterator it = mugwumps.begin(); it != mugwumps.end(); ++it)
	{
		(*it)->random_position(GRID_W, GRID_H);
	}
}

/* 
The game of mugwump. There are several "MUGWUMPS" on a grid. You need to find them all in a limited number of turns.
Each time through the loop you can enter a location and the computer tells you how far away you are from each remaining
mugwump. The muwumps are found when you enter their location. Find them all and you win, run out of turns and you lose.
You may play multiple games.
*/
int main()
{
	const int GRID_W = 10;
	const int GRID_H = GRID_W;
	const int MAX_MUGWUMPS = 4;
	const int MAX_TURNS = 10;
	const std::string WHITE_SPACE = " \n\r\t";

	std::vector<Position*> mugwumps;
	for (int i = 0; i < MAX_MUGWUMPS; ++i)
	{
		mugwumps.push_back(new Position());
	}

	srand((unsigned int) time(NULL));
	
	print_introduction();

	double distance = 0.0;
	int remaining = 0;
	int turn = 0;
	int x = -1;
	int y = -1;
	std::string line;

	while (true) // Loop per game
	{
		turn = 0;
		init_mugwumps(mugwumps, GRID_W, GRID_H);
		while (true) // Loop per turn
		{
			turn++;
			std::cout << std::endl;
			std::cout << std::endl;
			x = -1;
			y = -1;
			std::string line = "";
			while (x < 0 || x >= GRID_W || y < 0 || y >= GRID_H)
			{
				std::cout << "Turn No. " << turn << ", what is your guess? ";
				std::getline(std::cin, line);
				std::vector<std::string> numbers = split(line, ",");
				if (numbers.size() >= 2)
				{
					char* ptrEnd;
					errno = 0;
					x = (int) std::strtol(numbers[0].c_str(), &ptrEnd, 10);
					if (errno == ERANGE || *ptrEnd != '\0') 
					{
						x = -1;
					}
					errno = 0;
					y = (int)std::strtol(numbers[1].c_str(), &ptrEnd, 10);
					if (errno == ERANGE || *ptrEnd != '\0')
					{
						y = -1;
					}
				}
			}

			remaining = 0;
			int i = 0;
			for (std::vector<Position*>::iterator it = mugwumps.begin(); it != mugwumps.end(); ++it)
			{
				i++;
				if (!(*it)->get_found())
				{
					if ((*it)->get_x() != x || (*it)->get_y() != y)
					{
						remaining++;
						distance = std::sqrt(std::pow((*it)->get_x() - x, 2) + std::pow((*it)->get_y() - y, 2));
						std::cout << "You are " << std::fixed << std::setprecision(2) << distance << " units from mugwump " << i << std::endl;
					}
					else
					{
						(*it)->set_found(true);
						std::cout << "YOU HAVE FOUND MUGWUMP " << i << std::endl;
					}
				}
			}

			if (remaining == 0)
			{
				std::cout << "YOU GOT THEM ALL IN " << turn << " TURNS!" << std::endl;
				break;
			}
			else if (turn >= MAX_TURNS)
			{
				std::cout << std::endl << "Sorry, that's " << turn << " tries. Here is where they're hiding." << std::endl;
				i = 0;
				for (std::vector<Position*>::iterator it = mugwumps.begin(); it != mugwumps.end(); ++it)
				{
					i++;
					if (!(*it)->get_found())
					{
						std::cout << "Mugwump " << i << " is at (" << (*it)->get_x() << ", " << (*it)->get_y() << ")" << std::endl;
					}
				}
				break;
			}
		}

		std::cout << "THAT WAS FUN!" << std::endl;
		line = "";
		while (line.length() == 0 || (line[0] != 'Y' && line[0] != 'N'))
		{
			std::cout << "Would you like to play again (Y/N)? ";
			std::getline(std::cin, line);
			trim(line, WHITE_SPACE);
			upper_case(line);
		}

		if (line[0] == 'N')
		{
			break;
		}
	}

	// Free memory.
	for (std::vector<Position*>::iterator it = mugwumps.begin(); it != mugwumps.end(); ++it)
	{
		delete (*it);
	}
	mugwumps.clear();
}

/*
Print out a message to the console, but putting in smart line breaks when a word would cross the console width.
Parameters:
* left - The current position of the cursor on the console 0 to console width - 1
* message - The text to print to the console.
*/
unsigned int pretty_print(unsigned int left, const std::string& message)
{
	int con_width, con_height;
	get_console_size(con_width, con_height);

	std::vector<std::string> words = split(message, " ");

	for (std::vector<std::string>::iterator it = words.begin(); it != words.end(); ++it)
	{
		if (left > 0 && left < (unsigned int)con_width)
		{
			std::cout << " ";
			left++;
		}

		if (left + (*it).length() > (unsigned int)con_width)
		{
			std::cout << std::endl;
			left = 0;
		}
		std::cout << *it;
		left += (*it).length();
	}
	return left;
}

/*
Print out the introduction to the game.
*/
void print_introduction()
{
	center_print("MUGWUMP");
	center_print("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY");
	std::cout << std::endl;
	std::cout << std::endl;
	std::cout << std::endl;
	// Courtesy People's Computer Company
	unsigned int left = 0;
	left = pretty_print(left, "The object of this game is to find four mugwumps.");
	left = pretty_print(left, "hidden on a 10 by 10 grid. Home base is position 0, 0");
	left = pretty_print(left, "any guess you make must be two numbers with each");
	left = pretty_print(left, "number between 0, and 9, inclusive. First number");
	left = pretty_print(left, "is distance to right of home base, and second number");
	left = pretty_print(left, "is distance above home base.");
	std::cout << std::endl;
	std::cout << std::endl;
	left = 0;
	left = pretty_print(left, "You get 10 tries. After each try, I will tell");
	left = pretty_print(left, "you how far you are from each mugwump.");
	std::cout << std::endl;
	std::cout << std::endl;
}

/*
Split a string into a vector of strings based on a given delimiter.
Parameters:
* str: The string to split.
* delim: The delimiter to split the string on.
Notes:
* I stole this from stack overflow.
* You cannot escape the delimiter
* Delimiter may be more than one character, but you may not specify more than one delimiter.
*/
std::vector<std::string> split(const std::string& str, const std::string& delim)
{
	std::vector<std::string> tokens;
	size_t prev = 0, pos = 0;
	do
	{
		pos = str.find(delim, prev);
		if (pos == std::string::npos) pos = str.length();
		std::string token = str.substr(prev, pos - prev);
		if (!token.empty()) tokens.push_back(token);
		prev = pos + delim.length();
	} while (pos < str.length() && prev < str.length());
	return tokens;
}

/*
Trim excess white space from a string.
Parameters:
* s - The string to remove whitespace from.
* white_space - white space characters to remove.
Notes:
* I sote this from stack overflow too.
* This mutates the original string. You do not get a copy back.
*/
void trim(std::string& s, const std::string& white_space)
{
	s.erase(0, s.find_first_not_of(white_space));
	s.erase(s.find_last_not_of(white_space) + 1);
}

/* 
Change a string into an upper case version of itself.
Parameters:
* s - The string to change to upper case.
Notes:
* Yet another function stolen from Stack Overflow that really ought to be in the standard C++ library
* Mutates the original string, does not return a copy.
*/
void upper_case(std::string& s)
{
	for (char &c : s)
	{
		c = std::toupper(c);
	}
}
