import random, sys, time, math, pygame
from pygame.locals import *

# MUGWUMP 2D
# ----------
# A graphical version of MUGWUMP from BASIC COMPUTER GAMES
# by Bob Albrecht, Bud Valenti, Edited by David H. Ahl
# ported by SeggiePants

FPS = 30 # Frames per second

GAME_TITLE = 'MUGWUMP 2D'
TEXT_SIZE = 16
BORDER_W = TEXT_SIZE * 2
BORDER_H = BORDER_W

COUNT_MUGWUMPS = 4
MAX_GUESSES =10
GRID_W = 10
GRID_H = GRID_W

# SCREEN SIZE
SCREEN_W = 720
SCREEN_H = 400

# COLORS
BLACK = (0, 0, 0)
DARK_GRAY = (64, 64, 64)
LIGHT_BLUE = (128, 128, 255)
LIGHT_GRAY = (192, 192, 192)
ORANGE = (255, 128, 0)
PINK = (255, 0, 128)
RED = (255, 0, 0)
TEAL = (12, 140, 127)
VIOLET = (192, 0, 255)
WHITE = (255, 255, 255)

bodyColors = [PINK, VIOLET, LIGHT_BLUE, ORANGE]

class Grid:
    def __init__(self, width = GRID_W, height = GRID_H, textSize = TEXT_SIZE, screenWidth = SCREEN_W, screenHeight = SCREEN_H, borderWidth = BORDER_W, borderHeight = BORDER_H):
        self.width = width
        self.height = height
        self.textSize = textSize
        self.mugwumps = []
        font = pygame.font.SysFont(None, textSize)

        # Save the digits on the side of the grid to pre-rendered surfaces.
        self.digits = []
        for i in range(max(self.width, self.height)):
            self.digits.append(font.render(str(i), False, WHITE, None))

        self.cellW = (screenWidth - (borderWidth * 2)) / self.width
        self.cellH = (screenHeight - (borderHeight * 2)) / self.height
        self.cellW = min(self.cellW, self.cellH)
        self.cellH = self.cellW

        self.x = screenWidth - (self.cellW * self.width) - borderWidth
        self.y = math.floor((screenHeight - (self.cellH * self.height)) / 2)

        self.guesses = []
        self.pos = {'x': 0, 'y': 0}
    
    def newGame(self, numMugwumps):
        self.guesses = []
        self.mugwumps = []
        for i in range(numMugwumps):
            positionOK = False
            x = 0
            y = 0
            while not positionOK:
                x = random.randrange(0, self.width)
                y = random.randrange(0, self.height)
                positionOK = True
                # can I replace this with a list comprehension?
                for j in range(len(self.mugwumps)):
                    if (x == self.mugwumps[j].x and y == self.mugwumps[j].y):
                        positionOK = False
                        break
                color = bodyColors[i % len(bodyColors)]
                self.mugwumps.append(Mugwump(False, x, y, color, WHITE, BLACK, BLACK))
    
    def draw(self, surf):
        # Horizontal lines
        for j in range(self.height + 1):
            pygame.draw.line(surf, WHITE, (self.x, self.y + (j * self.cellH)), (self.x + (self.width * self.cellW), self.y + (j * self.cellH)))
        
        # Horizontal digits
        for j in range(self.height):
            r = self.digits[j].get_rect()   
            r.midright = (self.x - self.textSize, self.y + ((self.height - j) * self.cellH) - math.floor(self.cellH / 2))
            surf.blit(self.digits[j], r)
        
        # Vertical lines
        for i in range(self.width + 1):
            pygame.draw.line(surf, WHITE, (self.x + (i * self.cellW), self.y), (self.x + (i * self.cellW), self.y + (self.height * self.cellH)))
        
        # Vertical digits
        for i in range(self.width):
            r = self.digits[i].get_rect()
            r.midtop = (self.x + math.floor(self.cellW / 2) + (i * self.cellW), self.y + (self.height * self.cellH) + math.floor(self.textSize / 2))
            surf.blit(self.digits[i], r)
        
        for guess in self.guesses:
            x = self.x + 1 + (self.cellW * guess['x'])
            y = self.y + 1 + (self.cellH * guess['y'])
            r = pygame.Rect(x, y, self.cellW - 2, self.cellH - 2)
            pygame.draw.rect(surf, RED, r, 0)
        
        if (self.pos['x'] >= 0 and self.pos['x'] < self.width and self.pos['y'] >= 0 and self.pos['y'] < self.height):
            x = self.x + 3 + (self.cellW * self.pos['x'])
            y = self.y + 3 + (self.cellH * self.pos['y'])
            r = pygame.Rect(x, y, self.cellW - 6, self.cellH - 6)
            pygame.draw.rect(surf, TEAL, r, 0)

        for mugwump in self.mugwumps:
            if mugwump.found:
                mugwump.draw(surf, self.x + (self.cellW * mugwump.x) + 1, self.y + (self.cellH) + 1, self.cellW - 2)

