const readline = require('readline'); // Let's us get input from the console.

// Constants.
const CONSOLE_W = 80;
const GRID_W = 10;
const GRID_H = GRID_W;
const MAX_MUGWUMPS = 4;
const MAX_TURNS = 10;

/*
Print out a string centered on the console.
Parameters:
* message: The string to print.
Notes:
* Assumes console is currently at horizontal position 0.
* Will not center if the string is too wide to fit on one line.
*/
function center_print(message) {
	padding = Math.max(0, Math.floor((CONSOLE_W - message.length) / 2));
	console.log(' '.repeat(padding) + message);
}

/*
Get a promise that will resolve with input from the console.
Parameters:
* rl_interface: interface created from the readline library.
* questionText: Message to prompt the user for input with.
Returns:
* Promise that will resolve to a string. Note: Use await in an async function.
*/
function get_input(rl_interface, questionText) {
	return new Promise((resolve, reject) => {
		rl_interface.question(questionText, (input) => resolve(input));
	});
}

/*
Initialize the vector of mugwumps to random positions on the grid.
Parameters:
* mugwumps: vector of position pointers
*/
function init_mugwumps(mugwumps) {
	for(let i = 0; i < mugwumps.length; i++) {
		mugwumps[i].x = Math.floor(Math.random() * GRID_W);
		mugwumps[i].y = Math.floor(Math.random() * GRID_H);
		mugwumps[i].found = false;
	}
}

/*
Print out a message to the console, but putting in smart line breaks when a word would cross the console width.
Parameters:
* left - The current position of the cursor on the console 0 to console width - 1
* message - The text to print to the console.
*/
function pretty_print(left, message) {
	const words = message.split(/\s/);
	
	for(let i = 0; i < words.length; i++) {
		if (left > 0 && left < CONSOLE_W) {
			process.stdout.write(' ');
			left++;
		}
		
		if (left + words[i].length > CONSOLE_W) {
			console.log();
			left = 0;
		}
		
		process.stdout.write(words[i]);
		left += words[i].length;
	}
	
	return left;
}

/*
Print out the introduction to the game.
*/
function print_introduction() {
	center_print('MUGWUMP');
	center_print('CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY');
	console.log();
	console.log();
	console.log();
	// Courtesy People's Computer Company
	let left = 0;
	left = pretty_print(left, 'The object of this game is to find four mugwumps.');
	left = pretty_print(left, 'hidden on a 10 by 10 grid. Home base is position 0, 0');
	left = pretty_print(left, 'any guess you make must be two numbers with each');
	left = pretty_print(left, 'number between 0, and 9, inclusive. First number');
	left = pretty_print(left, 'is distance to right of home base, and second number');
	left = pretty_print(left, 'is distance above home base.');
	console.log();
	console.log();
	left = 0;
	left = pretty_print(left, 'You get 10 tries. After each try, I will tell');
	left = pretty_print(left, 'you how far you are from each mugwump.');
	console.log();
	console.log();	
}

/* 
The game of mugwump. There are several "MUGWUMPS" on a grid. You need to find them all in a limited number of turns.
Each time through the loop you can enter a location and the computer tells you how far away you are from each remaining
mugwump. The muwumps are found when you enter their location. Find them all and you win, run out of turns and you lose.
You may play multiple games.
Notes:
* Async so that we can use await to wait for input from the readline library when we can get_input.
*/

async function main() {
	const rl_interface = readline.createInterface({
		input: process.stdin, 
		output: process.stdout
	});
	
	mugwumps = [];
	for(let i = 0; i < MAX_MUGWUMPS; i++) {
		mugwumps.push({ x: 0, y: 0, found: false});
	}
		
	print_introduction();
	
	let distance = 0.0;
	let remaining = 0;
	let turn = 0;
	let x = -1;
	let y = -1;
	
	while (true) { // Loop per game
		turn = 0;
		init_mugwumps(mugwumps);
		while (true) { // Loop per turn
			turn++;
			console.log();
			console.log();
			x = -1;
			y = -1;
			line = '';
			while ((line.length == 0) || isNaN(x) || isNaN(y) || (x < 0) || (x >= GRID_W) || (y < 0) || (y >= GRID_H)) {
				line = await get_input(rl_interface, `Turn No. ${turn}, what is your guess? `);
				let position = line.split(',');
				if (position.length >= 2) {
					x = position[0]
					y = position[1]
				} else {
					x = -1;
					y = -1;
				}
			}
			
			remaining = 0;
			for (let i = 0; i < mugwumps.length; i++) {
				if (!mugwumps[i].found) {
					if (mugwumps[i].x != x || mugwumps[i].y != y) {
						remaining++;
						distance = Math.sqrt(Math.pow(mugwumps[i].x - x, 2) + Math.pow(mugwumps[i].y - y, 2));
						console.log(`You are ${distance.toFixed(2)} units from mugwump ${i + 1}`);
					} else {
						mugwumps[i].found = true;
						console.log(`YOU HAVE FOUND MUGWUMP ${i + 1}`);
					}
				}
			}
			
			if (remaining == 0) {
				console.log(`YOU GOT THEM ALL IN ${turn} TURNS!`);
				break;
			}
			else if (turn >= MAX_TURNS) {
				console.log();
				console.log(`Sorry, that'\'s ${turn} tries. Here is where they\'re hiding.`);
				for(let i = 0; i < mugwumps.length; i++) {
					if (!mugwumps[i].found) {
						console.log(`Mugwump ${i + 1} is at (${mugwumps[i].x}, ${mugwumps[i].y})`);
					}
				}
				break;
			}
		}
		console.log('THAT WAS FUN!');
		line = '';
		while (line.length == 0 || (line[0] != 'Y' && line[0] != 'N')) {
			line = await get_input(rl_interface, 'Would you like to play again (Y/N)? ');
			line = line.trim().toUpperCase();
		}
		
		if (line[0] == 'N') {
			break;
		}
	}
	rl_interface.close();
}

// Run the game.
main();

	