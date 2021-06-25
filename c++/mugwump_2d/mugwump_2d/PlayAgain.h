#pragma once
#include "3rd_party/olc/olcPixelGameEngine.h"
#include "settings.h"

class PlayAgain
{
public:
	PlayAgain();
	~PlayAgain();
	void Draw(olc::PixelGameEngine* app);
	void Init(bool wonGame);
	void Update(olc::PixelGameEngine* app, float fElapsedTime);
	bool Ready() { return this->hasSelection; };
	bool Replay() { return this->playAgain; };
private:
	bool hasSelection;
	bool playAgain;
	bool wonGame;
	olc::vi2d posYes, posNo, sizeYes, sizeNo;
};

