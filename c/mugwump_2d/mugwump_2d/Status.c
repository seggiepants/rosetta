#include "Status.h"
#include "Settings.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void Status_Init(Status* status, char* gameTitle, int fontSize, int fontSizeLarge, int borderWidth, int borderHeight)
{
	status->gameTitle = (char*)(malloc(sizeof(char) * (size_t)(sizeof(char) * (strlen(gameTitle) + 1))));
	if (status->gameTitle)
		strcpy(status->gameTitle, gameTitle);
	else
	{
		perror("Unable to allocate memory for game title name.");
		exit(1);
	}
	status->fontSize = fontSize;
	status->fontSizeLarge = fontSizeLarge;
	status->borderWidth = borderWidth;
	status->borderHeight = borderHeight;
}

void Status_Destroy(Status* status)
{
	free((void*)status->gameTitle);
	status->gameTitle = NULL;
}

void Status_Draw(Status* status, int numGuesses, int maxGuesses, Vector2* guesses, int numMugwumps, Mugwump* mugwumps)
{
	// Draw the title
	char buffer[BUFFER_MAX];
	Vector2 textSize;

	int y = status->borderHeight;
	int x = GetScreenWidth() / 2;
	textSize = MeasureTextEx(GetFontDefault(), status->gameTitle, (float)status->fontSizeLarge, 1.0);
	DrawText(status->gameTitle, x - (int)(textSize.x / 2), y, status->fontSizeLarge, CLR_WHITE);
	y += status->borderHeight + (int)textSize.y;

	if (numGuesses > 0)
	{
		// Draw the info display.		
		for (int i = 0; i < numMugwumps; i++)
		{
			x = status->borderWidth;
			sprintf(buffer, "#%d ", i + 1);
			textSize = MeasureTextEx(GetFontDefault(), buffer, (float)status->fontSize, 1.0);
			DrawText(buffer, x, y, status->fontSize, CLR_WHITE);
			x += (int)textSize.x;
			Mugwump_Draw(&mugwumps[i], x, y, (int)textSize.y);
			x += (int)textSize.y;

			if (Mugwump_getFound(&mugwumps[i]))
			{
				strcpy(buffer, "  FOUND!");
			}
			else
			{
				int guessIDX = numGuesses - 1;
				int x = guessIDX >= 0 ? (int)(guesses[guessIDX].x) : 0;
				int y = guessIDX >= 0 ? (int)(guesses[guessIDX].y) : 0;
				double dx = (double)x - (double)Mugwump_getX(&mugwumps[i]);
				double dy = (double)y - (double)Mugwump_getY(&mugwumps[i]);
				double dist = sqrt(dx * dx + dy * dy);
				sprintf(buffer, " is %0.2f units away.", dist);
			}
			DrawText(buffer, x, y, status->fontSize, CLR_WHITE);
			y += (int)textSize.y + status->borderHeight;
		}
	}
	else
	{
		// Draw the help text.
		x = status->borderWidth;
		int numLines = 6;
		char* helpText[] = { "Find all the Mugwumps to win!",
			"Select a square to scan for a Mugwump",
			"Use the arrow keys to move.",
			"Space bar will select a square.",
			"You can also use the mouse.",
			"Press the Escape key to quite the game." };
		for(int i = 0; i < numLines; i++)
		{ 
			textSize = MeasureTextEx(GetFontDefault(), helpText[i], (float) status->fontSize, 1.0);
			DrawText(helpText[i], x, y, status->fontSize, CLR_WHITE);
			y += (int)textSize.y + status->borderHeight;
		}
	}
	int remaining = maxGuesses - numGuesses;
	sprintf(buffer, "You have %d guesses remaining", remaining);
	y += (status->borderHeight * 3);
	DrawText(buffer, x, y, status->fontSize, CLR_WHITE);
}
