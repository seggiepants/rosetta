
'MUGWUMP 2D
'----------
'A graphical version of MUGWUMP from BASIC COMPUTER GAMES
'by Bob Albrecht, Bud Valenti, Edited by David H. Ahl
'ported by SeggiePants

OPTION STRICT

VAR GAME_TITLE$ = "MUGWUMP 2D"
VAR TEXT_SIZE = 8
VAR BORDER_W = TEXT_SIZE * 2
VAR BORDER_H = BORDER_W

VAR FPS = (60 / 20)
VAR COUNT_MUGWUMPS = 4
VAR MAX_GUESSES =10

VAR GRID_W = 10
VAR GRID_H = GRID_W
VAR CELL_W, CELL_H
VAR GRID_X, GRID_Y
VAR GUESS_COUNT
VAR GUESS_X[MAX_GUESSES]
VAR GUESS_Y[MAX_GUESSES]

'SCREEN SIZE
VAR SCREEN_W = 400
VAR SCREEN_H = 240
VAR TOUCH_W = 320
VAR TOUCH_H = 240

'COLORS
VAR DARK_GRAY = RGB(64, 64, 64)
VAR LIGHT_BLUE = RGB(128, 128, 255)
VAR LIGHT_GRAY = RGB(192, 192, 192)
VAR ORANGE = RGB(255, 128, 0)
VAR PINK = RGB(255, 0, 128)
VAR VIOLET = RGB(192, 0, 255)

'MUGWUMP DATA
VAR MUGWUMP_FOUND[COUNT_MUGWUMPS]
VAR MUGWUMP_X[COUNT_MUGWUMPS]
VAR MUGWUMP_Y[COUNT_MUGWUMPS]
VAR MUGWUMP_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_EYE_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_PUPIL_COLOR[COUNT_MUGWUMPS]
VAR MUGWUMP_MOUTH_COLOR[COUNT_MUGWUMPS]

VAR EXIT_GAME = FALSE
VAR GAME_OVER, MUGWUMPS_FOUND
VAR B, TX, TY, TSTATUS, SX#, SY#
VAR I, POS_X, POS_Y
VAR T_VP = 2, T_WP = 3

ACLS
XSCREEN 3 '2D TOP PLUS TOUCHSCREEN

EXIT_GAME = FALSE
INIT_GRID

