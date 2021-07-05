#include <stdio.h>
#include <stdlib.h>
#include "Settings.h"
#include "Grid.h"

#define NUM_COLORS 4

void Grid_Init(Grid* grid, char* gameTitle, int width, int height, int maxGuesses, int textSize, int borderWidth, int borderHeight)
{

	if ((void*)(grid->body_colors = (Color*)malloc(sizeof(Color) * NUM_COLORS)) == NULL)
	{
		perror("Unable to allocate memory - body colors.");
		exit(1);
	}
	grid->body_colors[0] = CLR_PINK;
	grid->body_colors[1] = CLR_VIOLET;
	grid->body_colors[2] = CLR_LIGHT_BLUE;
	grid->body_colors[3] = CLR_ORANGE;

	grid->width = width;
	grid->height = height;
	grid->textSize = textSize;
	grid->borderWidth = borderWidth;
	grid->borderHeight = borderHeight;
	grid->maxGuesses = maxGuesses;
	grid->maxMugwumps = COUNT_MUGWUMPS;
	if ((void *)(grid->mugwumps = (Mugwump*)malloc(sizeof(Mugwump) * grid->maxMugwumps)) == NULL)
	{
		perror("Unable to allocate memory - Mugwumps.");
		exit(1);
	}
	if ((void*)(grid->guesses = (Vector2*)malloc(sizeof(Vector2) * grid->maxGuesses)) == NULL)
	{
		perror("Unable to allocate memory - Guesses.");
		exit(1);
	}
	
	Status_Init(&grid->status, gameTitle, grid->textSize, grid->textSize + 2, borderWidth, borderHeight);
	Vector2 titleSize = MeasureTextEx(GetFontDefault(), gameTitle, (float)grid->status.fontSizeLarge, 1.0);
	grid->screenWidth = GetScreenWidth();
	grid->screenHeight = GetScreenHeight();
	Vector2 size = MeasureTextEx(GetFontDefault(), "Press the Escape key to quit the game.  NN", (float) grid->textSize, 1.0);
	grid->cellW = (int)((grid->screenWidth - size.x - (grid->borderWidth * 3)) / grid->width);
	grid->cellH = (int)((grid->screenHeight - titleSize.y - (grid->borderHeight * 4) - size.y) / grid->height);
	grid->cellW = grid->cellH = MIN(grid->cellW, grid->cellH);
	
	grid->x = grid->screenWidth - (grid->cellW * grid->width) - grid->borderWidth;
	grid->y = (int)((grid->screenHeight - titleSize.y - (grid->borderHeight * 4) - (grid->cellH * grid->height)) / 2);
	grid->y += ((int)titleSize.y + (2 * grid->borderHeight));
}

void Grid_Destroy(Grid* grid)
{
	if (grid->mugwumps != NULL)
	{
		free((void*)grid->mugwumps);
		grid->mugwumps = NULL;
	}

	if (grid->guesses != NULL)
	{
		free((void*)grid->guesses);
		grid->guesses = NULL;
	}
}

void Grid_Click(Grid* grid, int x, int y)
{
	int gridX = x - grid->x;
	int gridY = y - grid->y;
	bool isGridLine = ((gridX % grid->cellW == 0) || (gridY % grid->cellH == 0));
	if (gridX > 0 && gridX < grid->cellW * grid->width && gridY > 0 && gridY < grid->cellH * grid->height)
	{
		int px = (int)(gridX / grid->cellW);
		int py = (int)(gridY / grid->cellH);
		grid->pos.x = (float) px;
		grid->pos.y = (float) py;
		Grid_Select(grid);
	}

}

