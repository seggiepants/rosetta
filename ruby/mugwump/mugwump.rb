require_relative 'position'

# Constants.
CONSOLE_W = 80
GRID_W = 10
GRID_H = GRID_W
MAX_MUGWUMPS = 4
MAX_TURNS = 10

=begin
Print out a string centered on the console.
Parameters:
* message: The string to print.
Notes:
* Assumes console is currently at horizontal position 0.
* Will not center if the string is too wide to fit on one line.
=end
def center_print(message)
	padding = [0, ((CONSOLE_W - message.length) / 2).floor].max
	puts(' ' * padding + message)
end

=begin
Initialize the vector of mugwumps to random positions on the grid.
Parameters:
* mugwumps: vector of position pointers
=end
def init_mugwumps(mugwumps)
    mugwumps.each do |mugwump|
        mugwump.random_position(GRID_W, GRID_H)
    end
end

=begin
Print out a message to the console, but putting in smart line breaks when a word would cross the console width.
Parameters:
* left - The current position of the cursor on the console 0 to console width - 1
* message - The text to print to the console.
=end
def pretty_print(left, message)
	words = message.split(' ') # Single space is special and splits on all whitespace.
	
	(words).each do |word|
		if left > 0 and left < CONSOLE_W
			print ' '
			left += 1
        end
		
		if left + word.length > CONSOLE_W
			puts ''
			left = 0
        end
		
		print word
		left += word.length
	end
	
	left
end

=begin
Print out the introduction to the game.
=end
def print_introduction()
	center_print 'MUGWUMP'
	center_print 'CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY'
	puts ''
	puts ''
	puts ''
	# Courtesy People's Computer Company
	left = 0
	left = pretty_print left, 'The object of this game is to find four mugwumps.'
	left = pretty_print left, 'hidden on a 10 by 10 grid. Home base is position 0, 0'
	left = pretty_print left, 'any guess you make must be two numbers with each'
	left = pretty_print left, 'number between 0, and 9, inclusive. First number'
	left = pretty_print left, 'is distance to right of home base, and second number'
	left = pretty_print left, 'is distance above home base.'
	puts ''
	puts ''
	left = 0;
	left = pretty_print left, 'You get 10 tries. After each try, I will tell'
	left = pretty_print left, 'you how far you are from each mugwump.'
	puts ''
	puts ''	
end

=begin 
The game of mugwump. There are several "MUGWUMPS" on a grid. You need to find them all in a limited number of turns.
Each time through the loop you can enter a location and the computer tells you how far away you are from each remaining
mugwump. The muwumps are found when you enter their location. Find them all and you win, run out of turns and you lose.
You may play multiple games.
=end

def main()
	mugwumps = Array.new(MAX_MUGWUMPS) {Position.new()}

    print_introduction
	
	distance = 0.0
	remaining = 0
	turn = 0
	x = -1
	y = -1
	
	while (true) do # Loop per game
		turn = 0
		init_mugwumps mugwumps
		while (true) do # Loop per turn
			turn += 1
			puts ''
			puts ''
			x = -1
			y = -1
			line = ''
			while ((line.length == 0) or (x < 0) or (x >= GRID_W) or (y < 0) or (y >= GRID_H)) do
                print "Turn No. #{turn}, what is your guess? "
                line = gets.chomp
                position = line.split(',')
                if (position.length >= 2) 
                    x = position[0].strip.to_i
                    y = position[1].strip.to_i
                else
					x = -1
					y = -1
                end
			end
			
            remaining = 0
            i = 0
            (mugwumps).each do |mugwump|
				if (!mugwump.found)
					if (mugwump.x != x or mugwump.y != y)
						remaining += 1
						distance = Math.sqrt((mugwump.x - x)**2 + (mugwump.y - y)**2)
						puts "You are #{distance.round(2)} units from mugwump #{i + 1}"
					else
						mugwump.found = true;
						puts "YOU HAVE FOUND MUGWUMP #{i + 1}"
                    end
                end
                i += 1
			end
			
			if (remaining == 0)
				puts "YOU GOT THEM ALL IN #{turn} TURNS!"
				break;
            elsif (turn >= MAX_TURNS)
				puts ''
                puts "Sorry, that\'s #{turn} tries. Here is where they\'re hiding."
                i = 0
                while (i < mugwumps.length) do				
					if (not mugwumps[i].found)
						puts "Mugwump #{i + 1} is at (#{mugwumps[i].x}, #{mugwumps[i].y})"
                    end
                    i += 1
				end
				break
			end
		end
		puts('THAT WAS FUN!');
		line = '';
		while (line.length == 0 or (line[0] != 'Y' && line[0] != 'N')) do
            print 'Would you like to play again (Y/N)? '
            line = gets.chomp.strip.upcase
        end
		
		if (line[0] == 'N')
			break
        end
	end
end

# Run the game.
main();