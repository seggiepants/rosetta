#include <stdio.h>		// printf, scanf
#include <stdlib.h>		// rand
#include <string.h>		// sprintf, strlen
#include <ctype.h>		// isspace
#include <math.h>		// sqrt

#include "mugwump.h"	// function declarations.

//  MUGWUMP
// =======
// CREATIVE COMPUTING  MORRISTOWN, New JERSEY
// Courtesy People's Computer Company
// 
// Adapted by SeggiePants from the book "BASIC COMPUTER GAMES" Edited by David H. Ahl
// 
// Can be found online at:  https://www.atariarchives.org/basicgames/showpage.php?page=114

int left = 0;

int main()
{
	position Pos[NUM_MUGWUMPS];
	float distance;
	int i;
	char* ch;
	char playAgain;
	char buffer[BUFFER_SIZE];
	int remaining;
	int turn;
	int x = 0;
	int y = 0;

	for (i = 0; i < NUM_MUGWUMPS; i++)
	{
		Pos[i].x = 0;
		Pos[i].y = 0;
		Pos[i].found = FALSE;
	}

	// Show the introductory text.
	PrintIntroduction();

	while (1 == 1) // Loop for each game run
	{
		// Position the MugWumps
		InitMugwumps(Pos);
		
		turn = 1; // First turn

		while (1 == 1) // Single Game loop
		{
			printf("\r\n");
			printf("\r\n");

			// Get coordinates from the user.
			do
			{
				printf("Turn No. %d what is your guess? ", turn);
				#ifdef _WIN32 
				scanf_s("%d,%d", &x, &y, BUFFER_SIZE);
				#else
				scanf("%d,%d", &x, &y);
				#endif
			} while (x < 0 || x >= GRID_W || y < 0 || y >= GRID_H);

			// Check to see if you found a mugwump, report how far away you are otherwise.
			for (i = 0; i < NUM_MUGWUMPS; i++) {
				if (Pos[i].found == FALSE) {
					if (Pos[i].x != x || Pos[i].y != y) {
						distance = (float) sqrt(pow(Pos[i].x - x, 2) + pow(Pos[i].y - y, 2));
						printf("You are %0.2f units from Mugwump %d\r\n", distance, i + 1);
					}
					else {
						Pos[i].found = TRUE;
						printf("YOU HAVE FOUND MUGWUMP %d\r\n", i + 1);
					}
				}
			}

			// find how many mugwumps remaining.
			remaining = 0;
			for (i = 0; i < NUM_MUGWUMPS; i++)
			{
				if (Pos[i].found == FALSE) {
					remaining++;
				}
			}

			if (remaining == 0) {
				// Win State
				printf("\r\n");
				printf("YOU GOT THEM ALL IN %d TURNS!\r\n", turn);
				break;
			}
			else if (turn >= 10)
			{
				// Lose State
				printf("\r\n");
				left = 0;
				PrettyPrint("SORRY, THAT'S 10 TRIES, HERE IS WHERE THEY'RE HIDING");
				printf("\r\n");
				left = 0;
				for (i = 0; i < NUM_MUGWUMPS; i++)
				{
					if (Pos[i].found == FALSE) {
						printf("MUGWUMP %d IS AT (%d, %d)\r\n", i + 1, Pos[i].x, Pos[i].y);
					}
				}
				break;
			}
			turn++; // Increment turn count.
		}

		// Would you Like to play again.
		printf("\r\n");
		printf("THAT WAS FUN!\r\n");

		// Loop until you get Y Or N
		do
		{
			printf("Would you like to play again? (Y/N) ");
			#ifdef _WIN32
			scanf_s("%s", buffer, BUFFER_SIZE);
			#else
			scanf("%s", buffer);
			#endif
			ch = buffer;
			while (isspace(*ch)) {
				ch++;
			}
			playAgain = toupper(*ch);
		} while (playAgain != 'Y' && playAgain != 'N');

		// Break out if you don't want to play anymore.
		if (playAgain == 'N') {
			break;
		}

		// Prepare to restart the game.
		printf("FOUR MORE MUGWUMPS ARE NOW IN HIDING.\r\n");
	}

	return 0;
}

// Print MESSAGE$ centered on the display.
// Parameters:
// * message - The value to print centered on the display
// 
void CenterPrint(char *message) {
	int i, left;
	left = MAX(0, (CONSOLE_W - strlen(message)) / 2);
	for (i = 0; i < left; i++)
	{
		printf(" ");
	}
	printf("%s\r\n", message);
}

// Initialize the position of the MUGWUMPS
// 
void InitMugwumps(position* Pos) {
	int i;
	for (i = 0; i < NUM_MUGWUMPS; i++)
	{
		Pos[i].x = rand() % GRID_W;
		Pos[i].y = rand() % GRID_H;
		Pos[i].found = FALSE;
	}
}

// Print out a message in a pretty way by splitting characters on word
// boundaries And attempting to keep whole words on a line.
// Parameters:
// * message - The message to print.
//
void PrettyPrint(char* message)
{
	char* start;
	char* end;
	char buffer[BUFFER_SIZE];
	int word_length;

	start = message;
	end = start;
	while (*start != '\0')
	{
		while (*end != '\0' && *end != ' ') {
			end++;
		}
		word_length = end - start;
		#ifdef _WIN32
		strncpy_s(buffer, BUFFER_SIZE, start, word_length);
		#else
		strncpy(buffer, start, word_length);
		#endif
		buffer[word_length] = '\0'; // Zero terminator.
		
		if (left > 0 && left < CONSOLE_W)
		{
			printf(" ");
			left++;
		}
		if (left + word_length >= CONSOLE_W)
		{
			printf("\r\n");
			left = 0;
		}
		printf("%s", buffer);
		left += word_length;
		if (*end != '\0')
		{
			end++;
		}
		start = end;
	}
}

// Print the program introduction
// 
void PrintIntroduction() {
	CenterPrint("MUGWUMP");
	CenterPrint("CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY");
	printf("\r\n");
	printf("\r\n");
	printf("\r\n");

	// Courtesy People's Computer Company
	PrettyPrint("The object of this game is to find four Mugwumps");
	PrettyPrint("hidden on a 10 by 10 grid. Home base is position 0, 0. ");
	PrettyPrint("Any guess you make must be two numbers with each ");
	PrettyPrint("number between 0 and 9 inclusive. The first number ");
	PrettyPrint("is the distance to the right of home base and the second number ");
	PrettyPrint("is distance above home base.");
	printf("\r\n");
	printf("\r\n");
	left = 0;
	PrettyPrint("You get 10 tries. After each try, I will tell ");
	PrettyPrint("you how far you are from each Mugwump.");
	printf("\r\n");
	printf("\r\n");
	left = 0;
}

