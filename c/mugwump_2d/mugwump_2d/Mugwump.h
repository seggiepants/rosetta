#pragma once
#ifndef __MUGWUMP_H__
#define __MUGWUMP_H__
#include "raylib.h"

typedef struct
{
	int x;
	int y;
	bool found;
	Color color;
	Color eyeColor;
	Color pupilColor;
	Color mouthColor;
} Mugwump;


void Mugwump_Init(Mugwump* mugwump, bool found, int x, int y, Color color, Color eyeColor, Color pupilColor, Color mouthColor);
void Mugwump_Draw(Mugwump* mugwump, int x, int y, int size);
bool Mugwump_IsAt(Mugwump* mugwump, int x, int y);
bool Mugwump_getFound(Mugwump* mugwump);
void Mugwump_setFound(Mugwump* mugwump, bool value);
int Mugwump_getX(Mugwump* mugwump);
void Mugwump_setX(Mugwump* mugwump, int x);
int Mugwump_getY(Mugwump* mugwump);
void Mugwump_setY(Mugwump* mugwump, int y);


#endif