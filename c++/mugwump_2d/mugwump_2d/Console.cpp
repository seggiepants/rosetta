#include "Console.h"
#include <math.h> // floor

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
	this->textSizeLarge = textSize + 2;
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
	olc::vi2d textSize = app->GetTextSize(this->gameTitle);
	textSize.x *= this->textSize;
	textSize.y *= this->textSize;
	app->DrawString(x - (textSize.x / 2), y, this->gameTitle, olc::WHITE, this->textSize);

	//if (guesses->size() > 0)
	//{
		// Draw the console.
		y = this->borderHeight;
		x = this->borderWidth;
		int i = 0;
		for (auto mugwump = mugwumps->begin(); mugwump != mugwumps->end(); ++mugwump)
		{
			x = this->borderWidth;
			std::stringstream buffer;
			buffer.clear();
			buffer << "#" << (i + 1) << " ";
			app->DrawString(x, y, buffer.str());
			textSize = app->GetTextSize(buffer.str());
			x += textSize.x * this->textSize;
			((Mugwump*)*mugwump)->Draw(app, olc::vf2d{ (float) x, (float) y }, 8 * this->textSize); // ZZZ do something with 8.
			y += textSize.y * this->textSize;
			i++;
		}
	/*}
	else
	{

	}
	*/
	/*

		if len(guesses) > 0:
			# Draw the console.
			y = self.borderHeight
			for i, mugwump in enumerate(mugwumps):
				x = self.borderWidth
				textSurf = self.font.render('#' + str(i) + ' ', False, WHITE, None)
				r = textSurf.get_rect()
				r.top = y
				r.left = x
				surf.blit(textSurf, r)
				x += r.width

				mugwump.draw(surf, x, y, self.textSize)
				x += self.textSize

				if (mugwump.found):
					message = ' FOUND!'
				else:
					dx = guesses[-1]['x'] - mugwump.x
					dy = guesses[-1]['y'] - mugwump.y
					dist = math.sqrt(dx * dx + dy * dy)
					message = ' is {dist:.2f} units away'.format(dist=dist)
				textSurf = self.font.render(message, False, WHITE, None)
				r = textSurf.get_rect()
				r.top = y
				r.left = x
				surf.blit(textSurf, r)
				y += r.height + self.borderHeight
		else:
			# Draw the help text.
			x = self.borderWidth
			y = self.borderHeight * 3
			messages = ["Find all the Mugwumps to win!",
			"Select a square to scan for a Mugwump",
			"Use the arrow keys to move.",
			"Space bar will select a square.",
			"You can also use the mouse.",
			"Press the Escape key to quite the game."]
			for message in messages:
				textSurf = self.font.render(message, False, WHITE, None)
				r = textSurf.get_rect()
				r.top = y
				r.left = x
				y = y + r.height + self.borderHeight
				surf.blit(textSurf, r)

		textSurf = self.font.render('You have {remaining} guesses remaining.'.format(remaining=maxGuesses - len(guesses)), False, WHITE, None)
		r = textSurf.get_rect()
		r.top = y + (self.borderHeight * 3)
		r.left = x
		surf.blit(textSurf, r)
	*/
}