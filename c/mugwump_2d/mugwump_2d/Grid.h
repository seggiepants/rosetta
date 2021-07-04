#pragma once
#ifndef __GRID_H__
#define __GRID_H__
#include "Point.h"
#include "Mugwump.h"

typedef struct
{
	int borderHeight;
	int borderWidth;
	int cellH;
	int cellW;
	Point* guesses;
	int height;
	int countGuesses;
	int maxGuesses;
	Point pos;
	int screenWidth;
	int screenHeight;
	int textSize;
	int width;
	int x;
	int y;
	//Console* console;
	Mugwump* mugwumps;
	int maxMugwumps;
	int countMugwumps;
	Color* body_colors;

} Grid;
/*
Grid_Init(Grid* grid, char* gameTitle, int width, int height, int maxGuesses, int textSize, int borderWidth, int borderHeight);
Grid_Destroy(Grid* grid);
void Grid_Click(Grid* grid, int x, int y);
void Grid_Draw(Grid* grid);
bool Grid_isGameOver(Grid* grid);
bool Grid_isGameWon(Grid* grid);
bool Grid_isGuessOK(Grid* grid, int x, int y);
void Grid_MoveLeft(Grid* grid);
void Grid_MoveRight(Grid* grid);
void Grid_MoveUp(Grid* grid);
void Grid_MoveDown(Grid* grid);
void Grid_NewGame(Grid* grid, int numMugwumps = DEFAULT_COUNT_MUGWUMPS);
void Grid_Select(Grid* grid);
*/
#endif