WHILE EXIT_GAME == FALSE
 INIT_MUGWUMPS
 GUESS_COUNT = 0
 POS_X = FLOOR((GRID_W - 1) / 2)
 POS_Y = FLOOR((GRID_H - 1) / 2)
 GAME_OVER = FALSE
 EXIT_GAME = FALSE
 
 WHILE GAME_OVER == FALSE
  B = BUTTON()
  TOUCH OUT TSTATUS, TX, TY
  STICK OUT SX#, SY#
  
  'NEED TO INVERT SY#
  IF (B AND #UP) != 0 OR SY# > 0.5 THEN
   POS_Y = MAX(0, POS_Y - 1)
  ENDIF
  
  IF (B AND #DOWN) != 0 OR SY# < -0.5 THEN
   POS_Y = MIN(GRID_H - 1, POS_Y + 1)
  ENDIF
  
  IF (B AND #LEFT) != 0 OR SX# < -0.5 THEN
   POS_X = MAX(0, POS_X - 1)
  ENDIF
  
  IF (B AND #RIGHT) != 0 OR SX# > 0.5 THEN
   POS_X = MIN(GRID_W - 1, POS_X + 1)
  ENDIF
  
  'TOUCHED?
  IF TSTATUS != 0 THEN
   'WITHIN THE GRID? 
   IF TX >= GRID_X AND TX <= GRID_X + (GRID_W * CELL_W) AND TY >= GRID_Y AND TY <= GRID_Y + (GRID_H * CELL_H) THEN
    'WARP THERE
    POS_X = FLOOR((TX - GRID_X) / CELL_W)
    POS_Y = FLOOR((TY - GRID_Y) / CELL_H)
    
    'SET THE ACTION BUTTON
    B = (B OR #B)
   ENDIF
  ENDIF
  
  IF (B AND #X) != 0 OR GUESS_COUNT >= MAX_GUESSES THEN
   GAME_OVER = TRUE
   IF (B AND #X) != 0 THEN
    EXIT_GAME = TRUE
   ENDIF
  ELSEIF (B AND #B) != 0 THEN
   IF IS_GUESS_OK(POS_X, POS_Y) THEN
    GUESS_X[GUESS_COUNT] = POS_X
    GUESS_Y[GUESS_COUNT] = POS_Y
    INC GUESS_COUNT
    FOR I = 0 TO COUNT_MUGWUMPS - 1
     'MARK ANY MUGWUMP FOUND IF POSSIBLE
     IF MUGWUMP_X[I] == POS_X AND MUGWUMP_Y[I] == POS_Y THEN
      MUGWUMP_FOUND[I] = TRUE
     ENDIF
    NEXT I
   ENDIF
  ENDIF
  
  DRAW_CONSOLE
  DRAW_GRID POS_X, POS_Y
  MUGWUMPS_FOUND = 0
  FOR I = 0 TO COUNT_MUGWUMPS - 1
   IF MUGWUMP_FOUND[I] == TRUE THEN
    INC MUGWUMPS_FOUND
   ENDIF
  NEXT I
  VSYNC FPS
  IF MUGWUMPS_FOUND >= COUNT_MUGWUMPS THEN
   GAME_OVER = TRUE
  ENDIF
 WEND
 IF EXIT_GAME == FALSE THEN
  EXIT_GAME = !PLAY_AGAIN()
 ENDIF
WEND

END

DEF DRAW_CONSOLE
 VAR CON_W = SCREEN_W / TEXT_SIZE
 VAR CON_H = SCREEN_H / TEXT_SIZE
 VAR I, DX, DY, DIST, MX, MY
 
 DISPLAY 0 'TOP SCREEN
 CLS
 GCLS
 LOCATE FLOOR((CON_W - LEN(GAME_TITLE$)) / 2), 1
 PRINT GAME_TITLE$
 
 IF GUESS_COUNT > 0 THEN
  FOR I = 0 TO COUNT_MUGWUMPS - 1 
   LOCATE 3, 3 + (I * 2)
   PRINT "#" + STR$(I + 1) + "  ";
   MX = (3 + LEN("#" + STR$(I + 1) + " ")) * TEXT_SIZE
   MY = (3 + (I * 2)) * TEXT_SIZE
   DRAW_MUGWUMP MX, MY, TEXT_SIZE, MUGWUMP_COLOR[I], MUGWUMP_EYE_COLOR[I], MUGWUMP_PUPIL_COLOR[I], MUGWUMP_MOUTH_COLOR[I]
   IF MUGWUMP_FOUND[I] THEN
    PRINT " FOUND!"
   ELSE
    DX = MUGWUMP_X[I] - GUESS_X[GUESS_COUNT - 1]
    DY = MUGWUMP_Y[I] - GUESS_Y[GUESS_COUNT - 1]
    DIST = SQR(DX * DX + DY * DY)
    PRINT " is " + FORMAT$("%0.2F", DIST) + " units away"
   ENDIF
  NEXT I
  LOCATE 3, 5 + (2 * COUNT_MUGWUMPS)
 ELSE
  'SHOW HELP TEXT
  LOCATE 3, 3
  PRINT "Find all the Mugwumps to win!"
  LOCATE 3, 5
  PRINT "Select a square to scan for a Mugwump"
  LOCATE 3, 7
  PRINT "Use the D Pad  or Joystick  to move."
  LOCATE 3, 9
  PRINT "The B button  will select a square"
  LOCATE 3, 11
  PRINT "You can also use the touch screen to select."
  LOCATE 3, 13
  PRINT "Press the X button  to quit the game."
  LOCATE 3, 17
 ENDIF
 PRINT "You have " + STR$(MAX_GUESSES - GUESS_COUNT) + " guesses remaining."
END

DEF DRAW_GRID POS_X, POS_Y
 VAR I, J, TX, TY, X, Y
 
 DISPLAY 1 'TOUCH SCREEN
 
 GPAGE T_VP, T_WP
 SWAP T_VP, T_WP
 
 CLS
 GFILL 0, 0, TOUCH_W, TOUCH_H, #BLACK
 FOR J = 0 TO GRID_H
  GLINE GRID_X, GRID_Y + (J * CELL_H), GRID_X + (GRID_W * CELL_W), GRID_Y + (J * CELL_H), #WHITE
 NEXT J
 
 TX = GRID_X - TEXT_SIZE
 TY = GRID_Y + (GRID_H * CELL_H) - FLOOR((CELL_H - TEXT_SIZE) / 2) - TEXT_SIZE
 FOR J = 0 TO GRID_H - 1
  GPUTCHR TX, TY - (J * CELL_H), STR$(J), #WHITE
 NEXT J
 
 FOR I = 0 TO GRID_W
  GLINE GRID_X + (I * CELL_W), GRID_Y, GRID_X + (I * CELL_W), GRID_Y + (GRID_H * CELL_H), #WHITE
 NEXT I
 
 TX = GRID_X + FLOOR((CELL_W - TEXT_SIZE) / 2)
 TY = GRID_Y + (GRID_H * CELL_H) + FLOOR(TEXT_SIZE / 2)
 FOR I = 0 TO GRID_W - 1
  GPUTCHR TX + (I * CELL_W), TY, STR$(I), #WHITE
 NEXT J
 
 FOR I = 0 TO GUESS_COUNT - 1
  X = GRID_X + 1 + (CELL_W * GUESS_X[I])
  Y = GRID_Y + 1 + (CELL_H * GUESS_Y[I])
  GFILL X, Y, X + CELL_W - 2, Y + CELL_H - 2, #RED 
 NEXT I
 
 IF POS_X >= 0 AND POS_X < GRID_W AND POS_Y >= 0 AND POS_Y < GRID_H THEN
  X = GRID_X + 3 + (CELL_W * POS_X)
  Y = GRID_Y + 3 + (CELL_H * POS_Y)
  GFILL X, Y, X + CELL_W - 6, Y + CELL_H - 6, #TEAL 
 ENDIF
 
 FOR I = 0 TO COUNT_MUGWUMPS - 1
  IF MUGWUMP_FOUND[I] == TRUE THEN
   DRAW_MUGWUMP GRID_X + (CELL_W * MUGWUMP_X[I]) + 1, GRID_Y + (CELL_H * MUGWUMP_Y[I]) + 1, CELL_W - 2, MUGWUMP_COLOR[I], MUGWUMP_EYE_COLOR[I], MUGWUMP_PUPIL_COLOR[I], MUGWUMP_MOUTH_COLOR[I]
  ENDIF
 NEXT I
 
 DISPLAY 0 'TOP SCREEN, WANT TO ALWAYS START
           'IN A KNOWN STATE 
END

DEF DRAW_MUGWUMP X, Y, SIZE, BODY_COLOR, EYE_COLOR, PUPIL_COLOR, MOUTH_COLOR
 VAR CENTER_X = X + FLOOR(SIZE / 2)
 VAR CENTER_Y = Y + FLOOR(SIZE / 2)
 
 VAR EYE_DX = FLOOR(SIZE / 4)
 VAR EYE_DY = FLOOR(SIZE / 4)
 
 FILLED_CIRCLE CENTER_X, CENTER_Y, FLOOR(SIZE / 2), BODY_COLOR
 FILLED_CIRCLE CENTER_X - EYE_DX, CENTER_Y - EYE_DY, FLOOR(SIZE / 5), EYE_COLOR
 FILLED_CIRCLE CENTER_X + EYE_DX, CENTER_Y - EYE_DY, FLOOR(SIZE / 5), EYE_COLOR
 FILLED_CIRCLE CENTER_X - EYE_DX, CENTER_Y - EYE_DY, FLOOR(SIZE / 10), PUPIL_COLOR
 FILLED_CIRCLE CENTER_X + EYE_DX, CENTER_Y - EYE_DY, FLOOR(SIZE / 10), PUPIL_COLOR
 FILLED_CIRCLE CENTER_X, CENTER_Y + FLOOR(EYE_DY / 2), FLOOR(SIZE / 6), MOUTH_COLOR
END

DEF FILLED_CIRCLE X, Y, RADIUS, FILL_COLOR
 VAR NUM_TRI = MAX(32, MIN(360, RADIUS))
 VAR ANG_STEP# = (2.0 * PI()) / NUM_TRI
 VAR I, ANG# = 0.0, X1, Y1, X2, Y2
 
 FOR I = 0 TO NUM_TRI - 1
  X1 = X + COS(ANG#) * RADIUS
  Y1 = Y + SIN(ANG#) * RADIUS
  
  ANG# = ANG# + ANG_STEP#
  
  X2 = X + COS(ANG#) * RADIUS
  Y2 = Y + SIN(ANG#) * RADIUS
  
  GTRI X, Y, X1, Y1, X2, Y2, FILL_COLOR 
 NEXT I
END

DEF INIT_GRID
 CELL_W = (TOUCH_W - (BORDER_W * 2)) / GRID_W
 CELL_H = (TOUCH_H - (BORDER_H * 2)) / GRID_H
 CELL_W = MIN(CELL_W, CELL_H)
 CELL_H = CELL_W
 
 GRID_X = FLOOR((TOUCH_W - (CELL_W * GRID_W)) / 2)
 GRID_Y = FLOOR((TOUCH_H - (CELL_H * GRID_H)) / 2)
 
 GUESS_COUNT = 0
END

DEF INIT_MUGWUMPS
 VAR I, J, POSITION_OK, X, Y
 FOR I = 0 TO COUNT_MUGWUMPS - 1
  MUGWUMP_FOUND[I] = FALSE
  REPEAT
   X = RND(GRID_W)
   Y = RND(GRID_H)
   POSITION_OK = TRUE
   FOR J = 0 TO I - 1
    IF X == MUGWUMP_X[J] AND Y == MUGWUMP_Y[J] THEN
     POSITION_OK = FALSE
     BREAK
    ENDIF
   NEXT J
  UNTIL POSITION_OK == TRUE
  MUGWUMP_X[I] = X
  MUGWUMP_Y[I] = Y
  IF I MOD 4 == 0 THEN
   MUGWUMP_COLOR[I] = PINK
  ELSEIF I MOD 4 == 1 THEN
   MUGWUMP_COLOR[I] = VIOLET
  ELSEIF I MOD 4 == 2 THEN
   MUGWUMP_COLOR[I] = LIGHT_BLUE
  ELSE
   MUGWUMP_COLOR[I] = ORANGE
  ENDIF
  MUGWUMP_EYE_COLOR[I] = #WHITE
  MUGWUMP_PUPIL_COLOR[I] = #BLACK
  MUGWUMP_MOUTH_COLOR[I] = #BLACK
 NEXT I
END

DEF IS_GUESS_OK(X, Y)
 VAR I
 
 FOR I = 0 TO GUESS_COUNT - 1
  IF GUESS_X[I] == X AND GUESS_Y[I] == Y THEN
   RETURN FALSE
  ENDIF
 NEXT I
 
 RETURN TRUE
END

DEF PLAY_AGAIN()
 VAR B, I, MAX_WIDTH, MUGWUMPS_FOUND = 0
 VAR W, H, X, Y, VALUE_SELECTED, RET
 VAR CON_W = TOUCH_W / TEXT_SIZE
 VAR CON_H = TOUCH_H / TEXT_SIZE
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
 DISPLAY 1
 GPAGE T_VP, T_WP
 SWAP T_VP, T_WP
 
 GFILL X * TEXT_SIZE, Y * TEXT_SIZE, (X + W) * TEXT_SIZE, (Y + H) * TEXT_SIZE, DARK_GRAY
 GFILL TEXT_SIZE + X * TEXT_SIZE, TEXT_SIZE + Y * TEXT_SIZE, (X + W) * TEXT_SIZE - TEXT_SIZE, (Y + H) * TEXT_SIZE - TEXT_SIZE, LIGHT_GRAY
 
 INC X, 2
 INC Y, 2
 
 COLOR #TBLACK, 0 '0 = TRANSPARENT
 FOR I = 0 TO LEN(MESSAGE$) - 1
  LOCATE X, Y
  PRINT MESSAGE$[I]
  INC Y
 NEXT I
 GPAGE T_VP, T_WP
 SWAP T_VP, T_WP
 
 DISPLAY 0
 VALUE_SELECTED = FALSE
 RET = FALSE
 
 VSYNC FPS * 2 'WAIT A BIT FOR USER TO LET GO OF ANY BUTTONS
 
 WHILE !VALUE_SELECTED
  B = BUTTON(3) 'MOMENT RELEASED
  
  IF (B AND #A) != 0 THEN
   RET = FALSE
   VALUE_SELECTED = TRUE
  ELSEIF (B AND #B) != 0 THEN
   RET = TRUE
   VALUE_SELECTED = TRUE
  ENDIF
  VSYNC
 WEND
 RETURN RET
END