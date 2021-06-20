OPTION _EXPLICIT
OPTION BASE 0

'Conversion Notes:
'VAR -> DIM
'ARRAY's use () instead of []
'Line labels shouldn't use @Label, just Label:
'DEF Function/END to SUB function/END SUB or FUNCTION function/END FUNCTION, SUB must have parameters in parenthesis
'!= -> <>
'OPTION STRICT -> OPTION _EXPLICIT
'RETURN value -> FUNCTION_NAME = value
'UCASE$ is built-in
'Cannot declare and initialize on the same line
' = -> =
' REPEAT UNTIL -> DO LOOP UNTIL
' Only basic alphanumeric supported, can't draw most graphical characters such as the button symbols
' Don't seem to be able to pass and array in/out of a function
' PUSH/POP do not exist, try REDIM
' LEN(array) -> UBOUND(array) - LBOUND(array) + 1
' CONTINUE -> _CONTINUE
' BREAK should be replaced with EXIT FOR, EXIT DO, etc.
' SHIFT is not available
' WAIT -> _DELAY or SLEEP
' GLOBAL VARIABLES should be DIM SHARED
' FUNCTIONS with no parameters should not be called with parenthesis ()
' CSRX -> USE POS(0)
' String Multiplication doesn't exist example " " * 3 = "   "
' MIN/MAX not present
' DEC/INC not present
' DATA must be before SUBs/FUNCTIONs, no comments allowed at end of data line. No variables in data (learned that from True/False)
' MID$ starts at 1, not 0
' ARRAYS start at 1 without OPTION BASE 0

'I LOST MY BALL
'by Stewart / SeggiePants - 2017
'=========================================
'A SMALL TEXT ADVENTURE. MEANT TO BE
'USABLE AS A BASE FOR OTHER LARGER TEXT
'ADVENTURE GAMES, OR AS A LEARNING TOOL.
'SOMEWHAT OVERGROWN FOR THAT LAST OPTION.
'
'YOU LOST YOUR BALL, NOW YOU HAVE TO VENTURE
'INTO THE MILDLY UNSETTLING HOUSE TO GET IT
'BACK, AND HOPE TO MAKE IT BACK OUT AGAIN.
'
DIM SHARED FALSE, TRUE
TRUE = 1
FALSE = 0
DIM SHARED NUM_ROOMS%, I%, N%, S%, E%, W%, U%, D%
DIM SHARED DESC$, TRAVEL$, GAME_OVER%
GAME_OVER% = FALSE
DIM SHARED ROOM%, INP$, INPUT_OK%, IDX_BALL%
ROOM% = 0
REDIM SHARED WORDS$(0)
DIM SHARED NUM_OBJS%, OBJS$, TMP$
DIM SHARED LOC_INVENTORY%, LOC_USED%
LOC_INVENTORY% = -2
LOC_USED% = -3
DIM SHARED FLASHLIGHT_ON%, MAXW%
FLASHLIGHT_ON% = FALSE
MAXW% = 80

'DESCRIPTION FOLLOWED BY WHICH ROOM YOU GET
'TO BY EACH DIRECTION (NSEWUD). -1 = CAN'T
'GO THAT WAY
ROOM_TABLE:
DATA 9
'9 ROOMS
'0 - ENTRANCE
DATA "YOU STAND AT THE OPEN DOORWAY OF THE MILDLY UNSETTLING HOUSE. A TREE TOWERS ABOVE YOU, THE FRONT DOOR IS TO THE EAST, AND A PATHWAY SOUTH LEADS TO A SMALL GARDEN"
DATA -1,4,2,-1,1,-1
'1 - UP A TREE
DATA "YOU FIND YOURSELF UP HIGH IN A LARGE TREE. DOWN BELOW YOU IS THE MILDLY UNSETTLING HOUSE."
DATA -1,-1,-1,-1,-1,0
'2 - LIVING ROOM
DATA "YOU ARE IN THE LIVING ROOM, BUT NOBODY SEEMS TO BE AROUND. TO THE EAST IS A BEDROOM, NORTH THE GARAGE, SOUTH THE KITCHEN, AND WEST HEADS BACK TO THE ENTRANCE"
DATA 7,5,3,0,-1,-1
'3 - CHILDS BEDROOM
DATA "YOU ARE IN A BEDROOM BELONGING TO A LITTLE GIRL. THE LIVING ROOM IS TO THE WEST"
DATA -1,-1,-1,2,-1,-1
'4 - GARDEN
DATA "YOU FIND YOURSELF IN A SMALL OVERGROWN GARDEN. THE MAIN ENTRANCE IS TO YOUR NORTH, AND AN ENTRANCE TO THE KITCHEN TO THE EAST"
DATA 0,-1,5,-1,-1,-1
'5 - KITCHEN
DATA "A MESSY KITCHEN IN NEED OF A GOOD CLEANING SURROUNDS YOU. NORTH LEADS TO THE LIVING ROOM, WEST TO THE GARDEN, AND EAST TO THE BATHROOM"
DATA 2,-1,6,4,-1,-1
'6 - BATHROOM
DATA "YOU FIND YOURSELF IN A SMELLY BATHROOM. THE KITCHEN IS TO YOUR WEST"
DATA -1,-1,-1,5,-1,-1
'7 - GARAGE
DATA "A CAVERNOUS GARAGE LOOMS AROUND YOU. YOU CAN RETURN SOUTH TO THE LIVING ROOM, OR GO DOWN TO THE CELLAR FROM HERE"
DATA -1,2,-1,-1,-1,8
'8 - CELLAR
DATA "BLACKNESS FILLS THE DARK CELLAR. YOU CAN CLIMB UP INTO THE GARAGE."
DATA -1,-1,-1,-1,7,-1

'NAME, LOCATION, PICKUPABLE
'LOCATION -2 = INVENTORY, -3 = USED/CONSUMED
'IF LARGER THAN MAX ROOM NUMBER THEN IT IS
'SPECIAL/GIVEN/OFF-MAP
OBJECT_TABLE:
DATA 10
DATA "CAT",1,1
DATA "CATNIP",4,1
DATA "SAFE",2,0
DATA "KEY",10,1
DATA "BATTERIES",10,1
DATA "MEAT",5,1
DATA "FLASHLIGHT",6,1
DATA "DOG",7,0
DATA "BALL",8,1
DATA "GIRL",3,0

'LIST OF DIRECTIONS, JUST TO TEST PRETTIER
DIRECTION_TABLE:
DATA 12
DATA "N","NORTH","S","SOUTH","E","EAST"
DATA "W","WEST","U","UP","D","DOWN"

'LOAD THE ROOM DATA
RESTORE ROOM_TABLE
NUM_ROOMS% = 0
READ NUM_ROOMS%

DIM SHARED ROOM_DESC$(NUM_ROOMS%)
DIM SHARED ROOM_TABLE%(NUM_ROOMS%, 6)

