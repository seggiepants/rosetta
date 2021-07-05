#include <math.h>
#include "Mugwump.h"

void Mugwump_Init(Mugwump* mugwump, bool found, int x, int y, Color color, Color eyeColor, Color pupilColor, Color mouthColor)
{
	mugwump->x = x;
	mugwump->y = y;
	mugwump->found = found;
	mugwump->color = color;
	mugwump->eyeColor = eyeColor;
	mugwump->pupilColor = pupilColor;
	mugwump->mouthColor = mouthColor;
}

void Mugwump_Draw(Mugwump* mugwump, int x, int y, int size)
{
	int centerX = (int)(x + floor(size / 2.0));
	int centerY = (int)(y + floor(size / 2.0));
	int eyeDx = (int)(floor(size / 4.0));
	int eyeDy = (int)(floor(size / 4.0));

	DrawCircle(centerX, centerY, (int)(size / 2), mugwump->color);							// Body
	DrawCircle(centerX - eyeDx, centerY - eyeDy, (int)(size / 5), mugwump->eyeColor);		// Eyes
	DrawCircle(centerX + eyeDx, centerY - eyeDy, (int)(size / 5), mugwump->eyeColor);
	DrawCircle(centerX - eyeDx, centerY - eyeDy, (int)(size / 10), mugwump->pupilColor);	// Pupils
	DrawCircle(centerX + eyeDx, centerY - eyeDy, (int)(size / 10), mugwump->pupilColor);
	DrawCircle(centerX, centerY + (int)(eyeDy / 2), (int)(size / 6), mugwump->mouthColor);	// Mouth
}

bool Mugwump_IsAt(Mugwump* mugwump, int x, int y)
{
	return mugwump->x == x && mugwump->y == y;
}

bool Mugwump_getFound(Mugwump* mugwump) 
{ 
	return mugwump->found; 
}

void Mugwump_setFound(Mugwump* mugwump, bool value) 
{ 
	mugwump->found = value; 
}

int Mugwump_getX(Mugwump* mugwump) 
{ 
	return mugwump->x; 
}

void Mugwump_setX(Mugwump* mugwump, int x) 
{ 
	mugwump->x = x;
}

int Mugwump_getY(Mugwump* mugwump) 
{ 
	return mugwump->y;
}

void Mugwump_setY(Mugwump* mugwump, int y) 
{ 
	mugwump->y = y; 
}
