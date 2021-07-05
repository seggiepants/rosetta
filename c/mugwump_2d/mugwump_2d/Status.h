#pragma once
#ifndef __STATUS_H__
#define __STATUS_H__

#include "raylib.h"
#include "Mugwump.h"

typedef struct
{
	char* gameTitle;
	int fontSize;
	int fontSizeLarge;
	int borderHeight;
	int borderWidth;
} Status;

void Status_Init(Status* status, char* gameTitle, int fontSize, int fontSizeLarget, int borderWidth, int borderHeight);
void Status_Destroy(Status* status);
void Status_Draw(Status* status, int numGuesses, int maxGuesses, Vector2* guesses, int numMugwumps, Mugwump* mugwumps);

#endif

