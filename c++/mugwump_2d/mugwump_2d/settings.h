#pragma once
#include <string>
#include "3rd_party/olc/olcPixelGameEngine.h"

const std::string GAME_TITLE = "MUGWUMP 2D";
const int COUNT_MUGWUMPS = 4;
const int MAX_GUESSES = 10;
const int GRID_W = 10;
const int GRID_H = 10;

static const olc::Pixel BLACK = olc::Pixel(0, 0, 0);
static const olc::Pixel DARK_GRAY = olc::Pixel(64, 64, 64);
static const olc::Pixel LIGHT_BLUE = olc::Pixel(128, 128, 255);
static const olc::Pixel LIGHT_GRAY = olc::Pixel(192, 192, 192);
static const olc::Pixel ORANGE = olc::Pixel(255, 128, 0);
static const olc::Pixel PINK = olc::Pixel(255, 0, 128);
static const olc::Pixel RED = olc::Pixel(255, 0, 0);
static const olc::Pixel TEAL = olc::Pixel(12, 140, 127);
static const olc::Pixel VIOLET = olc::Pixel(192, 0, 255);
static const olc::Pixel WHITE = olc::Pixel(255, 255, 255);