FOR I% = 0 TO NUM_ROOMS% - 1
    READ DESC$, N%, S%, E%, W%, U%, D%
    ROOM_DESC$(I%) = DESC$
    ROOM_TABLE%(I%, 0) = N%
    ROOM_TABLE%(I%, 1) = S%
    ROOM_TABLE%(I%, 2) = E%
    ROOM_TABLE%(I%, 3) = W%
    ROOM_TABLE%(I%, 4) = U%
    ROOM_TABLE%(I%, 5) = D%
NEXT I%

'LOAD THE OBJECT TABLE
RESTORE OBJECT_TABLE
READ NUM_OBJS%

DIM SHARED OBJ_DESC$(NUM_OBJS%)
DIM SHARED OBJ_ROOM%(NUM_OBJS%)
DIM SHARED OBJ_PICKUP%(NUM_OBJS%)

FOR I% = 0 TO NUM_OBJS% - 1
    READ DESC$, ROOM%, N%
    OBJ_DESC$(I%) = DESC$
    OBJ_ROOM%(I%) = ROOM%
    OBJ_PICKUP%(I%) = N%
NEXT I%

'LOAD DIRECTION TABLE
RESTORE DIRECTION_TABLE
READ N%

DIM SHARED DIR$(N%)

FOR I% = 0 TO N% - 1
    READ DESC$
    DIR$(I%) = DESC$
NEXT I%

TITLE_SCREEN

'MAIN GAME LOOP
ROOM% = 0 'START AT ROOM 0
IDX_BALL% = GET_OBJ_INDEX("BALL")

WHILE GAME_OVER% = FALSE
    DO
        PRETTY_PRINT ROOM_DESC$(ROOM%)
        OBJS$ = GET_OBJS$(ROOM%)
        IF LEN(OBJS$) > 0 THEN
            PRINT
            PRETTY_PRINT "YOU CAN SEE: " + OBJS$
        END IF

        TRAVEL$ = GET_EXITS$(ROOM%)
        IF LEN(TRAVEL$) > 0 THEN
            PRETTY_PRINT "YOU CAN GO: " + TRAVEL$
        END IF

        INPUT_OK% = TRUE
        INPUT "WHAT WILL YOU DO"; INP$
        SPLIT_WORDS UCASE$(TRIM$(FILTER_ALPHANUMERIC$(INP$))), " "

        IF LEN_WORDS = 0 THEN
            INPUT_OK% = FALSE
            _CONTINUE
        END IF

        IF LEN_WORDS >= 3 THEN
            IF WORDS$(0) = "PICK" AND WORDS$(1) = "UP" THEN
                TMP$ = SHIFT_WORDS$
                WORDS$(0) = "GET"
            END IF
        END IF

        IF WORDS$(0) = "GET" OR WORDS$(0) = "TAKE" OR WORDS$(0) = "OBTAIN" OR WORDS$(0) = "PICK" OR WORDS$(0) = "PICKUP" THEN
            IF LEN_WORDS > 1 THEN
                VERB_GET WORDS$(1)
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "WHAT DO YOU WANT TO GET?"
            END IF
        ELSEIF WORDS$(0) = "OPEN" OR WORDS$(0) = "UNLOCK" THEN
            IF LEN_WORDS > 1 THEN
                VERB_OPEN WORDS$(1)
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "WHAT DO YOU WANT TO OPEN?"
            END IF
        ELSEIF WORDS$(0) = "USE" OR WORDS$(0) = "GIVE" OR WORDS$(0) = "ACTIVATE" THEN
            IF LEN_WORDS > 1 THEN
                VERB_USE WORDS$(1)
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "WHAT DO YOU WANT TO USE?"
            END IF
        ELSEIF LEN_WORDS > 1 AND (WORDS$(0) = "GO" OR WORDS$(0) = "MOVE" OR WORDS$(0) = "WALK" OR WORDS$(0) = "RUN" OR WORDS$(0) = "TRAVEL") THEN
            VERB_GO WORDS$(1)
        ELSEIF LEN_WORDS = 1 AND IS_DIR(WORDS$(0)) THEN
            VERB_GO WORDS$(0)
        ELSEIF LEN_WORDS = 1 AND (WORDS$(0) = "INVENTORY" OR WORDS$(0) = "INV" OR WORDS$(0) = "I" OR WORDS$(0) = "BAG") THEN
            VERB_INVENTORY
        ELSEIF (WORDS$(0) = "TALK" OR WORDS$(0) = "SPEAK") THEN
            IF LEN_WORDS > 1 THEN
                VERB_TALK WORDS$(1)
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "WHO DO YOU WANT TO TALK TO?"
            END IF
        ELSEIF WORDS$(0) = "HELP" OR WORDS$(0) = "HINT" OR WORDS$(0) = "ABOUT" THEN
            IF LEN_WORDS > 1 THEN
                VERB_HELP WORDS$(1)
            ELSE
                VERB_HELP ""
            END IF
        ELSEIF WORDS$(0) = "DANCE" OR WORDS$(0) = "BOOGIE" THEN
            VERB_DANCE
        ELSEIF WORDS$(0) = "Q" OR WORDS$(0) = "QUIT" OR WORDS$(0) = "X" OR WORDS$(0) = "EXIT" THEN
            VERB_QUIT
        ELSE
            PRINT "HUH?" ': _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
        PRINT
        PRINT
    LOOP UNTIL INPUT_OK%

    IF GAME_OVER% = FALSE AND OBJ_ROOM%(IDX_BALL%) = LOC_INVENTORY% AND ROOM% = 0 THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU DID IT!!"
        PRINT
        PRETTY_PRINT "YOU FOUND YOUR BALL AND ESCAPED THE MILDLY UNSETTLING HOUSE."
        PRINT
        PRINT
        PRETTY_PRINT "YOU WIN!!"
        GAME_OVER% = TRUE
    END IF

WEND

_DELAY 1.667

END

'HANDLE THE GET VERB

