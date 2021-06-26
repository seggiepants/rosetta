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
#include "PlayAgain.h"
#include "settings.h"

// Override base class with your custom functionality
class Mugwump2D : public olc::PixelGameEngine
{
private:
	Grid* grid;
	PlayAgain* playAgain;
	std::vector<olc::vi2d>* guesses;
	std::string appName;
	bool exitGame;

public:
	Mugwump2D()
	{
		// Name your application
		sAppName = DEFAULT_TITLE;
		this->grid = nullptr;
		this->playAgain = nullptr;
		this->guesses = new std::vector<olc::vi2d>();
		srand((unsigned int)time(NULL));
	}

	~Mugwump2D()
	{
		if (this->grid != nullptr)
			delete this->grid;

		if (this->playAgain != nullptr)
			delete this->playAgain;

		if (this->guesses != nullptr)
			delete this->guesses;
	}

public:
	bool OnUserCreate() override
	{
		// Called once at the start, so create things here		
		this->grid = new Grid(this);
		this->grid->NewGame();
		this->playAgain = new PlayAgain();
		this->playAgain->Init(true);
		this->exitGame = false;
		return true;
	}

	bool OnUserUpdate(float fElapsedTime) override
	{
		Clear(olc::BLACK);

		if (this->grid->isGameOver() == false)
		{
			// Process input if still playing.
			if (this->GetKey(olc::ESCAPE).bReleased)
			{
				this->exitGame = true;
			}

			if (this->GetKey(olc::DOWN).bReleased || this->GetKey(olc::S).bReleased)
			{
				this->grid->MoveDown();
			}

			if (this->GetKey(olc::LEFT).bReleased || this->GetKey(olc::A).bReleased)
			{
				this->grid->MoveLeft();
			}

			if (this->GetKey(olc::RIGHT).bReleased || this->GetKey(olc::D).bReleased)
			{
				this->grid->MoveRight();
			}

			if (this->GetKey(olc::UP).bReleased || this->GetKey(olc::W).bReleased)
			{
				this->grid->MoveUp();
			}

			if (this->GetKey(olc::SPACE).bReleased || this->GetKey(olc::RETURN).bReleased || this->GetKey(olc::ENTER).bReleased)
			{
				this->grid->Select();
			}

			if (this->GetMouse(0).bReleased)
			{
				int mouseX = this->GetMouseX();
				int mouseY = this->GetMouseY();
				this->grid->Click(mouseX, mouseY);
			}

			if (this->grid->isGameOver())
			{
				this->playAgain->Init(this->grid->isGameWon());
			}
		}

		this->grid->Draw(this);
		if (this->grid->isGameOver())
		{
			this->playAgain->Update(this, fElapsedTime);
			this->playAgain->Draw(this);
			if (this->playAgain->Ready())
			{
				if (this->playAgain->Replay())
				{
					grid->NewGame();
				}
				else
				{
					this->exitGame = true;
				}
			}
		}
		return this->exitGame == false;
	}	
};

int main()
{
	Mugwump2D game;
	if (game.Construct(720, 480, 1, 1))
		game.Start();
	return 0;
}
