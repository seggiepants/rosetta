#include "settings.h"
#include "Console.h"
#include <iostream>
#include <iomanip>

Console::Console(const std::string gameTitle, int textSize, int borderWidth, int borderHeight)
{
	/*
		this->borderWidth = borderWidth
		this->borderHeight = borderHeight
		this->gameTitle = gameTitle
		this->textSize = textSize
		self.font = pygame.font.Font(pygame.font.match_font('sans'), textSize)
		self.fontLarge = pygame.font.Font(pygame.font.match_font('sans', True), textSize + 2)

	*/
	this->gameTitle = gameTitle;
	this->textSize = textSize;
	this->textSizeLarge = textSize + 1;
	this->borderWidth = borderWidth;
	this->borderHeight = borderHeight;
}


Console::~Console()
{
}

void Console::Draw(olc::PixelGameEngine* app, std::vector<olc::vi2d>* guesses, int maxGuesses, std::vector<Mugwump*>* mugwumps)
{
	// Draw the title
	int y = int(floor(this->borderHeight / 2));
	int x = int(floor(app->ScreenWidth() / 2));
	std::stringstream buffer;
	olc::vi2d textSize = app->GetTextSize(this->gameTitle);
	textSize.x *= this->textSizeLarge;
	textSize.y *= this->textSizeLarge;
	app->DrawString(x - (textSize.x / 2), y, this->gameTitle, olc::WHITE, this->textSizeLarge);

	if (guesses->size() > 0)
	{
		// Draw the console.
		y = this->borderHeight;
		x = this->borderWidth;
		int i = 0;
		for (auto mugwump = mugwumps->begin(); mugwump != mugwumps->end(); ++mugwump)
		{
			x = this->borderWidth;			
			buffer.clear();
			buffer << "#" << (i + 1) << " ";
			app->DrawString(x, y, buffer.str(), WHITE, this->textSize);
			textSize = app->GetTextSize(buffer.str());
			x += textSize.x * this->textSize;
			((Mugwump*)*mugwump)->Draw(app, olc::vi2d{ x, y }, FONT_SIZE_PX * this->textSize); 
			
			if (((Mugwump*)*mugwump)->getFound())
			{
				buffer.str(" FOUND!");
			}
			else
			{
				int guessIDX = guesses->size() - 1;
				int x = guessIDX >= 0 ? ((*guesses)[guessIDX].x) : 0;
				int y = guessIDX >= 0 ? ((*guesses)[guessIDX].y) : 0;
				float dx = (float)(x - (*mugwump)->getX());
				float dy = (float)(y - (*mugwump)->getY());
				float dist = std::sqrtf(dx * dx + dy * dy);
				buffer.str("");
				buffer << "  is " << std::fixed << std::setprecision(2) << dist << " units away.";
			}
			app->DrawString(x, y, buffer.str(), WHITE, this->textSize);
			y += textSize.y + this->borderHeight;
			i++;
		}
	}
	else
	{
		// Draw the help text.
		x = this->borderWidth;
		y = this->borderHeight * 3;
		std::vector<std::string> messages = { "Find all the Mugwumps to win!",
			"Select a square to scan for a Mugwump",
			"Use the arrow keys to move.",
			"Space bar will select a square.",
			"You can also use the mouse.",
			"Press the Escape key to quite the game." };
		for (auto iter = messages.begin(); iter != messages.end(); ++iter) 
		{
			app->DrawString(x, y, (*iter), WHITE, this->textSize);
			textSize = app->GetTextSize(*iter);
			y += textSize.y + this->borderHeight;
		}
	}
	int remaining = maxGuesses - guesses->size();
	buffer.str("");
	buffer << "You have " << remaining << " guesses remaining.";
	y += (this->borderHeight * 3);
	x = this->borderWidth;
	app->DrawString(x, y, buffer.str(), WHITE, this->textSize);
}