#pragma once
#include <string>
#include <vector>
#include "3rd_party/olc/olcPixelGameEngine.h"
#include "Mugwump.h"

class Console
{
public:
	Console(const std::string gameTitle, int textSize, int borderWidth, int borderHeight);
	~Console();
	void Draw(olc::PixelGameEngine* app, std::vector<olc::vi2d>* guesses, int maxGuesses, std::vector<Mugwump*>* mugwumps );
private:
	std::string gameTitle;
	int textSize;
	int textSizeLarge;
	int borderWidth;
	int borderHeight;
};
