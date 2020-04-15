import random, sys, time, math, pygame, pygame.locals
#from pygame.locals import *

# MUGWUMP 2D
# ----------
# A graphical version of MUGWUMP from BASIC COMPUTER GAMES
# by Bob Albrecht, Bud Valenti, Edited by David H. Ahl
# ported by SeggiePants

FPS = 30 # Frames per second

GAME_TITLE = 'MUGWUMP 2D'
TEXT_SIZE = 18
BORDER_W = TEXT_SIZE
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
                print('{x}, {y}'.format(x=x, y=y))
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

class Grid:
    def __init__(self, gameTitle = GAME_TITLE, width = GRID_W, height = GRID_H, maxGuesses = MAX_GUESSES, textSize = TEXT_SIZE, screenWidth = SCREEN_W, screenHeight = SCREEN_H, borderWidth = BORDER_W, borderHeight = BORDER_H):
        self.width = width
        self.height = height
        self.textSize = textSize
        self.console = Console(gameTitle, self.textSize, borderWidth, borderHeight)
        self.maxGuesses = maxGuesses
        self.mugwumps = []
        font = pygame.font.Font(pygame.font.match_font('sans'), textSize)

        # Save the digits on the side of the grid to pre-rendered surfaces.
        self.digits = []
        for i in range(max(self.width, self.height)):
            self.digits.append(font.render(str(i), False, WHITE, None))

        self.cellW = (screenWidth - (borderWidth * 2)) / self.width
        self.cellH = (screenHeight - (borderHeight * 3) - self.textSize) / self.height
        self.cellW = min(self.cellW, self.cellH)
        self.cellH = self.cellW

        self.x = screenWidth - (self.cellW * self.width) - borderWidth
        self.y = math.floor((screenHeight - (self.cellH * self.height)) / 2)

        self.guesses = []
        self.pos = {'x': 0, 'y': 0}
    
    def click(self, x, y):
        gridX = x - self.x
        gridY = y - self.y
        isGridLine = ((gridX % self.cellW == 0) or (gridY % self.cellH == 0))
        if (gridX > 0 and gridX < self.cellW * self.width and gridY > 0 and gridY < self.cellH * self.height and isGridLine == False):
            px = math.floor(gridX / self.cellW)
            py = math.floor(gridY / self.cellH)
            self.pos = {'x': px, 'y': py}
            self.select()

    def isGuessOK(self, x, y):
        # Guess is not ok if we already have one at the same position.
        # filter will go through the array and find matches
        # lambda does an inline function that returns true if the current guess is at the same position.
        # turn it into a list and return the length.
        # if that is greater than zero we already have that one and should return false, otherwise it is ok.
        return  len(list(filter(lambda guess: guess['x'] == x and guess['y'] == y, self.guesses))) == 0

    def moveLeft(self):
        self.pos['x'] = max(0, self.pos['x'] - 1)

    def moveRight(self):
        self.pos['x'] = min(self.width - 1, self.pos['x'] + 1)
    
    def moveUp(self):
        self.pos['y'] = max(0, self.pos['y'] - 1)

    def moveDown(self):
        self.pos['y'] = min(self.height - 1, self.pos['y'] + 1)
    
    def newGame(self, numMugwumps = COUNT_MUGWUMPS):
        self.guesses = []
        self.mugwumps = []
        for i in range(numMugwumps):
            positionOK = False
            x = 0
            y = 0
            while not positionOK:
                x = random.randrange(0, self.width)
                y = random.randrange(0, self.height)
                positionOK = len(list(filter(lambda mugwump: mugwump.x == x and mugwump.y == y, self.mugwumps))) == 0
            color = bodyColors[i % len(bodyColors)]
            self.mugwumps.append(Mugwump(False, x, y, color, WHITE, BLACK, BLACK))
            print('Mugwump {i} is at {x}, {y}'.format(i=i, x=x, y=y))

    def select(self):
        x = self.pos['x']
        y = self.pos['y']

        if self.isGuessOK(x, y):
            self.guesses.append({'x': x, 'y': y})
            for mugwump in filter(lambda mugwump: mugwump.x == x and mugwump.y == y, self.mugwumps):
                mugwump.found = True

    def draw(self, surf):
        self.console.draw(surf, self.guesses, self.maxGuesses, self.mugwumps)
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
                mugwump.draw(surf, self.x + (self.cellW * mugwump.x) + 1, self.y + (self.cellH * mugwump.y) + 1, self.cellW - 2)

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
        centerX = int(x + math.floor(size / 2))
        centerY = int(y + math.floor(size / 2))
        
        eyeDx = math.floor(size /4)
        eyeDy = math.floor(size / 4)

        pygame.draw.circle(surf, self.color, (centerX, centerY), int(size / 2), 0)
        pygame.draw.circle(surf, self.eyeColor, (centerX - eyeDx, centerY - eyeDy), int(size / 5), 0)
        pygame.draw.circle(surf, self.eyeColor, (centerX + eyeDx, centerY - eyeDy), int(size / 5), 0)
        pygame.draw.circle(surf, self.pupilColor, (centerX - eyeDx, centerY - eyeDy), int(size / 10), 0)
        pygame.draw.circle(surf, self.pupilColor, (centerX + eyeDx, centerY - eyeDy), int(size / 10), 0)


'''        
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
grid.newGame()
pygame.key.set_repeat(250, 100)
while running:
    event = pygame.event.poll()
    if event.type == pygame.locals.QUIT or (event.type == pygame.locals.KEYDOWN and event.key == pygame.locals.K_ESCAPE):
        running = False
    elif event.type == pygame.locals.KEYDOWN:
        if event.key == pygame.locals.K_LEFT or event.key == pygame.locals.K_a:
            grid.moveLeft()
        elif event.key == pygame.locals.K_RIGHT or event.key == pygame.locals.K_d:
            grid.moveRight()
        elif event.key == pygame.locals.K_UP or event.key == pygame.locals.K_w:
            grid.moveUp()
        elif event.key == pygame.locals.K_DOWN or event.key == pygame.locals.K_s:
            grid.moveDown()
        elif event.key == pygame.locals.K_SPACE or event.key == pygame.locals.K_RETURN or event.key == pygame.locals.K_KP_ENTER:
            grid.select()
    elif event.type == pygame.locals.MOUSEBUTTONUP and event.button == 1: # 1 = Left mouse button
            grid.click(event.pos[0], event.pos[1])
    
    screen.fill((0, 0, 0))
    grid.draw(screen)
    pygame.display.flip()

print('goodbye')