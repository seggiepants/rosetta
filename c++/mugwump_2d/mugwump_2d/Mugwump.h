#pragma once
#include "3rd_party/olc/olcPixelGameEngine.h"

class Mugwump
{
public:
	Mugwump(bool found, int x, int y, olc::Pixel color, olc::Pixel eyeColor, olc::Pixel pupilColor, olc::Pixel mouthColor);
	~Mugwump();
	bool isAt(int x, int y);
	void Draw(olc::PixelGameEngine* app, olc::vi2d pos, int size);
	bool getFound() { return this->found; };
	void setFound(bool value) { this->found = value; };
	int getX() { return this->x; };
	void setX(int x) { this->x = x; };
	int getY() { return this->y; };
	void setY(int y) { this->y = y; };
private:
	bool found;
	int x, y;
	olc::Pixel color, eyeColor, pupilColor, mouthColor;
};

