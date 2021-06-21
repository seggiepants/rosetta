#pragma once
#include <string>
#include <vector>
#include "3rd_party/olc/olcPixelGameEngine.h"
#include "Mugwump.h"

class Console
{
public:
	Console(std::string& gameTitle, int textSize, int borderWidth, int borderHeight);
	~Console();
	void Draw(olc::PixelGameEngine* app, std::vector<olc::vi2d>* guesses, int maxGuesses, std::vector<Mugwump*>* mugwumps );
private:
	std::string gameTitle;
	int textSize;
	int textSizeLarge;
	int borderWidth;
	int borderHeight;
};

/*
class Console:
	def __init__(self, gameTitle, textSize, borderWidth, borderHeight):
		self.borderWidth = borderWidth
		self.borderHeight = borderHeight
		self.gameTitle = gameTitle
		self.textSize = textSize
		self.font = pygame.font.Font(pygame.font.match_font('sans'), textSize)
		self.fontLarge = pygame.font.Font(pygame.font.match_font('sans', True), textSize + 2)

	def draw(self, surf, guesses, maxGuesses, mugwumps):
		# Draw the title
		y = math.floor(self.borderHeight / 2)
		surfWidth, _ = surf.get_size()
		x = math.floor(surfWidth / 2)
		textSurf = self.fontLarge.render(self.gameTitle, False, WHITE, None)
		r = textSurf.get_rect()
		r.top = y
		r.centerx = x
		surf.blit(textSurf, r)

		x = self.borderWidth
		y = self.borderHeight

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