class Mugwump:
    def __init__(self, found, x, y, color, eyeColor, pupilColor, mouthColor):
        self.found = found
        self.x = x
        self.y = y
        self.color = color 
        self.eyeColor = eyeColor
        self.pupilColor = pupilColor
        self.mouthColor = mouthColor

    def draw(self, surf, x, y, size):
        centerX = x + math.floor(size / 2)
        centerY = y + math.floor(size / 2)
        
        eyeDx = math.floor(size /4)
        eyeDy = math.floor(size / 4)

        pygame.draw.circle(surf, self.color, (centerX, centerY), math.floor(size / 2), 0)
        pygame.draw.circle(surf, self.eyeColor, (centerX - eyeDx, centerY - eyeDy), math.floor(size / 5), 0)
        pygame.draw.circle(surf, self.eyeColor, (centerX + eyeDx, centerY - eyeDy), math.floor(size / 5), 0)
        pygame.draw.circle(surf, self.pupilColor, (centerX - eyeDx, centerY - eyeDy), math.floor(size / 10), 0)
        pygame.draw.circle(surf, self.pupilColor, (centerX + eyeDx, centerY - eyeDy), math.floor(size / 10), 0)


'''        
'MUGWUMP DATA
VAR MUGWUMP_FOUND[COUNT_MUGWUMPS]
VAR MUGWUMP_X[COUNT_MUGWUMPS]
VAR MUGWUMP_Y[COUNT_MUGWUMPS]
VAR MUGWUMP_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_EYE_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_PUPIL_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_MOUTH_COLOR[COUNT_MUGWUMPS]

VAR EXIT_GAME = #FALSE
VAR GAME_OVER, MUGWUMPS_FOUND
VAR B, TX, TY, TSTATUS, SX#, SY#
VAR I, POS_X, POS_Y

ACLS
XSCREEN #SCREEN_W, #SCREEN_H

EXIT_GAME = #FALSE
INIT_GRID

WHILE EXIT_GAME == #FALSE
 INIT_MUGWUMPS
 GUESS_COUNT = 0
 POS_X = FLOOR((GRID_W - 1) / 2)
 POS_Y = FLOOR((GRID_H - 1) / 2)
 GAME_OVER = #FALSE
 EXIT_GAME = #FALSE
 
 WHILE GAME_OVER == #FALSE
  TOUCH OUT TSTATUS, TX, TY
  
  STICK #CONTROLLER_ID, #STICK_LEFT OUT SX#, SY#
  
  IF (BUTTON(#CONTROLLER_ID, #B_LUP, #BUTTON_PRESSED) OR SY# < -0.5) THEN
   POS_Y = MAX(0, POS_Y - 1)
  ENDIF
  
  IF (BUTTON(#CONTROLLER_ID, #B_LDOWN, #BUTTON_PRESSED) OR SY# > 0.5) THEN
   POS_Y = MIN(GRID_H - 1, POS_Y + 1)
  ENDIF
  
  IF (BUTTON(#CONTROLLER_ID, #B_LLEFT, #BUTTON_PRESSED) OR SX# < -0.5) THEN
   POS_X = MAX(0, POS_X - 1)
  ENDIF
  
  IF (BUTTON(#CONTROLLER_ID, #B_LRIGHT, #BUTTON_PRESSED) OR SX# > 0.5) THEN
   POS_X = MIN(GRID_W - 1, POS_X + 1)
  ENDIF
  
  B = BUTTON(#CONTROLLER_ID, #B_RDOWN, #BUTTON_PRESSED)
  
  
  'TOUCHED?
  IF TSTATUS != 0 THEN
   'WITHIN THE GRID? 
   IF TX >= GRID_X AND TX <= GRID_X + (GRID_W * CELL_W) AND TY >= GRID_Y AND TY <= GRID_Y + (GRID_H * CELL_H) THEN
    'WARP THERE
    POS_X = FLOOR((TX - GRID_X) / CELL_W)
    POS_Y = FLOOR((TY - GRID_Y) / CELL_H)
    
    'SET THE ACTION BUTTON
    B = #TRUE
   ENDIF
  ENDIF
  
  IF BUTTON(#CONTROLLER_ID, #B_RUP, #BUTTON_PRESSED) OR GUESS_COUNT >= MAX_GUESSES THEN
   GAME_OVER = #TRUE
   IF BUTTON(#CONTROLLER_ID, #B_RUP, #BUTTON_PRESSED) THEN
    EXIT_GAME = #TRUE
   ENDIF
  ELSEIF B == #TRUE THEN
   IF IS_GUESS_OK(POS_X, POS_Y) THEN
    GUESS_X[GUESS_COUNT] = POS_X
    GUESS_Y[GUESS_COUNT] = POS_Y
    INC GUESS_COUNT
    FOR I = 0 TO COUNT_MUGWUMPS - 1
     'MARK ANY MUGWUMP FOUND IF POSSIBLE
     IF MUGWUMP_X[I] == POS_X AND MUGWUMP_Y[I] == POS_Y THEN
      MUGWUMP_FOUND[I] = #TRUE
     ENDIF
    NEXT I
   ENDIF
  ENDIF
  
  CLS
  GCLS
  DRAW_CONSOLE
  DRAW_GRID POS_X, POS_Y
  MUGWUMPS_FOUND = 0
  FOR I = 0 TO COUNT_MUGWUMPS - 1
   IF MUGWUMP_FOUND[I] == #TRUE THEN
    INC MUGWUMPS_FOUND
   ENDIF
  NEXT I
  VSYNC FPS
  IF MUGWUMPS_FOUND >= COUNT_MUGWUMPS THEN
   GAME_OVER = #TRUE
  ENDIF
 WEND
 IF EXIT_GAME == #FALSE THEN
  EXIT_GAME = !PLAY_AGAIN()
 ENDIF
WEND
END
DEF DRAW_CONSOLE
 VAR CON_W = #SCREEN_W / #TEXT_SIZE
 VAR CON_H = #SCREEN_H / #TEXT_SIZE
 CONST #CHAR_SIZE = 8
 VAR I, DX, DY, DIST, MX, MY
 
 COLOR #C_WHITE
 LOCATE 1, 1
 PRINT #GAME_TITLE$
 
 IF GUESS_COUNT > 0 THEN
  FOR I = 0 TO COUNT_MUGWUMPS - 1 
   LOCATE 1, 3 + (I * 2)
   PRINT "#" + STR$(I + 1) + "  ";
   MX = (1 + LEN("#" + STR$(I + 1) + " ")) * #CHAR_SIZE
   MY = (3 + (I * 2)) * #CHAR_SIZE
   DRAW_MUGWUMP MX, MY, #CHAR_SIZE, MUGWUMP_COLOR[I], MUGWUMP_EYE_COLOR[I], MUGWUMP_PUPIL_COLOR[I], MUGWUMP_MOUTH_COLOR[I]
   IF MUGWUMP_FOUND[I] THEN
    PRINT " FOUND!"
   ELSE
    DX = MUGWUMP_X[I] - GUESS_X[GUESS_COUNT - 1]
    DY = MUGWUMP_Y[I] - GUESS_Y[GUESS_COUNT - 1]
    DIST = SQR(DX * DX + DY * DY)
    PRINT " is " + FORMAT$("%0.2F", DIST) + " units away"
   ENDIF
  NEXT I
  LOCATE 1, 5 + (2 * COUNT_MUGWUMPS)
 ELSE
  'SHOW HELP TEXT
  LOCATE 1, 3
  PRINT "Find all the Mugwumps to win!"
  LOCATE 1, 5
  PRINT "Select a square to scan for a Mugwump"
  LOCATE 1, 7
  PRINT "Use the D Pad  or Joystick  to move."
  LOCATE 1, 9
  PRINT "The B button  will select a square"
  LOCATE 1, 11
  PRINT "You can also use the touch screen."
  LOCATE 1, 13
  PRINT "Press the X button  to quit the game."
  LOCATE 1, 17
 ENDIF
 PRINT "You have " + STR$(MAX_GUESSES - GUESS_COUNT) + " guesses remaining."

END

DEF DRAW_GRID POS_X, POS_Y
 VAR I, J, TX, TY, X, Y
 
 GCOLOR #C_WHITE 
 FOR J = 0 TO GRID_H
  GLINE GRID_X, GRID_Y + (J * CELL_H), GRID_X + (GRID_W * CELL_W), GRID_Y + (J * CELL_H), #C_WHITE
 NEXT J
 
 TX = GRID_X - #TEXT_SIZE
 TY = GRID_Y + (GRID_H * CELL_H) - FLOOR((CELL_H - #TEXT_SIZE) / 2) - #TEXT_SIZE
 FOR J = 0 TO GRID_H - 1
  GPUTCHR TX, TY - (J * CELL_H), STR$(J), #TEXT_SIZE, #C_WHITE
 NEXT J
 
 FOR I = 0 TO GRID_W
  GLINE GRID_X + (I * CELL_W), GRID_Y, GRID_X + (I * CELL_W), GRID_Y + (GRID_H * CELL_H), #C_WHITE
 NEXT I
 
 TX = GRID_X + FLOOR((CELL_W - #TEXT_SIZE) / 2)
 TY = GRID_Y + (GRID_H * CELL_H) + FLOOR(#TEXT_SIZE / 2)
 FOR I = 0 TO GRID_W - 1
  GPUTCHR TX + (I * CELL_W), TY, STR$(I), #TEXT_SIZE, #C_WHITE
 NEXT J
 
 FOR I = 0 TO GUESS_COUNT - 1
  X = GRID_X + 1 + (CELL_W * GUESS_X[I])
  Y = GRID_Y + 1 + (CELL_H * GUESS_Y[I])
  GFILL X, Y, X + CELL_W - 2, Y + CELL_H - 2, #C_RED 
 NEXT I
 
 IF POS_X >= 0 AND POS_X < GRID_W AND POS_Y >= 0 AND POS_Y < GRID_H THEN
  X = GRID_X + 3 + (CELL_W * POS_X)
  Y = GRID_Y + 3 + (CELL_H * POS_Y)
  GFILL X, Y, X + CELL_W - 6, Y + CELL_H - 6, #C_TEAL 
 ENDIF
 
 FOR I = 0 TO COUNT_MUGWUMPS - 1
  IF MUGWUMP_FOUND[I] == #TRUE THEN
   DRAW_MUGWUMP GRID_X + (CELL_W * MUGWUMP_X[I]) + 1, GRID_Y + (CELL_H * MUGWUMP_Y[I]) + 1, CELL_W - 2, MUGWUMP_COLOR[I], MUGWUMP_EYE_COLOR[I], MUGWUMP_PUPIL_COLOR[I], MUGWUMP_MOUTH_COLOR[I]
  ENDIF
 NEXT I
END

DEF INIT_GRID
 CELL_W = (#SCREEN_W - (#BORDER_W * 2)) / GRID_W
 CELL_H = (#SCREEN_H - (#BORDER_H * 2)) / GRID_H
 CELL_W = MIN(CELL_W, CELL_H)
 CELL_H = CELL_W
 
 GRID_X = #SCREEN_W - (CELL_W * GRID_W) - #BORDER_W
 GRID_Y = FLOOR((#SCREEN_H - (CELL_H * GRID_H)) / 2)
 
 GUESS_COUNT = 0
END

DEF IS_GUESS_OK(X, Y)
 VAR I
 
 FOR I = 0 TO GUESS_COUNT - 1
  IF GUESS_X[I] == X AND GUESS_Y[I] == Y THEN
   RETURN #FALSE
  ENDIF
 NEXT I
 
 RETURN #TRUE
END

DEF PLAY_AGAIN()
 VAR B, I, MAX_WIDTH, MUGWUMPS_FOUND = 0
 VAR W, H, X, Y, VALUE_SELECTED, RET
 VAR CON_W = #SCREEN_W / #TEXT_SIZE
 VAR CON_H = #SCREEN_H / #TEXT_SIZE
 VAR MESSAGE$[4]
 
 FOR I = 0 TO COUNT_MUGWUMPS - 1
  IF MUGWUMP_FOUND[I] THEN
   INC MUGWUMPS_FOUND
  ENDIF
 NEXT I
 
 IF MUGWUMPS_FOUND == COUNT_MUGWUMPS THEN
  MESSAGE$[0] = "Congratulations! You Won!"
 ELSE
  MESSAGE$[0] = "Sorry, you lost."
 ENDIF
 
 MESSAGE$[1] = "Would you like to play again?"
 MESSAGE$[2] = " = No"
 MESSAGE$[3] = " = Yes"
 
 MAX_WIDTH = LEN(MESSAGE$[0])
 FOR I = 1 TO LEN(MESSAGE$) - 1
  IF LEN(MESSAGE$[I]) > MAX_WIDTH THEN
   MAX_WIDTH = LEN(MESSAGE$[I])
  ENDIF
 NEXT I
 
 W = MAX_WIDTH + 4
 H = LEN(MESSAGE$) + 4
 X = FLOOR((CON_W - W) / 2)
 Y = FLOOR((CON_H - H) / 2)
 
 DRAW_GRID POS_X, POS_Y
 
 GFILL X * #TEXT_SIZE, Y * #TEXT_SIZE, (X + W) * #TEXT_SIZE, (Y + H) * #TEXT_SIZE, DARK_GRAY
 GFILL #TEXT_SIZE + (X * #TEXT_SIZE), #TEXT_SIZE + (Y * #TEXT_SIZE), (X + W) * #TEXT_SIZE - #TEXT_SIZE, (Y + H) * #TEXT_SIZE - #TEXT_SIZE, LIGHT_GRAY
 
 INC X, 2
 INC Y, 2
 
 
 FOR I = 0 TO LEN(MESSAGE$) - 1
  LOCATE X, Y
  GPUTCHR X * #TEXT_SIZE, Y * #TEXT_SIZE, MESSAGE$[I], #TEXT_SIZE, #C_BLACK, #G_ALPHA
  INC Y
 NEXT I
 VALUE_SELECTED = #FALSE
 RET = #FALSE
 
 VSYNC FPS * 2 'WAIT A BIT FOR USER TO LET GO OF ANY BUTTONS
 
 WHILE !VALUE_SELECTED
  B = BUTTON(3) 'MOMENT RELEASED
  
  IF BUTTON(#CONTROLLER_ID, #B_RRIGHT, #BUTTON_PRESSED) THEN
   RET = #FALSE
   VALUE_SELECTED = #TRUE
  ELSEIF BUTTON(#CONTROLLER_ID, #B_RDOWN, #BUTTON_PRESSED) THEN
   RET = #TRUE
   VALUE_SELECTED = #TRUE
  ENDIF
  VSYNC
 WEND
 RETURN RET
END
'''

pygame.init()
screen = pygame.display.set_mode((SCREEN_W, SCREEN_H))
running = True

grid = Grid()

while running:
    event = pygame.event.poll()
    if event.type == pygame.QUIT:
        running = False
    #elif event.type == pygame.MOUSEBUTTONDOWN and event.button == LEFT:
    #    print("You pressed the left mouse button at (%d, %d)" % event.pos)
    #elif event.type == pygame.MOUSEBUTTONUP and event.button == LEFT:
    #    print("You released the left mouse button at (%d, %d)" % event.pos)

    screen.fill((0, 0, 0))
    grid.draw(screen)
    pygame.display.flip()

print('goodbye')