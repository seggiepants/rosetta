#pragma once
#include <string>
#include <vector>
#include "3rd_party/olc/olcPixelGameEngine.h"
#include "Console.h"
#include "Mugwump.h"
#include "settings.h"

const int DEFAULT_COUNT_MUGWUMPS = 4;
const int DEFAULT_GRID_W = 10;
const int DEFAULT_GRID_H = DEFAULT_GRID_W;
const int DEFAULT_TEXT_SIZE = 2;
const int DEFAULT_BORDER_W = DEFAULT_TEXT_SIZE * FONT_SIZE_PX; 
const int DEFAULT_BORDER_H = DEFAULT_BORDER_W;
const int DEFAULT_MAX_GUESSES = 10;
const std::string DEFAULT_TITLE = "MUGWUMP 2D";

class Grid
{
public:
	Grid(olc::PixelGameEngine* app, const std::string gameTitle = DEFAULT_TITLE, int width = DEFAULT_GRID_W, int height = DEFAULT_GRID_H, int maxGuesses = DEFAULT_MAX_GUESSES, int textSize = DEFAULT_TEXT_SIZE, int borderWidth = DEFAULT_BORDER_W, int borderHeight = DEFAULT_BORDER_H);
	~Grid();
	void Click(int x, int y);
	void Draw(olc::PixelGameEngine* app);
	bool isGameOver();
	bool isGameWon();
	bool isGuessOK(int x, int y);
	void MoveLeft();
	void MoveRight();
	void MoveUp();
	void MoveDown();
	void NewGame(int numMugwumps = DEFAULT_COUNT_MUGWUMPS);
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
	std::vector<olc::Pixel> body_colors;
};
