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
#include <vector>
#include "settings.h"

// Override base class with your custom functionality
class Mugwump2D : public olc::PixelGameEngine
{
private:
	std::vector<olc::Pixel> body_colors = { PINK, VIOLET, LIGHT_BLUE, ORANGE };

public:
	Mugwump2D()
	{
		// Name your application
		sAppName = "Mugwump_2D";
	}


public:
	bool OnUserCreate() override
	{
		// Called once at the start, so create things here

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

		DrawLine(0, 0, ScreenWidth() - 1, ScreenHeight() - 1, olc::WHITE);
		DrawLine(ScreenWidth() - 1, 0, 0, ScreenHeight() - 1, olc::WHITE);
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
