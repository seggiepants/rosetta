#pragma once
#include <string>
#include <vector>
#include "3rd_party/olc/olcPixelGameEngine.h"
#include "Console.h"
#include "Mugwump.h"

const int DEFAULT_GRID_W = 10;
const int DEFAULT_GRID_H = DEFAULT_GRID_W;
const int DEFAULT_TEXT_SIZE = 2;
const int FONT_SIZE_PX = 8;
const int DEFAULT_BORDER_W = DEFAULT_TEXT_SIZE * FONT_SIZE_PX; 
const int DEFAULT_BORDER_H = DEFAULT_BORDER_W;
const int DEFAULT_MAX_GUESSES = 10;
const std::string DEFAULT_TITLE = "MUGWUMP 2D";

class Grid
{
public:
	// gameTitle = GAME_TITLE, width = GRID_W, height = GRID_H, maxGuesses = MAX_GUESSES, textSize = TEXT_SIZE, screenWidth = SCREEN_W, screenHeight = SCREEN_H, borderWidth = BORDER_W, borderHeight = BORDER_H
	Grid(olc::PixelGameEngine* app, const std::string gameTitle = DEFAULT_TITLE, int width = DEFAULT_GRID_W, int height = DEFAULT_GRID_H, int maxGuesses = DEFAULT_MAX_GUESSES, int textSize = DEFAULT_TEXT_SIZE, int borderWidth = DEFAULT_BORDER_W, int borderHeight = DEFAULT_BORDER_H);
	~Grid();
	void Click(int x, int y);
	void Draw(olc::PixelGameEngine* app);
	bool isGuessOK(int x, int y);
	void MoveLeft();
	void MoveRight();
	void MoveUp();
	void MoveDown();
	void Select();
private:
	int borderHeight;
	int borderWidth;	
	int cellH;
	int cellW;
	std::vector<olc::vi2d>* guesses;
	int height;
	int maxGuesses;
	olc::vi2d pos;
	int screenWidth;
	int screenHeight;
	int textSize;
	int width;
	int x;
	int y;
	Console* console;
	std::vector<Mugwump*>* mugwumps;
};

