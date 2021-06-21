#include <math.h>
#include "Mugwump.h" // floor

Mugwump::Mugwump(bool found, int x, int y, olc::Pixel color, olc::Pixel eyeColor, olc::Pixel pupilColor, olc::Pixel mouthColor)
{
	this->x = x;
	this->y = y;
	this->found = found;
	this->color = color;
	this->eyeColor = eyeColor;
	this->pupilColor = pupilColor;
	this->mouthColor = mouthColor;
}


Mugwump::~Mugwump()
{
}

void Mugwump::Draw(olc::PixelGameEngine* app, olc::vf2d pos, float size)
{
	int centerX = int(pos.x + floor(size / 2));
	int centerY = int(pos.y + floor(size / 2));
	int eyeDx = int(floor(size / 4.0));
	int eyeDy = int(floor(size / 4.0));
	
	app->FillCircle(olc::vi2d(centerX, centerY), int(size / 2), this->color);						// Body
	app->FillCircle(olc::vi2d(centerX - eyeDx, centerY - eyeDy), int(size / 5), this->eyeColor);	// Eyes
	app->FillCircle(olc::vi2d(centerX + eyeDx, centerY - eyeDy), int(size / 5), this->eyeColor);
	app->FillCircle(olc::vi2d(centerX - eyeDx, centerY - eyeDy), int(size / 10), this->pupilColor);	// Pupils
	app->FillCircle(olc::vi2d(centerX + eyeDx, centerY - eyeDy), int(size / 10), this->pupilColor);
	app->FillCircle(olc::vi2d(centerX, centerY + int(eyeDy / 2)), int(size / 6), this->mouthColor);	// Mouth
}

bool Mugwump::isAt(int x, int y)
{
	return this->x == x && this->y == y;
}