void Grid_Draw(Grid* grid)
{
	Status_Draw(&grid->status, grid->countGuesses, grid->maxGuesses, grid->guesses,grid->countMugwumps,  grid->mugwumps);
	int i;
	char buffer[BUFFER_MAX];
	Vector2 textPos, textSize;
	
	for (i = 0; i <= grid->height; ++i)
	{
		DrawLine(grid->x, grid->y + (grid->cellH * i), grid->x + (grid->cellW * grid->width), grid->y + (grid->cellH * i), CLR_WHITE);
		if (i < grid->height)
		{
			buffer[0] = '\0';
			sprintf(buffer, "%i", i);
			textSize = MeasureTextEx(GetFontDefault(), buffer, (float)grid->textSize, 1.0);
			textPos.x = grid->x - textSize.x - grid->borderWidth;
			textPos.y = grid->y + ((grid->height - i) * grid->cellH) - (int)(grid->cellH / 2) - (textSize.y / 2);
			DrawText(buffer, (int)textPos.x, (int)textPos.y, grid->textSize, CLR_WHITE);
		}
	}

	for (i = 0; i <= grid->width; ++i)
	{
		DrawLine(grid->x + (grid->cellW * i), grid->y, grid->x + (grid->cellW * i), grid->y + (grid->cellH * grid->height), CLR_WHITE);
		if (i < grid->width)
		{
			buffer[0] = '\0';
			sprintf(buffer, "%i", i);
			textSize = MeasureTextEx(GetFontDefault(), buffer, (float) grid->textSize, 1.0);
			textPos.x = (float)(grid->x + (int)(grid->cellW / 2) + (i * grid->cellW) - ((int)textSize.x / 2));
			textPos.y = (float)(grid->y + (grid->height * grid->cellH) + grid->borderHeight);
			DrawText(buffer, (int)textPos.x, (int)textPos.y, grid->textSize, CLR_WHITE);
		}
	}

	if (grid->pos.x >= 0 && grid->pos.x < grid->width && grid->pos.y >= 0 && grid->pos.y < grid->height)
	{
		DrawRectangle(grid->x + (grid->cellW * (int)grid->pos.x) + INSET_1, grid->y + (grid->cellH * (int)grid->pos.y) + INSET_1, grid->cellW - (2 * INSET_1), grid->cellH - (2 * INSET_1), CLR_TEAL);
	}

	if (grid->countGuesses > 0)
	{
		for (i = 0; i < grid->countGuesses; ++i)
		{
			DrawRectangle(grid->x + (grid->cellW * (int)grid->guesses[i].x) + INSET_2, grid->y + (grid->cellH * (int)grid->guesses[i].y) + INSET_2, grid->cellW - (2 * INSET_2), grid->cellH - (2 * INSET_2), CLR_RED);
		}
	}

	for (i = 0; i < grid->countMugwumps; ++i)
	{
		if (Mugwump_getFound(&grid->mugwumps[i]))
		{
			Mugwump_Draw(&grid->mugwumps[i], grid->x + (grid->cellW * Mugwump_getX(&grid->mugwumps[i])) + 1, grid->y + (grid->cellH * Mugwump_getY(&grid->mugwumps[i])) + 1, grid->cellW - 2);
		}
	}
}

bool Grid_isGameOver(Grid* grid)
{
	int mugwumpsFound = 0;
	if (grid->countMugwumps > 0)
	{
		for (int i = 0; i < grid->countMugwumps; ++i)
		{
			if (Mugwump_getFound(&grid->mugwumps[i]))
			{
				mugwumpsFound++;
			}
		}
	}
	return (grid->countGuesses >= grid->maxGuesses) || (mugwumpsFound == grid->maxMugwumps);
}

bool Grid_isGameWon(Grid* grid)
{
	int mugwumpsFound = 0;
	if (grid->countMugwumps > 0)
	{
		for (int i = 0; i < grid->countMugwumps; ++i)
		{
			if (Mugwump_getFound(&grid->mugwumps[i]))
			{
				mugwumpsFound++;
			}
		}
	}
	return (grid->countGuesses <= grid->maxGuesses) && (mugwumpsFound == grid->maxMugwumps);
}

bool Grid_isGuessOK(Grid* grid, int x, int y)
{
	if (grid->countGuesses > 0)
	{
		for (int i = 0; i < grid->countGuesses; ++i)
		{
			if (grid->guesses[i].x == x && grid->guesses[i].y == y)
			{
				return false;
			}
		}
	}
	return true;
}

void Grid_MoveLeft(Grid* grid)
{
	grid->pos.x = MAX(0, grid->pos.x - 1);
}

void Grid_MoveRight(Grid* grid)
{
	grid->pos.x = MIN(grid->width - 1, grid->pos.x + 1);
}

void Grid_MoveUp(Grid* grid)
{
	grid->pos.y = MAX(0, grid->pos.y - 1);
}

void Grid_MoveDown(Grid* grid)
{
	grid->pos.y = MIN(grid->height - 1, grid->pos.y + 1);
}

void Grid_NewGame(Grid* grid)
{
	grid->countGuesses = 0;
	grid->countMugwumps = 0;
	grid->pos.x = (float)(grid->width / 2);
	grid->pos.y = (float)(grid->height / 2);

	for (int i = 0; i < grid->maxMugwumps; i++)
	{
		bool positionOK = false;
		int x = 0;
		int y = 0;
		Color color;

		while (!positionOK)
		{
			x = rand() % grid->width;
			y = rand() % grid->height;
			color = grid->body_colors[i % NUM_COLORS];
			positionOK = true;
			if (grid->countMugwumps > 0)
			{
				for (int j = 0; j < grid->countMugwumps; j++)
				{
					if (Mugwump_IsAt(&grid->mugwumps[j], x, y))
					{
						positionOK = false;
						break;
					}
				}
			}
		}
		Mugwump_Init(&grid->mugwumps[i], false, x, y, color, CLR_WHITE, CLR_BLACK, CLR_BLACK);
		grid->countMugwumps++;
	}
}

void Grid_Select(Grid* grid)
{
	int x = (int)grid->pos.x;
	int y = (int)grid->pos.y;
	if (Grid_isGuessOK(grid, x, y))
	{
		grid->guesses[grid->countGuesses].x = (float)x;
		grid->guesses[grid->countGuesses].y = (float)y;
		grid->countGuesses++;
		for (int i = 0; i < grid->maxMugwumps; ++i)
		{
			if (Mugwump_IsAt(&grid->mugwumps[i], x, y))
			{
				Mugwump_setFound(&grid->mugwumps[i], true);
			}
		}
	}
}
