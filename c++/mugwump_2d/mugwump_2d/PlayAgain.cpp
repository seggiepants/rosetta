#include "PlayAgain.h"
#include <math.h>

PlayAgain::PlayAgain()
{	
	this->Init(false);
}

PlayAgain::~PlayAgain()
{
}

void PlayAgain::Init(bool wonGame)
{
	this->wonGame = wonGame;
	this->hasSelection = false;
	this->playAgain = false;
}

void PlayAgain::Draw(olc::PixelGameEngine* app)
{
	int x, y, w, h, textScale = 2;
	std::string congrats;
	if (this->wonGame)
		congrats = "Congratulations! You Won!";
	else
		congrats = "Sorry, you lost.";
	olc::vi2d sizeCongrats = app->GetTextSize(congrats);
	std::string playAgain = "Would you like to play again?";
	olc::vi2d sizePlayAgain = app->GetTextSize(playAgain);
	std::string yes = " Yes ";
	std::string no = " No ";
	this->sizeYes = app->GetTextSize(yes);
	this->sizeNo = app->GetTextSize(no);

	// Resize to match text scale
	sizeCongrats.x *= textScale;
	sizeCongrats.y *= textScale;
	sizePlayAgain.x *= textScale;
	sizePlayAgain.y *= textScale;
	this->sizeYes.x *= textScale;
	this->sizeYes.y *= textScale;
	this->sizeNo.x *= textScale;
	this->sizeNo.y *= textScale;

	int yesNoWidth = this->sizeYes.x + this->sizeNo.x + (5 * INSET_1);
	int yesNoHeight = std::max(this->sizeYes.y, this->sizeNo.y) + (2 * INSET_1);

	w = std::max(sizeCongrats.x, std::max(sizePlayAgain.x, yesNoWidth)) + (4 * INSET_1);
	h = sizeCongrats.y + sizePlayAgain.y + yesNoHeight + (6 * INSET_1);
	x = std::max(0, ((app->ScreenWidth() - w) / 2));
	y = std::max(0, ((app->ScreenHeight() - h) / 2));

	app->FillRect(x, y, w, h, DARK_GRAY);
	app->FillRect(x + INSET_1, y + INSET_1, w - (2 * INSET_1), h - (2 * INSET_1), LIGHT_GRAY);

	int startX = x + (2 * INSET_1);
	int startY = y + (2 * INSET_1);

	app->DrawString(startX, startY, congrats, BLACK, textScale);
	startY += sizeCongrats.y;
	app->DrawString(startX, startY, playAgain, BLACK, textScale);
	startY += sizePlayAgain.y + (2 * INSET_1);
	startX = x + ((w - yesNoWidth) / 2);

	posYes.x = startX;
	posYes.y = startY;
	sizeYes.x += (2 * INSET_1);
	sizeYes.y += (2 * INSET_1);
	posNo.x = posYes.x + sizeYes.x + (3 * INSET_1);
	posNo.y = posYes.y;
	sizeNo.x += (2 * INSET_1);
	sizeNo.y += (2 * INSET_1);

	app->FillRect(posYes, sizeYes, BLACK);
	app->FillRect(posNo, sizeNo, BLACK);
	app->DrawString(posYes.x + INSET_1, posYes.y + INSET_1, " Yes ", WHITE, textScale);
	app->DrawString(posNo.x + INSET_1, posNo.y + INSET_1, " No ", WHITE, textScale);

}

void PlayAgain::Update(olc::PixelGameEngine* app, float fElapsedTime)
{
	int mouseX = app->GetMouseX();
	int mouseY = app->GetMouseY();
	bool keyYes = (app->GetKey(olc::Y).bReleased || app->GetKey(olc::ENTER).bReleased || app->GetKey(olc::RETURN).bReleased);
	bool keyNo = (app->GetKey(olc::N).bReleased || app->GetKey(olc::ESCAPE).bReleased);
	bool mouseYes, mouseNo;
	mouseYes = (mouseX > this->posYes.x && mouseX < this->posYes.x + this->sizeYes.x && mouseY > this->posYes.y && mouseY < this->posYes.y + this->sizeYes.y && app->GetMouse(0).bReleased);
	mouseNo = (mouseX > this->posNo.x && mouseX < this->posNo.x + this->sizeNo.x && mouseY > this->posNo.y && mouseY < this->posNo.y + this->sizeNo.y && app->GetMouse(0).bPressed);

	if (keyYes || mouseYes)
	{
		this->hasSelection = true;
		this->playAgain = true;
	}
	
	if (keyNo || mouseNo)
	{
		this->hasSelection = true;
		this->playAgain = false;
	}
}
