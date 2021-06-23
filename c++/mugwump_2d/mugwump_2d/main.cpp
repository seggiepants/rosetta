// --------------------------------------------------------------------------------
// MUGWUMP 2D
// ----------
// A graphical version of MUGWUMP from BASIC COMPUTER GAMES
// by Bob Albrecht, Bud Valenti, Edited by David H.Ahl
// ported by SeggiePants
//
// Notes: 
// This uses the One Lone Coder Pixel Game Engine. Please see licence under the 
// 3rd_party/olc folder.
//
// --------------------------------------------------------------------------------
//
#define OLC_PGE_APPLICATION
#include "3rd_party/olc/olcPixelGameEngine.h"
#include <algorithm>
#include <stdlib.h>
#include <string>
#include <time.h>
#include <vector>
#include "Grid.h"
#include "Console.h"
#include "Mugwump.h"
#include "settings.h"

// Override base class with your custom functionality
class Mugwump2D : public olc::PixelGameEngine
{
private:
	Grid* grid;
	Console* console;
	std::vector<olc::vi2d>* guesses;
	std::string appName;
	std::vector<Mugwump*>* mugwumps;

public:
	Mugwump2D()
	{
		// Name your application
		this->appName = "Mugwump 2D";
		this->grid = nullptr;
		this->console = nullptr;
		this->guesses = new std::vector<olc::vi2d>();
		this->mugwumps = new std::vector<Mugwump*>();
		srand((unsigned int)time(NULL));
	}

	~Mugwump2D()
	{
		if (this->grid != nullptr)
			delete this->grid;

		if (this->console != nullptr)
			delete this->console;

		if (this->guesses != nullptr)
			delete this->guesses;

		if (this->mugwumps != nullptr)
		{
			for(auto iter = this->mugwumps->begin(); iter != this->mugwumps->end(); ++iter)
			{
				delete *iter;
			}
			this->mugwumps->clear();
			delete this->mugwumps;
		}
	}

	


public:
	bool OnUserCreate() override
	{
		// Called once at the start, so create things here		
		this->grid = new Grid(this);
		//console = new Console(this->appName, 1, 8, 8);
		this->grid->NewGame();
		return true;
	}

	bool OnUserUpdate(float fElapsedTime) override
	{
		// Called once per frame, draws random coloured pixels
		/*for (int x = 0; x < ScreenWidth(); x++)
			for (int y = 0; y < ScreenHeight(); y++)
				Draw(x, y, olc::Pixel(rand() % 256, rand() % 256, rand() % 256));
		*/
		Clear(olc::BLACK);

		/*
		DrawLine(0, 0, ScreenWidth() - 1, ScreenHeight() - 1, olc::WHITE);
		DrawLine(ScreenWidth() - 1, 0, 0, ScreenHeight() - 1, olc::WHITE);		
		Mugwump* thing = *this->mugwumps->begin();
		thing->Draw(this, olc::vf2d{ 320 - 50, 240 - 50 }, 100);
		this->console->Draw(this, this->guesses, MAX_GUESSES, this->mugwumps);
		*/
		/*
		for (int i = 1; i <= 10; i++)
		{
			DrawString(0, i * 12, "Mugwump 2D", olc::WHITE, i);
		}
		*/
		this->grid->Draw(this);
		return true;
	}	

};

int main()
{
	Mugwump2D game;
	if (game.Construct(640, 480, 1, 1))
		game.Start();
	return 0;
}