SUB VERB_GET (WHAT$)
    DIM IDX_ITEM%, IDX_CATNIP%
    IDX_ITEM% = GET_OBJ_INDEX(WHAT$)
    IDX_CATNIP% = GET_OBJ_INDEX("CATNIP")

    IF IDX_ITEM% = -1 THEN
        PRINT
        PRINT
        RANDOM_PRINT "YOU CAN'T GET THAT|THERE IS NO " + WHAT$ + " THAT YOU CAN GET|I DON'T THINK SO", "|"
    ELSEIF IDX_ITEM% = LOC_INVENTORY% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU ALREADY HAVE THAT."
    ELSEIF IDX_ITEM% = LOC_USED% THEN
        PRINT
        PRINT
        PRETTY_PRINT "THERE IS NO MORE TO BE FOUND."
    ELSEIF OBJ_ROOM%(IDX_ITEM%) <> ROOM% THEN
        PRINT
        PRINT
        PRETTY_PRINT "I DON'T SEE ANY " + WHAT$ + " AROUND HERE."
    ELSE
        IF ROOM% = 8 AND FLASHLIGHT_ON% = FALSE THEN
            PRINT
            PRINT
            PRETTY_PRINT "IT IS TOO DARK TO SEE DOWN HERE."
        ELSEIF WHAT$ = "CAT" THEN
            IF OBJ_ROOM%(IDX_CATNIP%) = LOC_USED% THEN
                PRINT
                PRINT
                PRETTY_PRINT "YOU QUICKLY PICK UP THE CAT WHILE IT IS DISTRACTED."
                OBJ_ROOM%(IDX_ITEM%) = LOC_INVENTORY%
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "THE CAT HISSES AND CLAWS AT YOU. DISTRACTED, YOU FALL FROM THE TREE TO YOUR DEATH."
                GAME_OVER% = TRUE
                PRINT
                PRETTY_PRINT "GAME OVER."
            END IF
        ELSEIF OBJ_PICKUP%(IDX_ITEM%) = FALSE THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU CAN'T PICK THAT UP."
        ELSE
            OBJ_ROOM%(IDX_ITEM%) = LOC_INVENTORY%
            PRINT
            PRINT
            RANDOM_PRINT "YOU GOT THE " + WHAT$ + "!|" + WHAT$ + " OBTAINED|YOU PICKED UP THE " + WHAT$ + "! GOOD FOR YOU!", "|"
        END IF
    END IF
END SUB

'HANDLE THE SECRET VERB DANCE
SUB VERB_DANCE ()
    IF ROOM% = 1 THEN
        PRINT
        PRETTY_PRINT "YOUR DANCE MOVES, WHILE GRAND, UNBALACE YOU. YOU FALL FROM THE TREE TO YOUR DEATH. GAME OVER!"
        GAME_OVER% = TRUE
    ELSEIF ROOM% = 3 THEN
        PRINT
        PRETTY_PRINT "DESPITE YOUR AWESOME DANCE MOVES, THE LITTLE GIRL IS UNIMPRESSED."
    ELSEIF ROOM% = 8 THEN
        PRINT
        PRETTY_PRINT "YOUR OUTRAGEOUS DANCE MOVES CAUSE YOU TO TRIP AND FALL IN THE DARK. YOU BROKE YOUR NECK AND DIED. GAME OVER!"
        GAME_OVER% = TRUE
    ELSE
        PRINT
        PRETTY_PRINT "WA HOO! GET DOWN AND BOOGIE, YOU ARE A DANCING MACHINE!"
    END IF
END SUB

'HANDLE THE GO COMMAND
SUB VERB_GO (DIR$)
    DIM IDX_MEAT%
    IF DIR$ = "N" OR DIR$ = "NORTH" THEN
        IF ROOM_TABLE%(ROOM%, 0) >= 0 THEN
            ROOM% = ROOM_TABLE%(ROOM%, 0)
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSEIF DIR$ = "S" OR DIR$ = "SOUTH" THEN
        IF ROOM_TABLE%(ROOM%, 1) >= 0 THEN
            ROOM% = ROOM_TABLE%(ROOM%, 1)
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSEIF DIR$ = "E" OR DIR$ = "EAST" THEN
        IF ROOM_TABLE%(ROOM%, 2) >= 0 THEN
            ROOM% = ROOM_TABLE%(ROOM%, 2)
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSEIF DIR$ = "W" OR DIR$ = "WEST" THEN
        IF ROOM_TABLE%(ROOM%, 3) >= 0 THEN
            ROOM% = ROOM_TABLE%(ROOM%, 3)
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSEIF DIR$ = "U" OR DIR$ = "UP" THEN
        IF ROOM_TABLE%(ROOM%, 4) >= 0 THEN
            ROOM% = ROOM_TABLE%(ROOM%, 4)
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSEIF DIR$ = "D" OR DIR$ = "DOWN" THEN
        IF ROOM_TABLE%(ROOM%, 5) >= 0 THEN
            IF ROOM_TABLE%(ROOM%, 5) = 8 THEN
                IDX_MEAT% = GET_OBJ_INDEX("MEAT")
                IF OBJ_ROOM%(IDX_MEAT%) <> LOC_USED% THEN
                    PRINT
                    PRINT
                    PRETTY_PRINT "THE DOG GOES WILD!"
                    PRETTY_PRINT "IT WAS GUARDING THE CELLAR"
                    PRINT
                    PRETTY_PRINT "..."
                    PRINT
                    PRETTY_PRINT "THE DOG KILLED YOU."
                    PRINT
                    PRETTY_PRINT "GAME OVER!"
                    GAME_OVER% = TRUE
                ELSE
                    PRINT
                    PRINT
                    PRETTY_PRINT "THE DOG EYES YOU SUSPICIOUSLY BUT IS TOO BUSY EATING TO STOP YOU."
                    ROOM% = ROOM_TABLE%(ROOM%, 5)
                END IF
            ELSE
                ROOM% = ROOM_TABLE%(ROOM%, 5)
            END IF
        ELSE
            PRETTY_PRINT BAD_DIR$: _DELAY 1.0
            INPUT_OK% = FALSE
        END IF
    ELSE
        PRETTY_PRINT BAD_DIR$: _DELAY 1.0
        INPUT_OK% = FALSE
    END IF
END SUB

'HANDLE THE HELP VERB. GENERAL HELP IF NO
'TOPIC SPECIFIED, SPECIFIC HELP IS AVAILABLE
'OTHERWISE
SUB VERB_HELP (TOPIC$)
    IF TOPIC$ = "" THEN
        PRINT
        PRINT
        PRETTY_PRINT "HELP:"
        PRETTY_PRINT "In this game you lost your ball and must find it and escape again. This is a text adventure game. In this type of game you type in commands on the keyboard (remember to hit Enter/Return). The method is similar to the DOS or UNIX command prompt. The game will attempt to decipher your command and report back any new status or location."
        PRINT
        PRETTY_PRINT "This sort of game was popular in the early days of computing before graphics were standard. They normally focus on puzzles and word problems. Sometimes part of the game is figuring out what commands are available."
        PRINT
        PRETTY_PRINT "For additional information try getting help on one of the topics below."
        PRINT
        PRETTY_PRINT "AVAILABLE COMMANDS: GET, GO, HELP, INVENTORY, OPEN, QUIT, TALK, USE"
    ELSEIF TOPIC$ = "GET" OR TOPIC$ = "TAKE" OR TOPIC$ = "OBTAIN" OR TOPIC$ = "PICK" OR TOPIC$ = "PICKUP" THEN
        HELP_GET
    ELSEIF IS_DIR(TOPIC$) OR TOPIC$ = "GO" OR TOPIC$ = "MOVE" OR TOPIC$ = "WALK" OR TOPIC$ = "RUN" OR TOPIC$ = "TRAVEL" THEN
        HELP_GO
    ELSEIF TOPIC$ = "HELP" OR TOPIC$ = "HINT" OR TOPIC$ = "ABOUT" THEN
        HELP_HELP
    ELSEIF TOPIC$ = "OPEN" OR TOPIC$ = "UNLOCK" THEN
        HELP_OPEN

    ELSEIF TOPIC$ = "TALK" OR TOPIC$ = "SPEAK" THEN
        HELP_TALK
    ELSEIF TOPIC$ = "USE" OR TOPIC$ = "GIVE" OR TOPIC$ = "ACTIVATE" THEN
        HELP_USE
    ELSEIF TOPIC$ = "INVENTORY" OR TOPIC$ = "INV" OR TOPIC$ = "I" OR TOPIC$ = "BAG" THEN
        HELP_INVENTORY
    ELSEIF TOPIC$ = "Q" OR TOPIC$ = "QUIT" OR TOPIC$ = "X" OR TOPIC$ = "EXIT" THEN
        HELP_QUIT
    ELSE
        PRINT
        PRINT
        PRETTY_PRINT " SORRY, I DON'T HAVE A PAGE FOR " + TOPIC$ + "."
    END IF
