require('position')

-- Constants.
CONSOLE_W = 80
GRID_W = 10
GRID_H = GRID_W
MAX_MUGWUMPS = 4
MAX_TURNS = 10

--[[
Print out a string centered on the console.
Parameters:
* message: The string to print.
Notes:
* Assumes console is currently at horizontal position 0.
* Will not center if the string is too wide to fit on one line.
]]--
function center_print(message)
	padding = math.max(0, math.floor((CONSOLE_W - #message) / 2))
	io.write(string.rep(" ", padding) .. message .. "\n")
end

--[[
Initialize the vector of mugwumps to random positions on the grid.
Parameters:
* mugwumps: vector of position pointers
]]--
function init_mugwumps(mugwumps)
    for _, mugwump in pairs(mugwumps) do
        mugwump:random_position(GRID_W, GRID_H)
    end
end

--[[
Print out a message to the console, but putting in smart line breaks when a word would cross the console width.
Parameters:
* left - The current position of the cursor on the console 0 to console width - 1
* message - The text to print to the console.
]]--
function pretty_print(left, message)
	for word in string.gmatch(message, "%S+") do
		if left > 0 and left < CONSOLE_W then
			io.write(" ")
			left = left + 1
        end
		
		if left + #word > CONSOLE_W then
			io.write("\n")
			left = 0
        end
		
		io.write(word)
        left = left + #word
	end	
	return left
end

--[[
Print out the introduction to the game.
]]--
function print_introduction()
	center_print 'MUGWUMP'
	center_print 'CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY'
	io.write("\n\n\n")
	-- Courtesy People's Computer Company
	left = 0
	left = pretty_print(left, "The object of this game is to find four mugwumps.")
	left = pretty_print(left, "hidden on a 10 by 10 grid. Home base is position 0, 0")
	left = pretty_print(left, "any guess you make must be two numbers with each")
	left = pretty_print(left, "number between 0, and 9, inclusive. First number")
	left = pretty_print(left, "is distance to right of home base, and second number")
	left = pretty_print(left, "is distance above home base.")
	io.write("\n\n")
	left = 0
	left = pretty_print(left, "You get 10 tries. After each try, I will tell")
	left = pretty_print(left, "you how far you are from each mugwump.")
	io.write("\n\n")
end

--[[
The game of mugwump. There are several "MUGWUMPS" on a grid. You need to find them all in a limited number of turns.
Each time through the loop you can enter a location and the computer tells you how far away you are from each remaining
mugwump. The muwumps are found when you enter their location. Find them all and you win, run out of turns and you lose.
You may play multiple games.
]]--
function main()
    mugwumps = {}
    for i = 0, MAX_MUGWUMPS - 1 do
        mugwumps[i] = Position:new()
    end

    print_introduction()
	
	distance = 0.0
	remaining = 0
	turn = 0
	x = -1
	y = -1
	
	while (true) do -- Loop per game
        turn = 0
        init_mugwumps(mugwumps)	
		while (true) do -- Loop per turn
            turn = turn + 1
            io.write("\n\n")
			x = -1
			y = -1
			line = ""
			while ((#line == 0) or (x < 0) or (x >= GRID_W) or (y < 0) or (y >= GRID_H)) do
                io.write(string.format("Turn No. %d, what is your guess? ", turn))
                line = io.read()
                line = string.upper(trim(line))
                position = {}
                i = 0
                for match in string.gmatch(line, "%d+") do
                    local ran, num = pcall(tonumber,match)
                    if ran == true then
                        position[i] = num
                        i = i + 1
                    end
                end

                if (#position >= 1) then 
                    x = position[0]
                    y = position[1]
                else
					x = -1
					y = -1
                end
			end
			
            remaining = 0
            for i, mugwump in pairs(mugwumps) do
				if (not mugwump.found) then
					if (mugwump.x ~= x or mugwump.y ~= y) then 
						remaining = remaining + 1
						distance = math.sqrt((mugwump.x - x) ^ 2 + (mugwump.y - y) ^ 2)
						io.write(string.format("You are %0.2f units from mugwump %d\n", distance, i + 1))
					else
						mugwump.found = true;
						io.write(string.format("YOU HAVE FOUND MUGWUMP %d\n", i + 1))
                    end
                end
                i = i + 1
			end
			
			if (remaining == 0) then
				io.write(string.format("YOU GOT THEM ALL IN %d TURNS!", turn))
				break
            elseif (turn >= MAX_TURNS) then
				io.write(string.format("\nSorry, that\'s %d tries. Here is where they\'re hiding.\n", turn))
                i = 0
                for i, mugwump in pairs(mugwumps) do
					if (not mugwump.found) then
						io.write(string.format("Mugwump %d is at (%d, %d)\n", i, mugwump.x, mugwump.y))
                    end
				end
				break
			end
		end
		io.write('THAT WAS FUN!\n');
		line = ""
		while (#line == 0 or (line:sub(1, 1) ~= 'Y' and line:sub(1,1) ~= 'N')) do
            io.write("Would you like to play again (Y/N)? ")
            line = io.read()
            line = string.upper(trim(line))                
        end
		
		if (line:sub(1, 1) == "N") then
			break
        end
	end
end

--[[
Return a copy of the input string with writespace removed from 
the beginning and end.
Parameters:
* message - the value to trim.
Returns:
* copy of the input string with whitespace removed from the beginning and end 
  (but not from the middle).
]]--
function trim(message)
   return (message:gsub("^%s*(.-)%s*$", "%1"))
end

-- Run the game.
main()