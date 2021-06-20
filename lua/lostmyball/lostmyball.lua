-- Conversion Notes:
-- Comment character is -- instead of '

-- ARRAY-- s use () instead of []
-- DEF Function/END -> function functionName(parameters) ... end
-- String multiplication "*" * 3 = "***" is string.rep("*", 3) = "***"
-- len(array_value) = #array_value
-- pop(array) =  value = array[1] then table.remove(array, 1)
-- variables don't have a set data type
-- local variables declared with local variable_name, globals aren't declared at all.
-- True/False -> true/false
-- for i = x to y / stuff / next i -> for key, value in next, table do / stuff / end
-- if/then/else/endif -> if/then/else/end should parenthesize expressions
-- "string" + "string" -> "string" .. "string"
-- not equal is ~= instead of != or <>
-- string.sub instead of mid, and it is start, stop, not start, length
-- CLS not present, best substitute is an os call, would rather do without.
-- Can make objects, so I did for room and object lists
-- No built in wait/sleep/delay function
-- io.read() instead of INPUT
-- no CONTINUE command.
-- no end program command, but can do return end at main level instead (put a return at overall scope).
-- functions must be at the top of the code (can't call before declaration?).

-- I LOST MY BALL
-- by Stewart / SeggiePants - 2017
-- =========================================
-- A SMALL TEXT ADVENTURE. MEANT TO BE
-- USABLE AS A BASE FOR OTHER LARGER TEXT
-- ADVENTURE GAMES, OR AS A LEARNING TOOL.
-- SOMEWHAT OVERGROWN FOR THAT LAST OPTION.
-- 
-- YOU LOST YOUR BALL, NOW YOU HAVE TO VENTURE
-- INTO THE MILDLY UNSETTLING HOUSE TO GET IT
-- BACK, AND HOPE TO MAKE IT BACK OUT AGAIN.
-- 

SCREEN_WIDTH = 80

local Room = {}
Room._index = Room

setmetatable(Room, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function Room.new(description, north, south, east, west, up, down)
    local self = setmetatable({}, Room)
    self.description = description
    self.north = north
    self.south = south
    self.east = east
    self.west = west
    self.up = up
    self.down = down
    return self
end

function Room:get_description()
    return self.description
end

function Room:set_description(description)
    self.description = description
end

function Room:get_north()
    return self.north
end

function Room:set_north(north)
    self.north = north
end

function Room:get_south()
    return self.south
end

function Room:set_south(south)
    self.south = south
end

function Room:get_east()
    return self.east
end

function Room:set_east(east)
    self.east = east
end

function Room:get_west()
    return self.west
end

function Room:set_west(west)
    self.west = west
end

function Room:get_up()
    return self.up
end

function Room:set_up(up)
    self.up = up
end

function Room:get_down()
    return self.down
end

function Room:set_down(down)
    self.down = down
end

Rooms = {
    Start = Room("YOU STAND AT THE OPEN DOORWAY OF THE MILDLY UNSETTLING HOUSE. A TREE TOWERS ABOVE YOU, THE FRONT DOOR IS TO THE EAST, AND A PATHWAY SOUTH LEADS TO A SMALL GARDEN", "None","Garden","LivingRoom","None","Tree","None")
    , Tree = Room("YOU FIND YOURSELF UP HIGH IN A LARGE TREE. DOWN BELOW YOU IS THE MILDLY UNSETTLING HOUSE.", "None", "None", "None", "None", "None","Start")
    , LivingRoom = Room("YOU ARE IN THE LIVING ROOM, BUT NOBODY SEEMS TO BE AROUND. TO THE EAST IS A BEDROOM, NORTH THE GARAGE, SOUTH THE KITCHEN, AND WEST HEADS BACK TO THE ENTRANCE", "Garage", "Kitchen", "Bedroom", "Start", "None", "None")
    , Bedroom = Room("YOU ARE IN A BEDROOM BELONGING TO A LITTLE GIRL. THE LIVING ROOM IS TO THE WEST", "None", "None", "None", "LivingRoom", "None", "None")
    , Garden = Room("YOU FIND YOURSELF IN A SMALL OVERGROWN GARDEN. THE MAIN ENTRANCE IS TO YOUR NORTH, AND AN ENTRANCE TO THE KITCHEN TO THE EAST", "Start", "None", "Kitchen", "None", "None", "None")
    , Kitchen = Room("A MESSY KITCHEN IN NEED OF A GOOD CLEANING SURROUNDS YOU. NORTH LEADS TO THE LIVING ROOM, WEST TO THE GARDEN, AND EAST TO THE BATHROOM", "LivingRoom", "None", "Bathroom", "Garden", "None", "None")
    , Bathroom = Room("YOU FIND YOURSELF IN A SMELLY BATHROOM. THE KITCHEN IS TO YOUR WEST", "None", "None", "None", "Kitchen", "None", "None")
    , Garage = Room("A CAVERNOUS GARAGE LOOMS AROUND YOU. YOU CAN RETURN SOUTH TO THE LIVING ROOM, OR GO DOWN TO THE CELLAR FROM HERE", "None", "LivingRoom", "None", "None", "None", "Cellar")
    , Cellar = Room("BLACKNESS FILLS THE DARK CELLAR. YOU CAN CLIMB UP INTO THE GARAGE.", "None", "None", "None", "None", "Garage", "None")
    , Event = Room("PSEUDO ROOM FOR ITEMS GAINED THROUGH IN-GAME EVENTS", "None", "None", "None", "None", "None", "None")
    , Inventory = Room("PSEUDO ROOM FOR ITEMS IN YOUR INVENTORY", "None", "None", "None", "None", "None", "None")
    , Used = Room("PSEUDO ROOM FOR ITEMS THAT HAVE BEEN USED/CONSUMED", "None", "None", "None", "None", "None", "None")
}

local Object = {}
Object.__index = Object

setmetatable(Object, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Object.new(name, location, canPickup)
  local self = setmetatable({}, Object)
  self.name = name
  self.location = location
  self.canPickup = canPickup
  return self
end

function Object:set_name(name)
    self.name = name
end

function Object:set_location(location)
    self.location = location
end

function Object:set_canPickup(canPickup)
    self.canPickup = canPickup
end

function Object:get_name()
    return self.name
end

function Object:get_location()
    return self.location
end

function Object:get_canPickup()
    return self.canPickup
end

-- List of objects in the game. 
-- For each object the first parameter is name, the second location 
-- and the third a boolean saying if it can be picked up or not.
Objects = {
    Object("CAT", "Tree", true)
    , Object("CATNIP", "Garden", true)
    , Object("SAFE", "LivingRoom", false)
    , Object("KEY", "Event", true)
    , Object("BATTERIES", "Event", true)
    , Object("MEAT", "Kitchen", true)
    , Object("FLASHLIGHT", "Bathroom", true)
    , Object("DOG", "Garage", false)
    , Object("BALL", "Cellar", true)
    , Object("GIRL", "Bedroom", false)
}

-- Direction Table
Directions = {
    "N","NORTH","S","SOUTH","E","EAST", 
    "W","WEST","U","UP","D","DOWN"
}

-- HANDLE THE GET VERB
-- Handle the verb GET
-- what: The thing to try to get
function VerbGet(what)
    local item, catnip
    item = FindObj(what)
    catnip = FindObj("CATNIP")

    if item == nil then
        print()
        print()
        RandomPrint("YOU CAN'T GET THAT|THERE IS NO " .. what + " THAT YOU CAN GET|I DON'T THINK SO", "|")
      elseif item.location == "Inventory" then
        print()
        print()
        PrettyPrint("YOU ALREADY HAVE THAT.")
      elseif item.location == "Used" then
        print()
        print()
        PrettyPrint("THERE IS NO MORE TO BE FOUND.")
      elseif item.location ~= CurrentRoom then
        print()
        print()
        PrettyPrint("I DON'T SEE ANY " .. what + " AROUND HERE.")
    else
        if item.location == "Cellar" and FlashlightOn == false then
            print()
            print()
            PrettyPrint("IT IS TOO DARK TO SEE DOWN HERE.")
         elseif what == "CAT" then
            if catnip.location == "Used" then
                print()
                print()
                PrettyPrint("YOU QUICKLY PICK UP THE CAT WHILE IT IS DISTRACTED.")
                item.location = "Inventory"
            else
                print()
                print()
                PrettyPrint("THE CAT HISSES AND CLAWS AT YOU. DISTRACTED, YOU FALL FROM THE TREE TO YOUR DEATH.")
                GameOver = true
                print()
                PrettyPrint("GAME OVER.")
            end
         elseif item.canPickup == false then
            print()
            print()
            PrettyPrint("YOU CAN'T PICK THAT UP.")
        else
            item.location = "Inventory"
            print()
            print()
            RandomPrint("YOU GOT THE " .. what .. "!|" .. what .. " OBTAINED|YOU PICKED UP THE " .. what .. "! GOOD FOR YOU!", "|")
        end
    end
end

-- Handle the secret verb dance
function VerbDance()
    if CurrentRoom == "Tree" then
        print()
        PrettyPrint("YOUR DANCE MOVES, WHILE GRAND, UNBALACE YOU. YOU FALL FROM THE TREE TO YOUR DEATH. GAME OVER!")
        GameOver = true
     elseif CurrentRoom == "Bedroom" then
        print()
        PrettyPrint("DESPITE YOUR AWESOME DANCE MOVES, THE LITTLE GIRL IS UNIMPRESSED.")
     elseif CurrentRoom == "Cellar" and FlashlightOn == false then
        print()
        PrettyPrint("YOUR OUTRAGEOUS DANCE MOVES CAUSE YOU TO TRIP AND FALL IN THE DARK. YOU BROKE YOUR NECK AND DIED. GAME OVER!")
        GameOver = true
    else
        print()
        PrettyPrint("WA HOO! GET DOWN AND BOOGIE, YOU ARE A DANCING MACHINE!")
    end
end

-- Handle the go command
-- dir: the direction you wish to travel.
function VerbGo(dir)
    local meat, current_room
    current_room = Rooms[CurrentRoom]
    if dir == "N" or dir == "NORTH" then
        if current_room.north ~= "None" then
            CurrentRoom = current_room.north
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
     elseif dir == "S" or dir == "SOUTH" then
        if current_room.south ~= "None" then
            CurrentRoom = current_room.south
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
     elseif dir == "E" or dir == "EAST" then
        if current_room.east ~= "None" then
            CurrentRoom = current_room.east
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
     elseif dir == "W" or dir == "WEST" then
        if current_room.west ~= "None" then
            CurrentRoom = current_room.west
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
     elseif dir == "U" or dir == "UP" then
        if current_room.up ~= "None" then
            CurrentRoom = current_room.up
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
     elseif dir == "D" or dir == "DOWN" then
        if current_room.down ~= "None" then
            if current_room.down == "Cellar" then
                meat = FindObj("MEAT")
                if meat.location ~= "Used" then
                    print()
                    print()
                    PrettyPrint("THE DOG GOES WILD!")
                    PrettyPrint("IT WAS GUARDING THE CELLAR")
                    print()
                    PrettyPrint("...")
                    print()
                    PrettyPrint("THE DOG KILLED YOU.")
                    print()
                    PrettyPrint("GAME OVER!")
                    GameOver = true
                else
                    print()
                    print()
                    PrettyPrint("THE DOG EYES YOU SUSPICIOUSLY BUT IS TOO BUSY EATING TO STOP YOU.")
                    CurrentRoom = current_room.down
                end
            else
                CurrentRoom = current_room.down
            end
        else
            PrettyPrint(BadDir())
            Wait(1.0)
            InputOK = false
        end
    else
        PrettyPrint(BadDir())
        Wait(1.0)
        InputOK = false
    end
end

-- HANDLE THE HELP VERB. GENERAL HELP IF NO
-- TOPIC SPECIFIED, SPECIFIC HELP IS AVAILABLE
-- OTHERWISE
function VerbHelp(topic)
    if #topic == 0 then
        print()
        print()
        PrettyPrint("HELP:")
        PrettyPrint("In this game you lost your ball and must find it and escape again. This is a text adventure game. In this type of game you type in commands on the keyboard (remember to hit Enter/Return). The method is similar to the DOS or UNIX command prompt. The game will attempt to decipher your command and report back any new status or location.")
        print()
        PrettyPrint("This sort of game was popular in the early days of computing before graphics were standard. They normally focus on puzzles and word problems. Sometimes part of the game is figuring out what commands are available.")
        print()
        PrettyPrint("For additional information try getting help on one of the topics below.")
        print()
        PrettyPrint("AVAILABLE COMMANDS: GET, GO, HELP, INVENTORY, OPEN, QUIT, TALK, USE")
    elseif topic == "GET" or topic == "TAKE" or topic == "OBTAIN" or topic == "PICK" or topic == "PICKUP" then
        HelpGet()
    elseif InTable(topic, Directions) or topic == "GO" or topic == "MOVE" or topic == "WALK" or topic == "RUN" or topic == "TRAVEL" then
        HelpGo()
    elseif topic == "HELP" or topic == "HINT" or topic == "ABOUT" then
        HelpHelp()
    elseif topic == "OPEN" or topic == "UNLOCK" then
        HelpOpen()
    elseif topic == "TALK" or topic == "SPEAK" then
        HelpTalk()
    elseif topic == "USE" or topic == "GIVE" or topic == "ACTIVATE" then
        HelpUse()
    elseif topic == "INVENTORY" or topic == "INV" or topic == "I" or topic == "BAG" then
        HelpInventory()
    elseif topic == "Q" or topic == "QUIT" or topic == "X" or topic == "EXIT" then
        HelpQuit()
    else
        print()
        print()
        PrettyPrint(" SORRY, I DON'T HAVE A PAGE FOR " .. topic .. ".")
    end
end

-- Describe the GO command
function HelpGo()
    print()
    print()
    PrettyPrint("GO:")
    PrettyPrint("GO is a unique command. It can be use in one and two word format. For the single word format just enter the direction or its abbreviation (N,NORTH,S,SOUTH,E,EAST,W,WEST,U,UP,D,DOWN). For two word mode type GO followed by the desired direction of travel. You may not be able to go in all directions in most locations. Normally a list of available directions you may travel in is printed after the room description.")
    print()
    PrettyPrint("EXAMPLES N, NORTH, GO NORTH")
    print()
    PrettyPrint("ALIASES: GO, MOVE, WALK, RUN, TRAVEL, N, NORTH, S, SOUTH, E, EAST, W, WEST, U, UP, D, OR DOWN.")
end

-- Describe the GET command
function HelpGet()
    print()
    print()
    PrettyPrint("GET:")
    PrettyPrint("This command lets you take an item in the current area. It requires a second word describing the item to GET. Some things can not be taken. It can sometimes be difficult to get things without extra preparations. Generally in most text adventure games you get everything possible.")
    print()
    PrettyPrint("EXAMPLES: GET BALL, TAKE HAMMER.")
    print()
    PrettyPrint("ALIASES: GET, TAKE, OBTAIN, PICK, or PICKUP.")
end

-- Help for the HELP command
function HelpHelp()
    print()
    print()
    PrettyPrint("HELP:")
    PrettyPrint("The HELP command will display help information. If you use it without a parameter you get a general help display. If you specify a command as a parameter you get help specific to that command with examples and a list of aliases.")
    print()
    PrettyPrint("EXAMPLES: HELP, HELP USE")
    print()
    PrettyPrint("ALIASES: HELP, HINT, ABOUT")
end

-- Help for the INVENTORY command
function HelpInventory()
    print()
    print()
    PrettyPrint("INVENTORY:")
    PrettyPrint("The command inventory requires no parameters. It simply displays a list of items you are carrying around. Seeing a list of possessions may help you figure out the next tricky puzzle.")
    print()
    PrettyPrint("EXAMPLES: INVENTORY, BAG")
    print()
    PrettyPrint("ALIASES: INVENTORY, INV, I, OR BAG.")
end

-- Help for the OPEN command
function HelpOpen()
    print()
    print()
    PrettyPrint("OPEN")
    PrettyPrint("This command lets you either open or unlock an object in either the current area or your inventory. It requires a second word of the object to open. It is usually a good idea to open everything that can be opened.")
    print()
    PrettyPrint("EXAMPLES: UNLOCK DOOR, OPEN SAFE")
    print()
    PrettyPrint("ALIASES: OPEN, OR UNLOCK.")
end

-- Help for the QUIT command
function HelpQuit()
    print()
    print()
    PrettyPrint("QUIT:")
    PrettyPrint("This command will exit the game. The command does not require parameters. All progress WILL be lost. You will NOT be prompted to confirm your choice.")
    print()
    PrettyPrint("EXAMPLES: QUIT, EXIT")
    print()
    PrettyPrint("ALIASES: Q, QUIT, X, OR EXIT.")
end

-- Help for the TALK command
function HelpTalk()
    print()
    print()
    PrettyPrint("TALK:")
    PrettyPrint("The TALK command allows you to speak to other characters (human or otherwise) in the game. The command requires a second word specifying the person or object to talk to. This can often give you important clues. Be sure to talk to anyone or anything that will listen.")
    print()
    PrettyPrint("EXAMPLES: TALK JUDGE, SPEAK GUARD.")
    print()
    PrettyPrint("ALIASES: TALK, or SPEAK.")
end

-- HELP FOR THE USE COMMAND
function HelpUse()
    print()
    print()
    PrettyPrint("USE")
    PrettyPrint("This command lets you use an object in your inventory or the current area. It requires a second word whis is the name of the object to use. Using an object may consume or use up the object. Be careful to use things in the right place and time. Generally you will need to use the all items you pick up at some point in the game.")
    print()
    PrettyPrint("EXAMPLES: USE GUN, GIVE CROWN")
    print()
    PrettyPrint("ALIASES: USE, GIVE, OR ACTIVATE.")
end

-- Print out your inventory.
function VerbInventory()
    local i, value, ret 
    ret = ""

    for i, value in next, Objects do
        if value.location == "Inventory" then
            ret = ret .. ", " .. value.description
        end
    end

    if #ret == 0 then
        ret = "YOU AREN'T HOLDING ANYTHING."
    else
        ret = "YOU HAVE: " .. string.sub(ret, 3, #ret)
    end

    print()
    print()
    PrettyPrint(ret)
end

-- HANDLE THE OPEN VERB
function VerbOpen(what)
    local item

    item = FindObj(what)
    if item.name == "FLASHLIGHT" then
        CheckFlashlight()
     elseif item.name == "SAFE" then
        CheckSafe()
     elseif item ~= nil then
        print()
        print()
        if item.location == "Used" then
            PrettyPrint("YOU ARE ALL OUT OF " .. what + ".")
         elseif item.location == "Inventory" then
            PrettyPrint("YOU HAVE " .. what + " IN YOUR INVENTORY, BUT IT ISN'T SOMETHING YOU CAN OPEN.")
        else
            PrettyPrint(what .. " IS NOT SOMETHING YOU CAN OPEN.")
        end
    else
        print()
        print()
        RandomPrint("NOT AN INTERACTABLE OBJECT.|IS THAT AROUND HERE?|SORRY YOU CAN'T DO THAT", "|")
    end
end

-- Handle the verb quit
function VerbQuit()
    print()
    print()
    print("GOOD BYE")
    GameOver = true
end

-- Handle the verb talk
function VerbTalk(who)
    local cat, catnip, dog, girl, meat, target
    cat = FindObj("CAT")
    catnip = FindObj("CATNIP")
    dog = FindObj("DOG")
    girl = FindObj("GIRL")

    if CurrentRoom == girl.location and who == "GIRL" then
        if cat.location ~= "Inventory" and cat.location ~= "Used" then
            print()
            print()
            PrettyPrint("THE SAD LITTLE GIRL SAYS:")
            PrettyPrint("OH IT IS AWFUL! I HAVE LOST MY CAT! I CAN'T FIND HER ANYWHERE. PLEASE HELP ME FIND MY CAT.")
         elseif cat.location == "Inventory" then
            ReturnCat()
        else
            print()
            print()
            PrettyPrint("THE LITTLE GIRL SAYS:")
            PrettyPrint("WHY ARE YOU IN MY ROOM? GET OUT!")
            print()
            PrettyPrint("YOU ARE PUSHED OUT OF THE ROOM")
            CurrentRoom = "LivingRoom"
        end
     elseif who == "CAT" and (cat.location == CurrentRoom or cat.location == "Inventory") then
        if catnip.location == "Used" then
            print()
            print()
            RandomPrint("THE CAT SAYS: MEOW|THE CAT IGNORES YOU", "|")
        else
            print()
            print()
            PrettyPrint("THE CAT HISSES AT YOU FIERCELY!")
        end
     elseif who == "DOG" and dog.location == CurrentRoom then
        meat = FindObj("MEAT")
        if meat.location == "Used" then
            print()
            print()
            PrettyPrint("THE DOG IS BUSY EATING ITS MEAT AND IGNORES YOU")
        else
            print()
            print()
            PrettyPrint("THE DOG BARKS AT YOU WILDLY! YOU ARE CHASED OUT OF THE ROOM")
            CurrentRoom = "LivingRoom"
        end
    else
        target = FindObj(who)
        if target ~= nil then
            print()
            print()
            if target.location == "Inventory" or target.location == CurrentRoom then
                RandomPrint("YOU CAN TALK TO A " .. who .. ", BUT IT WON'T RESPOND.|WHY ARE YOU TALKING TO INANIMATE OBJECTS?", "|")
            else
                print()
                print()
                PrettyPrint("THERE IS NO " .. who + " TO TALK TO HERE.")
            end
        else
            print()
            print()
            PrettyPrint("WHAT ARE YOU TALKING TO? I DON'T SEE A " .. who .. " TO TALK TO.")
        end
    end
end

-- Handle the use verb
function VerbUse(what)
    local cat, catnip, dog, key, meat, safe, flashlight, batteries, girl, target

    target = FindObj(what)

    if what == "FLASHLIGHT" then
        ToggleFlashlight()
     elseif what == "KEY" then
        key = FindObj("KEY")
        safe = FindObj("SAFE")
        if key.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("YOU DON'T HAVE A KEY TO USE")
         elseif safe.location ~= CurrentRoom then
            print()
            print()
            PrettyPrint("YOU CAN'T USE THAT HERE.")
        else
            CheckSafe()
        end
     elseif what == "CATNIP" then
        cat = FindObj("CAT")
        catnip = FindObj("CATNIP")
        if catnip.location == "Used" then
            print()
            print()
            PrettyPrint("YOU ALREADY USED UP YOUR CATNIP.")
         elseif catnip.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("YOU DON'T HAVE ANY CATNIP.")
         elseif cat.location ~= CurrentRoom then
            print()
            print()
            PrettyPrint("YOU CAN'T USE THAT HERE.")
        else
            print()
            print()
            PrettyPrint("YOU GIVE THE CATNIP TO THE CAT. IT LOVES THE CATNIP AND APPEARS TO BE DISTRACTED.")
            if catnip ~= nil then
                catnip.location = "Used"
            end
        end
     elseif what == "MEAT" then
        dog = FindObj("DOG")
        meat = FindObj("MEAT")
        if meat.location == "Used" then
            print()
            print()
            PrettyPrint("YOU ALREADY USED UP YOUR MEAT.")
         elseif meat.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("YOU DON'T HAVE ANY MEAT.")
         elseif dog.location ~= CurrentRoom then
            print()
            print()
            PrettyPrint("YOU CAN'T USE THAT HERE.")
        else
            print()
            print()
            PrettyPrint("YOU GIVE THE MEAT TO THE DOG. IT LOVES THE MEAT AND APPEARS TO BE DISTRACTED.")
            if meat ~= nil then
                meat.location = "Used"
            end
        end
     elseif what == "BATTERIES" then
        flashlight = FindObj("FLASHLIGHT")
        batteries = FindObj("BATTERIES")
        if batteries.location == "Used" then
            print()
            print()
            PrettyPrint("YOU ALREADY USED YOUR BATTERIES.")
         elseif batteries.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("YOU DON'T HAVE ANY BATTERIES.")
         elseif flashlight.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("NOTHING TO USE BATTERIES WITH.")
        else
            CheckFlashlight()
        end
     elseif what == "CAT" then
        cat = FindObj("CAT")
        girl = FindObj("GIRL")
        if cat.location == "Used" then
            print()
            print()
            PrettyPrint("YOU ALREADY RETURNED THE CAT.")
         elseif cat.location ~= "Inventory" then
            print()
            print()
            PrettyPrint("YOU DON'T HAVE A CAT.")
         elseif girl.location ~= CurrentRoom then
            print()
            print()
            PrettyPrint("YOU CAN'T USE THAT HERE.")
        else
            ReturnCat()
        end
     elseif target ~= nil then
        print()
        print()
        if target.location == "Used" then
            PrettyPrint("YOU ARE ALL OUT OF " .. what .. ".")
         elseif target.location ~= "Inventory" then
            PrettyPrint("YOU DON'T HAVE ONE TO USE.")
        else
            PrettyPrint("SORRY YOU CAN'T USE THE " .. what .. ".")
        end
    end
end

-- Inspect the flashlight. Combine with the batteries if they are in the
-- inventory and have not been combined previously.
function CheckFlashlight()
    local flashlight, batteries

    flashlight = FindObj("FLASHLIGHT")
    batteries = FindObj("BATTERIES")

    if flashlight.location ~= "Inventory" then
        print()
        print()
        PrettyPrint("YOU DON'T HAVE A FLASHLIGHT")
     elseif batteries.location == "Used" then
        print()
        print()
        PrettyPrint("YOU OPEN THE FLASHLIGHT. NOTE THAT THE BATTERIES ARE IN PROPERLY AND CLOSE IT UP AGAIN.")
     elseif batteries.location == "Inventory" then
        print()
        print()
        PrettyPrint("YOU OPEN THE FLASHLIGHT. THERE ARE NO BATTERIES INSIDE. YOU CLEVERLY DECIDE TO COMBINE IT WITH THE BATTERIES IN YOUR INVENTORY.")
        batteries.location = "Used"
        print()
        PrettyPrint("CONGRATULATIONS! YOU NOW HAVE A WORKING FLASHLIGHT.")
    else
        print()
        print()
        PrettyPrint("YOU OPEN THE FLASHLIGHT. YOU SEE THAT THERE ARE NO BATTERIES INSIDE. IT WON'T WORK IN THIS CONDITION. YOU DECIDE TO CLOSE IT UP AGAIN.")
    end
end

-- Turn the flashlight on/off if usable
function ToggleFlashlight()
    local flashlight, batteries, objects
    
    flashlight = FindObj("FLASHLIGHT")
    batteries = FindObj("BATTERIES")

    if flashlight.location ~= "Inventory" then
        print()
        print()
        PrettyPrint("YOU DON'T HAVE A FLASHLIGHT")
     elseif batteries.location == "Used" then
        print()
        print()
        if FlashlightOn == true then
            PrettyPrint("YOU TURN THE FLASHLIGHT OFF.")
            FlashlightOn = false
        else
            PrettyPrint("YOU TURN ON THE FLASHLIGHT AND LOOK AROUND,")
            FlashlightOn = true
            objects = GetObjectList()
            if #objects > 0 then
                PrettyPrint("YOU CAN SEE: " .. objects)
            end
        end
    else
        print()
        print()
        PrettyPrint("THE FLASHLIGHT NEEDS BATTERIES")
        FlashlightOn = false
    end
end

-- Handle opening the safe if possible. Called from use(key) and open(safe)
function CheckSafe()
    local safe, key, batteries

    safe = FindObj("SAFE")
    key = FindObj("KEY")
    batteries = FindObj("BATTERIES")

    if safe.location ~= CurrentRoom then
        print()
        print()
        PrettyPrint("THERE IS NO SAFE IN HERE TO OPEN")
     elseif key.location == "Used" then
        print()
        print()
        PrettyPrint("THE SAFE IS ALREADY OPEN. NOTHING MORE OF USE IS INSIDE")
     elseif key.location == "Inventory" then
        print()
        print()
        PrettyPrint("YOU PUT THE KEY IN THE LOCK.")
        PrettyPrint("TURN THE KEY AND")
        PrettyPrint("...")
        PrettyPrint("OPEN THE SAFE.")

        if batteries ~= nil then
            batteries.location = "Inventory"
        end

        if key ~= nil then
            key.location = "Used"
        end

        print()
        PrettyPrint("INSIDE THE SAFE YOU FOUND...")
        PrettyPrint("BATTERIES.")
        PrettyPrint("YOU ADD THE BATTERIES TO YOUR INVENTORY.")
        PrettyPrint("THE KEY IS STUCK IN THE LOCK, OH WELL.")
    else
        print()
        print()
        PrettyPrint("YOU NEED A KEY TO OPEN THE SAFE.")
    end
end

-- Return the cat to the little girl, called from talk and use verbs.
function ReturnCat()
    local key, cat
    cat = FindObj("CAT")
    key = FindObj("KEY")
    print()
    print()
    PrettyPrint("THE LITTLE GIRL SAYS:")
    PrettyPrint("OH! THANK YOU! THANK YOU! YOU FOUND MY CAT!")
    print()
    PrettyPrint("FOR A REWARD, PLEASE ACCEPT THIS TOKEN OF MY APPRECIATION")

    if cat ~= nil then
        cat.location = "Used"
    end

    if key ~= nil then
        key.location = "Inventory"
    else
        print("KEY ERROR")
    end

    print()
    print("YOU GOT A KEY.")
end

-- Print out the introduction / title screen
function TitleScreen()
    CenterPrint("I LOST MY BALL")
    CenterPrint("==============")
    print()
    CenterPrint("a Text Adventure game.")
    print()
    PrettyPrint("YOU WERE PLAYING SPORTS WITH YOUR FRIENDS, WHEN YOUR BALL WENT BOUNCING AWAY. YOU SAW IT LAND SOMEWHERE NEAR THE MILDLY UNSETTLING HOUSE. IT IS YOUR JOB TO GET IT BACK AND ESCAPE THE HOUSE.")
    print()
    print("GOOD LUCK.")
    print()
    PrettyPrint("TYPE HELP FOR MORE INFORMATION ON COMMANDS AND HOW TO PLAY.")
    print()
    print()
end

-- Print a line of text centered HORIZONTALLY
-- note: it is assumed we are currently located at the first character position of a line.
-- msg: The message to print out
function CenterPrint(msg)
    if #msg >= SCREEN_WIDTH then
        PrettyPrint(msg, SCREEN_WIDTH)
    else
        print(string.rep(" ", math.floor(((SCREEN_WIDTH - #msg) / 2))) .. msg)
    end
end

-- Return a random phrase for a invalid direction response
-- returns: a random message for a direction you cannot travel to.
function BadDir()
    local i
    i = math.random(0, 3)
    if i == 0 then
        return("YOU CAN'T GO THAT WAY")
     elseif i == 1 then
        return("SORRY, THAT WON'T WORK")
     elseif i == 2 then
        return("YOU CAN'T MOVE THERE")
    else
        return("THERE IS NOWHERE TO GO IN THAT DIRECTION")
    end
end

-- Return a comma separated list of directions the user can travel
function GetExits()
    local ret, current_room
    ret = ""
    current_room = Rooms[CurrentRoom]
    if (current_room.north ~= "None") then ret = ret .. ", NORTH" end
    if (current_room.south ~= "None") then ret = ret .. ", SOUTH" end
    if (current_room.east ~= "None") then ret = ret .. ", EAST" end
    if (current_room.west ~= "None") then ret = ret .. ", WEST" end
    if (current_room.up ~= "None") then ret = ret .. ", UP" end
    if (current_room.down ~= "None") then ret = ret .. ", DOWN" end

    if #ret > 2 then
        ret = string.sub(ret, 3, #ret)
    else
        ret = ""
    end

    return(ret)
end

-- Return a description of object in the current room
function GetObjectList()
    local i, value, ret
    ret = ""

    if CurrentRoom == "Cellar" and FlashlightOn == false then
        ret = "IT IS TOO DARK TO SEE ANYTHING"
    else
        for i, value in next, Objects do
            if value.location == CurrentRoom then
                ret = ret .. ", " .. value.name
            end
        end

        if #ret > 2 then
            ret = string.sub(ret, 3, #ret)
        else 
            ret = ""
        end
    end

    return ret
end

-- Search for an object with a given name. Return nil if not found, and the object otherwise
-- name: The name of the object to search for
function FindObj(name)
    local i, value
    for i, value in next, Objects do
        if value.name == name then
            return value
        end
    end
    return nil
end

-- Print a random response from a delimited string
-- options: delimited string of response options
-- delim: delimiter character
function RandomPrint(options, delim)
    local resp
    resp = string.split(options, "|")
    
    if #resp == 0 then
        print("WHAT?!")
    else
        PrettyPrint(resp[math.random(1, #resp)])
    end
end

-- Print a long string with nice line breaks on word boundaries
-- msg: The string to print breaking on word boundaries before end of screen width
function PrettyPrint(msg)
    local i, ofs
    ofs = 1
    while (ofs <= #msg) do
        i = math.min(#msg - ofs + 1, SCREEN_WIDTH)
        while (i > 0 and string.sub(msg, i + ofs - 1, i + ofs - 1) ~= " " and i + ofs <= #msg) do
            i = i - 1
        end
        print(string.sub(msg, ofs, ofs + i - 1))
        ofs = ofs + i
    end
end

-- Split a string into a table of values between a given delimiter
-- this function shamelessly stolen from lua-users.org/wiki/SplitJoin
-- requires lua 5.3.3+
-- sSeparator: delimiter (character or pattern)
-- nMax: maximum number of values to return nil or postive integers
-- bRegexp: Is the separator a regular expression.
-- returns: table of results with a row per found item 
function string:split(sSeparator, nMax, bRegexp)  
    local aRecord = {}
    
    if self:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1
    
        local nField, nStart = 1, 1
        local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst-1)
            nField = nField+1
            nStart = nLast+1
            nFirst,nLast = self:find(sSeparator, nStart, bPlain)
            nMax = nMax-1
        end
        aRecord[nField] = self:sub(nStart)
    end
    
    return aRecord
end

-- Return the given string except with white space characters removed from 
-- the beginning and end.
-- this function shamelessly stolen from lua-users.org/wiki/StringTrim
-- s: string to trim
-- returns: trimmed copy of the input s
function Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
 end

-- Return a copy of the input string with everything but alphanumerics removed.
-- msg: The string to filter
-- returns: filtered version of the input msg
function FilterAlphanumeric(msg)
    local ret = ""
    for word in string.gmatch(msg, "[%w%s]+") do
        ret = ret .. word
    end
    return ret
end

-- Check to see if a given string exists with a table.
-- return true if found, and false otherwise.
-- item: string to search for
-- items: table to search through
-- returns: boolean true if found, false otherwise
function InTable(item, items)
    local i, value

    for i, value in next, items do
        if (value == item) then
            return true
        end
    end
    return false
end


-- Print out a simple list table.
-- items: table to print out
function PrintTable(items)
    local i, value

    for i, value in next, items do
        print(tostring(i) .. value)
    end
end


-- Pause the program for the amount of time given
-- time: The amount of time to pause in seconds. Fractions ok.
function Wait(time)
    local duration = os.time() + time
    while os.time() < duration do end
end

TitleScreen()

-- MAIN GAME LOOP
CurrentRoom = "Start"
Ball = FindObj("BALL")
FlashlightOn = false
GameOver = false
InputOK = false

while GameOver == false do
    repeat
        PrettyPrint(Rooms[CurrentRoom].description)
        ObjectList = GetObjectList()
        if #ObjectList > 0 then
            print()
            PrettyPrint("YOU CAN SEE: " .. ObjectList)
        end

        Travel = GetExits()
        if #Travel > 0 then
            PrettyPrint("YOU CAN GO: " .. Travel)
        end

        InputOK = true
        print("WHAT WILL YOU DO")
        Inp = io.read()
        Words = string.split(string.upper(FilterAlphanumeric(Trim(Inp))), " ")

        if #Words == 0 then
            InputOK = false
        end

        if InputOK then
            if #Words >= 3 then
                if Words[1] == "PICK" and Words[2] == "UP" then
                    table.remove(Words, 1)
                    Words[1] = "GET"
                end
            end

            if Words[1] == "GET" or Words[1] == "TAKE" or Words[1] == "OBTAIN" or Words[1] == "PICK" or Words[1] == "PICKUP" then
                if #Words > 1 then
                    VerbGet(Words[2])
                else
                    print()
                    print()
                    PrettyPrint("WHAT DO YOU WANT TO GET?")
                end
            elseif Words[1] == "OPEN" or Words[1] == "UNLOCK" then
                if #Words > 1 then
                    VerbOpen(Words[2])
                else
                    print()
                    print()
                    PrettyPrint("WHAT DO YOU WANT TO OPEN?")
                end
            elseif Words[1] == "USE" or Words[1] == "GIVE" or Words[1] == "ACTIVATE" then
                if #Words > 1 then
                    VerbUse(Words[2])
                else
                    print()
                    print()
                    PrettyPrint("WHAT DO YOU WANT TO USE?")
                end
            elseif #Words > 1 and (Words[1] == "GO" or Words[1] == "MOVE" or Words[1] == "WALK" or Words[1] == "RUN" or Words[1] == "TRAVEL") then
                VerbGo(Words[2])
            elseif #Words == 1 and InTable(Words[1], Directions) then
                VerbGo(Words[1])
            elseif #Words == 1 and (Words[1] == "INVENTORY" or Words[1] == "INV" or Words[1] == "I" or Words[1] == "BAG") then
                VerbInventory()
            elseif (Words[1] == "TALK" or Words[1] == "SPEAK") then
                if #Words > 1 then
                    VerbTalk(Words[2])
                else
                    print()
                    print()
                    PrettyPrint("WHO DO YOU WANT TO TALK TO?")
                end
            elseif Words[1] == "HELP" or Words[1] == "HINT" or Words[1] == "ABOUT" then
                if #Words > 1 then
                    VerbHelp(Words[2])
                else
                    VerbHelp("")
                end
            elseif Words[1] == "DANCE" or Words[1] == "BOOGIE" then
                VerbDance()
            elseif Words[1] == "Q" or Words[1] == "QUIT" or Words[1] == "X" or Words[1] == "EXIT" then
                VerbQuit()
            else
                print("HUH?") 
                -- Wait(1.0)
                InputOK = false
            end
            print()
            print()
        end
    until InputOK

    if GameOver == false and Ball.location == "Inventory" and CurrentRoom == "Start" then
        print()
        print()
        PrettyPrint("YOU DID IT!!")
        print()
        PrettyPrint("YOU FOUND YOUR BALL AND ESCAPED THE MILDLY UNSETTLING HOUSE.")
        print()
        print()
        PrettyPrint("YOU WIN!!")
        GameOver = true
    end

end

Wait(1.667)

do return end