END SUB

'DESCRIBE THE GO COMMAND
SUB HELP_GO ()
    PRINT
    PRINT
    PRETTY_PRINT "GO:"
    PRETTY_PRINT "GO is a unique command. It can be use in one and two word format. For the single word format just enter the direction or its abbreviation (N,NORTH,S,SOUTH,E,EAST,W,WEST,U,UP,D,DOWN). For two word mode type GO followed by the desired direction of travel. You may not be able to go in all directions in most locations. Normally a list of available directions you may travel in is printed after the room description."
    PRINT
    PRETTY_PRINT "EXAMPLES N, NORTH, GO NORTH"
    PRINT
    PRETTY_PRINT "ALIASES: GO, MOVE, WALK, RUN, TRAVEL, N, NORTH, S, SOUTH, E, EAST, W, WEST, U, UP, D, OR DOWN."
END SUB

'DESCRIBE THE GET COMMAND
SUB HELP_GET ()
    PRINT
    PRINT
    PRETTY_PRINT "GET:"
    PRETTY_PRINT "This command lets you take an item in the current area. It requires a second word describing the item to GET. Some things can not be taken. It can sometimes be difficult to get things without extra preparations. Generally in most text adventure games you get everything possible."
    PRINT
    PRETTY_PRINT "EXAMPLES: GET BALL, TAKE HAMMER."
    PRINT
    PRETTY_PRINT "ALIASES: GET, TAKE, OBTAIN, PICK, OR PICKUP."
END SUB

'HELP FOR THE HELP COMMAND
SUB HELP_HELP ()
    PRINT
    PRINT
    PRETTY_PRINT "HELP:"
    PRETTY_PRINT "The HELP command will display help information. If you use it without a parameter you get a general help display. If you specify a command as a parameter you get help specific to that command with examples and a list of aliases."
    PRINT
    PRETTY_PRINT "EXAMPLES: HELP, HELP USE"
    PRINT
    PRETTY_PRINT "ALIASES: HELP, HINT, ABOUT"
END SUB

'HELP FOR THE INVENTORY COMMAND
SUB HELP_INVENTORY ()
    PRINT
    PRINT
    PRETTY_PRINT "INVENTORY:"
    PRETTY_PRINT "The command inventory requires no parameters. It simply displays a list of items you are carrying around. Seeing a list of possessions may help you figure out the next tricky puzzle."
    PRINT
    PRETTY_PRINT "EXAMPLES: INVENTORY, BAG"
    PRINT
    PRETTY_PRINT "ALIASES: INVENTORY, INV, I, OR BAG."
END SUB

'HELP FOR THE OPEN COMMAND
SUB HELP_OPEN ()
    PRINT
    PRINT
    PRETTY_PRINT "OPEN"
    PRETTY_PRINT "This command lets you either open or unlock an object in either the current area or your inventory. It requires a second word of the object to open. It is usually a good idea to open everything that can be opened."
    PRINT
    PRETTY_PRINT "EXAMPLES: UNLOCK DOOR, OPEN SAFE"
    PRINT
    PRETTY_PRINT "ALIASES: OPEN, OR UNLOCK."
END SUB

'HELP FOR THE QUIT COMMAND
SUB HELP_QUIT ()
    PRINT
    PRINT
    PRETTY_PRINT "QUIT:"
    PRETTY_PRINT "This command will exit the game. The command does not require parameters. All progress WILL be lost. You will NOT be prompted to confirm your choice."
    PRINT
    PRETTY_PRINT "EXAMPLES: QUIT, EXIT"
    PRINT
    PRETTY_PRINT "ALIASES: Q, QUIT, X, OR EXIT."
END SUB

'HELP FOR THE TALK COMMAND
SUB HELP_TALK ()
    PRINT
    PRINT
    PRETTY_PRINT "TALK:"
    PRETTY_PRINT "The TALK command allows you to speak to other characters (human or otherwise) in the game. The command requires a second word specifying the person or object to talk to. This can often give you important clues. Be sure to talk to anyone or anything that will listen."
    PRINT
    PRETTY_PRINT "EXAMPLES: TALK JUDGE, SPEAK GUARD."
    PRINT
    PRETTY_PRINT "ALIASES: TALK, OR SPEAK."
END SUB

'HELP FOR THE USE COMMAND
SUB HELP_USE ()
    PRINT
    PRINT
    PRETTY_PRINT "USE"
    PRETTY_PRINT "This command lets you use an object in your inventory or the current area. It requires a second word whis is the name of the object to use. Using an object may consume or use up the object. Be careful to use things in the right place and time. Generally you will need to use the all items you pick up at some point in the game."
    PRINT
    PRETTY_PRINT "EXAMPLES: USE GUN, GIVE CROWN"
    PRINT
    PRETTY_PRINT "ALIASES: USE, GIVE, OR ACTIVATE."
END SUB

'PRINT OUT YOUR INVENTORY
SUB VERB_INVENTORY ()
    DIM I%, RET$
    RET$ = ""

    FOR I% = 0 TO NUM_OBJS%
        IF OBJ_ROOM%(I%) = LOC_INVENTORY% THEN
            RET$ = RET$ + ", " + OBJ_DESC$(I%)
        END IF
    NEXT I%

    IF LEN(RET$) = 0 THEN
        RET$ = "YOU AREN'T HOLDING ANYTHING."
    ELSE
        RET$ = "YOU HAVE: " + MID$(RET$, 2, LEN(RET$) - 1)
    END IF

    PRINT
    PRINT
    PRETTY_PRINT RET$

END SUB

