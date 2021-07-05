#pragma once

#ifndef __SETTINGS_H__
#define __SETTINGS_H__
#include "raylib.h"

#define MAX(a,b) ((a) > (b) ? (a) : (b))
#define MIN(a,b) ((a) < (b) ? (a) : (b))

#define BUFFER_MAX 255

#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 450

#define GAME_TITLE "MUGWUMP 2D"
#define COUNT_MUGWUMPS 4
#define MAX_GUESSES 10
#define GRID_W 10
#define GRID_H 10
#define INSET_1 4
#define INSET_2 8
#define FONT_SIZE 12

static const Color CLR_BLACK = { 0, 0, 0, 255 };
static const Color CLR_DARK_GRAY = { 64, 64, 64, 255 };
static const Color CLR_LIGHT_BLUE = { 128, 128, 255, 255 };
static const Color CLR_LIGHT_GRAY = { 192, 192, 192, 255 };
static const Color CLR_ORANGE = { 255, 128, 0, 255 };
static const Color CLR_PINK = { 255, 0, 128, 255 };
static const Color CLR_RED = { 255, 0, 0, 255 };
static const Color CLR_TEAL = { 12, 140, 127, 255 };
static const Color CLR_VIOLET = { 192, 0, 255, 255 };
static const Color CLR_WHITE = { 255, 255, 255, 255 };

#endif