'HANDLE THE OPEN VERB
SUB VERB_OPEN (WHAT$)
    DIM IDX_WHAT%

    IDX_WHAT% = GET_OBJ_INDEX(WHAT$)
    IF WHAT$ = "FLASHLIGHT" THEN
        CHECK_FLASHLIGHT
    ELSEIF WHAT$ = "SAFE" THEN
        CHECK_SAFE
    ELSEIF IDX_WHAT% <> -1 THEN
        PRINT
        PRINT
        IF OBJ_ROOM%(IDX_WHAT%) = LOC_USED% THEN
            PRETTY_PRINT "YOU ARE ALL OUT OF " + WHAT$ + "."
        ELSEIF OBJ_ROOM%(IDX_WHAT%) = LOC_INVENTORY% THEN
            PRETTY_PRINT "YOU HAVE " + WHAT$ + " IN YOUR INVENTORY, BUT IT ISN'T SOMETHING YOU CAN OPEN."
        ELSE
            PRINT WHAT$ + " IS NOT SOMETHING YOU CAN OPEN."
        END IF
    ELSE
        PRINT
        PRINT
        RANDOM_PRINT "NOT AN INTERACTABLE OBJECT.|IS THAT AROUND HERE?|SORRY YOU CAN'T DO THAT", "|"
    END IF
END SUB

'HANDLE THE QUIT VERB
SUB VERB_QUIT ()
    PRINT
    PRINT
    PRINT "GOOD BYE"
    GAME_OVER% = TRUE
END SUB

'HANDLE THE TALK VERB.
SUB VERB_TALK (WHO$)
    DIM IDX_CAT%, IDX_CATNIP%, IDX_DOG%
    DIM IDX_MEAT%, IDX_GIRL%, IDX_WHO%
    IDX_CAT% = GET_OBJ_INDEX("CAT")
    IDX_CATNIP% = GET_OBJ_INDEX("CATNIP")
    IDX_DOG% = GET_OBJ_INDEX("DOG")
    IDX_GIRL% = GET_OBJ_INDEX("GIRL")

    IF ROOM% = OBJ_ROOM%(IDX_GIRL%) AND WHO$ = "GIRL" THEN
        IF OBJ_ROOM%(IDX_CAT%) <> LOC_INVENTORY% AND OBJ_ROOM%(IDX_CAT%) <> LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "THE SAD LITTLE GIRL SAYS:"
            PRETTY_PRINT "OH IT IS AWFUL! I HAVE LOST MY CAT! I CAN'T FIND HER ANYWHERE. PLEASE HELP ME FIND MY CAT."
        ELSEIF OBJ_ROOM%(IDX_CAT%) = LOC_INVENTORY% THEN
            RETURN_CAT
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "THE LITTLE GIRL SAYS:"
            PRETTY_PRINT "WHY ARE YOU IN MY ROOM? GET OUT!"
            PRINT
            PRETTY_PRINT "YOU ARE PUSHED OUT OF THE ROOM"
            ROOM% = 2
        END IF
    ELSEIF WHO$ = "CAT" AND (OBJ_ROOM%(IDX_CAT%) = ROOM% OR OBJ_ROOM%(IDX_CAT%) = LOC_INVENTORY%) THEN
        IDX_CATNIP% = GET_OBJ_INDEX("CATNIP")
        IF OBJ_ROOM%(IDX_CATNIP%) = LOC_USED% THEN
            PRINT
            PRINT
            RANDOM_PRINT "THE CAT SAYS: MEOW|THE CAT IGNORES YOU", "|"
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "THE CAT HISSES AT YOU FIERCELY!"
        END IF
    ELSEIF WHO$ = "DOG" AND OBJ_ROOM%(IDX_DOG%) = ROOM% THEN
        IDX_MEAT% = GET_OBJ_INDEX("MEAT")
        IF OBJ_ROOM%(IDX_MEAT%) = LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "THE DOG IS BUSY EATING ITS MEAT AND IGNORES YOU"
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "THE DOG BARKS AT YOU WILDLY! YOU ARE CHASED OUT OF THE ROOM"
            ROOM% = 2
        END IF
    ELSE
        IDX_WHO% = GET_OBJ_INDEX(WHO$)
        IF IDX_WHO% <> -1 THEN
            PRINT
            PRINT
            IF OBJ_ROOM%(IDX_WHO%) = LOC_INVENTORY% OR OBJ_ROOM%(IDX_WHO%) = ROOM% THEN
                RANDOM_PRINT "YOU CAN TALK TO A " + WHO$ + ", BUT IT WON'T RESPOND.|WHY ARE YOU TALKING TO INANIMATE OBJECTS?", "|"
            ELSE
                PRINT
                PRINT
                PRETTY_PRINT "THERE IS NO " + WHO$ + " TO TALK TO HERE."
            END IF
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "WHAT ARE YOU TALKING TO? I DON'T SEE A " + WHO$ + " TO TALK TO."
        END IF
    END IF
END SUB

'HANDLE THE USE VERB
SUB VERB_USE (WHAT$)
    DIM IDX_CAT%, IDX_CATNIP%, IDX_DOG%
    DIM IDX_KEY%, IDX_MEAT%, IDX_SAFE%
    DIM IDX_FLASHLIGHT%, IDX_BATTERIES%
    DIM IDX_GIRL%, IDX_WHAT%

    IDX_WHAT% = GET_OBJ_INDEX(WHAT$)
    IF WHAT$ = "FLASHLIGHT" THEN
        TOGGLE_FLASHLIGHT
    ELSEIF WHAT$ = "KEY" THEN
        IDX_KEY% = GET_OBJ_INDEX("KEY")
        IDX_SAFE% = GET_OBJ_INDEX("SAFE")
        IF OBJ_ROOM%(IDX_KEY%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU DON'T HAVE A KEY TO USE"
        ELSEIF OBJ_ROOM%(IDX_SAFE%) <> ROOM% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU CAN'T USE THAT HERE."
        ELSE
            CHECK_SAFE
        END IF
    ELSEIF WHAT$ = "CATNIP" THEN
        IDX_CAT% = GET_OBJ_INDEX("CAT")
        IDX_CATNIP% = GET_OBJ_INDEX("CATNIP")
        IF OBJ_ROOM%(IDX_CATNIP%) = LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU ALREADY USED UP YOUR CATNIP."
        ELSEIF OBJ_ROOM%(IDX_CATNIP%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU DON'T HAVE ANY CATNIP."
        ELSEIF OBJ_ROOM%(IDX_CAT%) <> ROOM% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU CAN'T USE THAT HERE."
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "YOU GIVE THE CATNIP TO THE CAT. IT LOVES THE CATNIP AND APPEARS TO BE DISTRACTED."
            IF IDX_CATNIP% >= 0 THEN
                OBJ_ROOM%(IDX_CATNIP%) = LOC_USED%
            END IF
        END IF
    ELSEIF WHAT$ = "MEAT" THEN
        IDX_DOG% = GET_OBJ_INDEX("DOG")
        IDX_MEAT% = GET_OBJ_INDEX("MEAT")
        IF OBJ_ROOM%(IDX_MEAT%) = LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU ALREADY USED UP YOUR MEAT."
        ELSEIF OBJ_ROOM%(IDX_MEAT%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU DON'T HAVE ANY MEAT."
        ELSEIF OBJ_ROOM%(IDX_DOG%) <> ROOM% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU CAN'T USE THAT HERE."
        ELSE
            PRINT
            PRINT
            PRETTY_PRINT "YOU GIVE THE MEAT TO THE DOG. IT LOVES THE MEAT AND APPEARS TO BE DISTRACTED."
            IF IDX_MEAT% >= 0 THEN
                OBJ_ROOM%(IDX_MEAT%) = LOC_USED%
            END IF
        END IF
    ELSEIF WHAT$ = "BATTERIES" THEN
        IDX_FLASHLIGHT% = GET_OBJ_INDEX("FLASHLIGHT")
        IDX_BATTERIES% = GET_OBJ_INDEX("BATTERIES")
        IF OBJ_ROOM%(IDX_BATTERIES%) = LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU ALREADY USED YOUR BATTERIES."
        ELSEIF OBJ_ROOM%(IDX_BATTERIES%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU DON'T HAVE ANY BATTERIES."
        ELSEIF OBJ_ROOM%(IDX_FLASHLIGHT%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "NOTHING TO USE BATTERIES WITH."
        ELSE
            CHECK_FLASHLIGHT
        END IF
    ELSEIF WHAT$ = "CAT" THEN
        IDX_CAT% = GET_OBJ_INDEX("CAT")
        IDX_GIRL% = GET_OBJ_INDEX("GIRL")
        IF OBJ_ROOM%(IDX_CAT%) = LOC_USED% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU ALREADY RETURNED THE CAT."
        ELSEIF OBJ_ROOM%(IDX_CAT%) <> LOC_INVENTORY% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU DON'T HAVE A CAT."
        ELSEIF OBJ_ROOM%(IDX_GIRL%) <> ROOM% THEN
            PRINT
            PRINT
            PRETTY_PRINT "YOU CAN'T USE THAT HERE."
        ELSE
            RETURN_CAT
        END IF
    ELSEIF IDX_WHAT% >= 0 THEN
        PRINT
        PRINT
        IF OBJ_ROOM%(IDX_WHAT%) = LOC_USED% THEN
            PRETTY_PRINT "YOU ARE ALL OUT OF " + WHAT$ + "."
        ELSEIF OBJ_ROOM%(IDX_WHAT%) <> LOC_INVENTORY% THEN
            PRETTY_PRINT "YOU DON'T HAVE ONE TO USE."
        ELSE
            PRETTY_PRINT "SORRY YOU CAN'T USE THE " + WHAT$ + "."
        END IF
    END IF
END SUB

'INSPECT THE FLASHLIGHT. COMBINE WITH THE
'BATTERIES IF AVAILABLE AND NOT DONE
'PREVIOUSLY
SUB CHECK_FLASHLIGHT ()
    DIM IDX_FLASHLIGHT%, IDX_BATTERIES%

    IDX_FLASHLIGHT% = GET_OBJ_INDEX("FLASHLIGHT")
    IDX_BATTERIES% = GET_OBJ_INDEX("BATTERIES")

    IF OBJ_ROOM%(IDX_FLASHLIGHT%) <> LOC_INVENTORY% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU DON'T HAVE A FLASHLIGHT"
    ELSEIF OBJ_ROOM%(IDX_BATTERIES%) = LOC_USED% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU OPEN THE FLASHLIGHT. NOTE THAT THE BATTERIES ARE IN PROPERLY AND CLOSE IT UP AGAIN."
    ELSEIF OBJ_ROOM%(IDX_BATTERIES%) = LOC_INVENTORY% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU OPEN THE FLASHLIGHT. THERE ARE NO BATTERIES INSIDE. YOU CLEVERLY DECIDE TO COMBINE IT WITH THE BATTERIES IN YOUR INVENTORY."
        OBJ_ROOM%(IDX_BATTERIES%) = LOC_USED%
        PRINT
        PRETTY_PRINT "CONGRATULATIONS! YOU NOW HAVE A WORKING FLASHLIGHT."
    ELSE
        PRINT
        PRINT
        PRETTY_PRINT "YOU OPEN THE FLASHLIGHT. YOU SEE THAT THERE ARE NO BATTERIES INSIDE. IT WON'T WORK IN THIS CONDITION. YOU DECIDE TO CLOSE IT UP AGAIN."
    END IF
END SUB

'TURN THE FLASHLIGHT ON/OFF IF AVAILABLE
SUB TOGGLE_FLASHLIGHT ()
    DIM IDX_FLASHLIGHT%, IDX_BATTERIES%, OBJS$

    IDX_FLASHLIGHT% = GET_OBJ_INDEX("FLASHLIGHT")
    IDX_BATTERIES% = GET_OBJ_INDEX("BATTERIES")

    IF OBJ_ROOM%(IDX_FLASHLIGHT%) <> LOC_INVENTORY% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU DON'T HAVE A FLASHLIGHT"
    ELSEIF OBJ_ROOM%(IDX_BATTERIES%) = LOC_USED% THEN
        PRINT
        PRINT
        IF FLASHLIGHT_ON% = TRUE THEN
            PRETTY_PRINT "YOU TURN THE FLASHLIGHT OFF."
            FLASHLIGHT_ON% = FALSE
        ELSE
            PRETTY_PRINT "YOU TURN ON THE FLASHLIGHT AND LOOK AROUND,"
            FLASHLIGHT_ON% = TRUE
            OBJS$ = GET_OBJS$(ROOM%)
            IF LEN(OBJS$) > 0 THEN
                PRETTY_PRINT "YOU CAN SEE: " + OBJS$
            END IF
        END IF
    ELSE
        PRINT
        PRINT
        PRETTY_PRINT "THE FLASHLIGHT NEEDS BATTERIES"
        FLASHLIGHT_ON% = FALSE
    END IF
END SUB

'HANDLE OPENING THE SAFE IF POSSIBLE
'CALLED FOM USE(KEY) AND OPEN(SAFE)
SUB CHECK_SAFE ()
    DIM IDX_SAFE%, IDX_KEY%, IDX_BATTERIES%

    IDX_SAFE% = GET_OBJ_INDEX("SAFE")
    IDX_KEY% = GET_OBJ_INDEX("KEY")
    IDX_BATTERIES% = GET_OBJ_INDEX("BATTERIES")

    IF OBJ_ROOM%(IDX_SAFE%) <> ROOM% THEN
        PRINT
        PRINT
        PRETTY_PRINT "THERE IS NO SAFE IN HERE TO OPEN"
    ELSEIF OBJ_ROOM%(IDX_KEY%) = LOC_USED% THEN
        PRINT
        PRINT
        PRETTY_PRINT "THE SAFE IS ALREADY OPEN. NOTHING MORE OF USE IS INSIDE"
    ELSEIF OBJ_ROOM%(IDX_KEY%) = LOC_INVENTORY% THEN
        PRINT
        PRINT
        PRETTY_PRINT "YOU PUT THE KEY IN THE LOCK."
        PRETTY_PRINT "TURN THE KEY AND"
        PRETTY_PRINT "..."
        PRETTY_PRINT "OPEN THE SAFE."

        IF IDX_BATTERIES% >= 0 THEN
            OBJ_ROOM%(IDX_BATTERIES%) = LOC_INVENTORY%
        END IF

        IF IDX_KEY% >= 0 THEN
            OBJ_ROOM%(IDX_KEY%) = LOC_USED%
        END IF

        PRINT
        PRETTY_PRINT "INSIDE THE SAFE YOU FOUND..."
        PRETTY_PRINT "BATTERIES."
        PRETTY_PRINT "YOU ADD THE BATTERIES TO YOUR INVENTORY."
        PRETTY_PRINT "THE KEY IS STUCK IN THE LOCK, OH WELL."
    ELSE
        PRINT
        PRINT
        PRETTY_PRINT "YOU NEED A KEY TO OPEN THE SAFE."
    END IF
END SUB

'RETURN THE CAT TO THE LITTLE GIRL
'CALLED FROM TALK, AND USE
SUB RETURN_CAT ()
    DIM IDX_KEY%, IDX_CAT%

    IDX_CAT% = GET_OBJ_INDEX("CAT")
    IDX_KEY% = GET_OBJ_INDEX("KEY")
    PRINT
    PRINT
    PRETTY_PRINT "THE LITTLE GIRL SAYS:"
    PRETTY_PRINT "OH! THANK YOU! THANK YOU! YOU FOUND MY CAT!"
    PRINT
    PRETTY_PRINT "FOR A REWARD, PLEASE ACCEPT THIS TOKEN OF MY APPRECIATION"

    IF IDX_CAT% <> -1 THEN
        OBJ_ROOM%(IDX_CAT%) = LOC_USED%
    END IF

    IF IDX_KEY% <> -1 THEN
        OBJ_ROOM%(IDX_KEY%) = LOC_INVENTORY%
    ELSE
        PRINT "KEY ERROR"
    END IF

    PRINT
    PRETTY_PRINT "YOU GOT A KEY."
END SUB

'PRINT OUT THE INTRODUCTION / TITLE SCREEN
SUB TITLE_SCREEN ()
    CLS
    CENTER_PRINT "I LOST MY BALL"
    CENTER_PRINT "=============="
    PRINT
    CENTER_PRINT "a Text Adventure game."
    PRINT
    PRETTY_PRINT "YOU WERE PLAYING SPORTS WITH YOUR FRIENDS, WHEN YOUR BALL WENT BOUNCING AWAY. YOU SAW IT LAND SOMEWHERE NEAR THE MILDLY UNSETTLING HOUSE. IT IS YOUR JOB TO GET IT BACK AND ESCAPE THE HOUSE."
    PRINT
    PRINT "GOOD LUCK."
    PRINT
    PRETTY_PRINT "TYPE HELP FOR MORE INFORMATION ON COMMANDS AND HOW TO PLAY."
    PRINT
    PRINT
END SUB

'PRINT A LINE OF TEXTED CENTERED HORIZONTALLY
SUB CENTER_PRINT (MSG$)
    IF LEN(MSG$) >= MAXW% THEN
        PRETTY_PRINT MSG$
    ELSE
        IF POS(0) <> 0 THEN PRINT
        PRINT STRING_MULTIPLY$(" ", ((MAXW% - LEN(MSG$)) / 2));
        PRINT MSG$
    END IF
END SUB

'RETURN A RANDOM PHRASE FOR A INVALID
'DIRECTION REAPONSE. SHOULD JUST USE
'RANDOM_PRINT
FUNCTION BAD_DIR$ ()
    DIM I%
    I% = RND(4)
    IF I% = 0 THEN
        BAD_DIR$ = "YOU CAN'T GO THAT WAY"
    ELSEIF I% = 1 THEN
        BAD_DIR$ = "SORRY, THAT WON'T WORK"
    ELSEIF I% = 2 THEN
        BAD_DIR$ = "YOU CAN'T MOVE THERE"
    ELSE
        BAD_DIR$ = "THERE IS NOWHERE TO GO IN THAT DIRECTION"
    END IF
END FUNCTION

'RETURN A COMMA SEPARATED LIST OF DIRECTIONS
'THE USER CAN TRAVEL
FUNCTION GET_EXITS$ (ROOM%)
    DIM RET$
    RET$ = ""
    IF ROOM_TABLE%(ROOM%, 0) >= 0 THEN RET$ = RET$ + ", NORTH"
    IF ROOM_TABLE%(ROOM%, 1) >= 0 THEN RET$ = RET$ + ", SOUTH"
    IF ROOM_TABLE%(ROOM%, 2) >= 0 THEN RET$ = RET$ + ", EAST"
    IF ROOM_TABLE%(ROOM%, 3) >= 0 THEN RET$ = RET$ + ", WEST"
    IF ROOM_TABLE%(ROOM%, 4) >= 0 THEN RET$ = RET$ + ", UP"
    IF ROOM_TABLE%(ROOM%, 5) >= 0 THEN RET$ = RET$ + ", DOWN"

    IF LEN(RET$) > 0 THEN
        GET_EXITS$ = MID$(RET$, 2, LEN(RET$) - 1)
    ELSE
        GET_EXITS$ = ""
    END IF
END FUNCTION

'RETURN A DESCRIPTION OF OBJECTS IN A GIVEN
'ROOM
FUNCTION GET_OBJS$ (ROOM%)
    DIM RET$, I%

    IF ROOM% = 8 AND FLASHLIGHT_ON% = FALSE THEN
        GET_OBJS$ = "IT IS TOO DARK TO SEE ANYTHING"
    ELSE
        FOR I% = 0 TO NUM_OBJS%
            IF OBJ_ROOM%(I%) = ROOM% THEN
                RET$ = RET$ + ", " + OBJ_DESC$(I%)
            END IF
        NEXT I%

        IF LEN(RET$) > 0 THEN
            GET_OBJS$ = MID$(RET$, 2, LEN(RET$) - 1)
        ELSE
            GET_OBJS$ = ""
        END IF
    END IF
END FUNCTION

'SEARCH FOR AN OBJECT WITH A GIVEN NAME.
'RETURN -1 IF NOT FOUND, INDEX FOUND AT
'OTHERWISE
FUNCTION GET_OBJ_INDEX (DESC$)
    DIM I%, RET%
    RET% = -1

    FOR I% = 0 TO NUM_OBJS%
        IF OBJ_DESC$(I%) = DESC$ THEN
            RET% = I%
            EXIT FOR
        END IF
    NEXT I%

    GET_OBJ_INDEX = RET%

END FUNCTION

'PRINT A RANDOM RESPONSE FROM A DELIMITED
'STRING
SUB RANDOM_PRINT (OPTIONS$, DELIM$)
    REDIM RESP$(0)
    DIM CH$, WORD$, I%
    RESP$(0) = ""
    FOR I% = 1 TO LEN(OPTIONS$)
        CH$ = MID$(OPTIONS$, I%, 1)
        IF CH$ = DELIM$ THEN
            IF RESP$(UBOUND(RESP$)) <> "" THEN
                REDIM _PRESERVE RESP$(UBOUND(RESP$) + 1)
            END IF
            RESP$(UBOUND(RESP$)) = WORD$
            WORD$ = ""
        ELSE
            WORD$ = WORD$ + CH$
        END IF
    NEXT I%

    IF RESP$(UBOUND(RESP$)) <> "" THEN
        REDIM _PRESERVE RESP$(UBOUND(RESP$) + 1)
    END IF
    RESP$(UBOUND(RESP$)) = WORD$


    IF RESP$(UBOUND(RESP$)) = "" THEN
        PRINT "WHAT?!"
    ELSE
        PRETTY_PRINT RESP$(RND(UBOUND(RESP$) + 1))
    END IF
END SUB

FUNCTION MIN (L1%, L2%)
    IF L2% > L1% THEN
        MIN = L1%
    ELSE
        MIN = L2%
    END IF
END FUNCTION

'PRINT A LONG STRING WITH NICE LINE BREAKS
'ON WORD BOUNDARIES
SUB PRETTY_PRINT (MSG$)
    DIM I%, OFS%
    OFS% = 1
    WHILE OFS% <= LEN(MSG$)
        I% = MIN(LEN(MSG$) - OFS% + 1, MAXW% - POS(0))
        WHILE I% > 0 AND MID$(MSG$, I% + OFS% - 1, 1) <> " " AND I% + OFS% <= LEN(MSG$)
            I% = I% - 1
        WEND
        PRINT MID$(MSG$, OFS%, I%)
        OFS% = OFS% + I%
    WEND
END SUB

'RETURN THE GIVEN STRING EXCEPT WITH
'WHITE SPACE CHARACTERS REMOVED FROM THE
'STRINGS BEGINNING AND END.
FUNCTION TRIM$ (MSG$)
    DIM I%, J%, CH$
    IF LEN(MSG$) > 0 THEN
        I% = 1
        J% = LEN(MSG$)
        CH$ = MID$(MSG$, I%, 1)
        WHILE CH$ = " " OR CH$ = CHR$(9) OR CH$ = CHR$(10) OR CH$ = CHR$(13)
            I% = I% + 1
            IF I% >= J% THEN EXIT WHILE
            CH$ = MID$(MSG$, I%, 1)
        WEND

        CH$ = MID$(MSG$, J%, 1)
        WHILE CH$ = " " OR CH$ = CHR$(9) OR CH$ = CHR$(10) OR CH$ = CHR$(13)
            J% = J% - 1
            IF J% <= I% THEN EXIT WHILE
            CH$ = MID$(MSG$, J%, 1)
        WEND

        TRIM$ = MID$(MSG$, I%, J% - I% + 1)
    ELSE
        TRIM$ = ""
    END IF
END FUNCTION

'SPLIT WORDS IN A GIVEN STRING DELIMITED BY DELIMITER
'UPDATE THE WORDS$ ARRAY WITH RESULTS
SUB SPLIT_WORDS (MSG$, DELIM$)
    DIM CH$, WORD$, I%
    REDIM WORDS$(0)
    WORDS$(0) = ""
    FOR I% = 1 TO LEN(MSG$)
        CH$ = MID$(MSG$, I%, 1)
        IF CH$ = DELIM$ THEN
            IF WORDS$(UBOUND(WORDS$)) <> "" THEN
                REDIM _PRESERVE WORDS$(UBOUND(WORDS$) + 1)
            END IF
            WORDS$(UBOUND(WORDS$)) = WORD$
            WORD$ = ""

        ELSE
            WORD$ = WORD$ + CH$
        END IF
    NEXT I%

    IF WORDS$(UBOUND(WORDS$)) <> "" THEN
        REDIM _PRESERVE WORDS$(UBOUND(WORDS$) + 1)
    END IF
    WORDS$(UBOUND(WORDS$)) = WORD$
END SUB

'RETURN A COPY OF THE INPUT STRING
'WITH EVERYTHING BUT ALPHANUMERICS REMOVED
FUNCTION FILTER_ALPHANUMERIC$ (MSG$)
    DIM RET$, CH$, I%
    RET$ = ""
    FOR I% = 1 TO LEN(MSG$)
        CH$ = MID$(MSG$, I%, 1)
        IF (CH$ >= "A" AND CH$ <= "Z") OR (CH$ >= "a" AND CH$ <= "z") OR CH$ = " " OR CH$ = CHR$(13) OR CH$ = CHR$(10) OR CH$ = CHR$(9) THEN
            RET$ = RET$ + CH$
        END IF
    NEXT I%
    FILTER_ALPHANUMERIC$ = RET$
END FUNCTION

'CHECK TO SEE IF A GIVEN STRING DIRECTION$ EXISTS
'WITHIN THE ARRAY DIR$
FUNCTION IS_DIR (DIRECTION$)
    DIM I%, RET%
    RET% = FALSE

    FOR I% = 0 TO UBOUND(DIR$)
        IF DIR$(I%) = DIRECTION$ THEN
            RET% = TRUE
            EXIT FOR
        END IF
    NEXT I%

    IS_DIR = RET%
END FUNCTION

FUNCTION SHIFT_WORDS$ ()
    DIM RET$, I%
    IF LEN_WORDS > 0 THEN
        RET$ = WORDS$(LBOUND(WORDs$))
        FOR I% = LBOUND(WORDS$) TO UBOUND(WORDS$) - 1
            WORDS$(I%) = WORDS$(I% + 1)
        NEXT I%
        REDIM _PRESERVE WORDS$(UBOUND(WORDS$) - 1)
        SHIFT_WORDS$ = RET$
    ELSE
        SHIFT_WORDS$ = ""
    END IF
END FUNCTION

FUNCTION LEN_WORDS ()
    LEN_WORDS = UBOUND(WORDS$) - LBOUND(WORDS$) + 1
END FUNCTION

FUNCTION STRING_MULTIPLY$ (MSG$, COUNT%)
    DIM I%, RET$
    RET$ = ""
    FOR I% = 0 TO COUNT%
        RET$ = RET$ + MSG$
    NEXT I%

    STRING_MULTIPLY$ = RET$
END FUNCTION
