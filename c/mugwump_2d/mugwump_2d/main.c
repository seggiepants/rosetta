// --------------------------------------------------------------------------------
// MUGWUMP 2D
// ----------
// A graphical version of MUGWUMP from BASIC COMPUTER GAMES
// by Bob Albrecht, Bud Valenti, Edited by David H.Ahl
// ported by SeggiePants
//
// Notes: 
// This uses the Raylib Game Engine. Please see licences under the 
// 3rd_party/raylib and 3rd_party/raygui folders.
//
// --------------------------------------------------------------------------------
//
#include <stdlib.h>
#include <string.h>

#define RAYGUI_IMPLEMENTATION
#define RAYGUI_SUPPORT_ICONS
#include "raygui.h"
#include "raylib.h"
#undef RAYGUI_IMPLEMENTATION

#include "Settings.h"
#include "Grid.h"

int main(void)
{
    bool gameWon;
    int result;
    char buffer[BUFFER_MAX];
    Grid grid;

    InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, GAME_TITLE);
    SetExitKey(0); // Turn off ESC to automatically exit.

    Grid_Init(&grid, GAME_TITLE, GRID_W, GRID_H, MAX_GUESSES, FONT_SIZE, INSET_1, INSET_1);
    Grid_NewGame(&grid);

    SetTargetFPS(60);               // run at 60 frames-per-second

    // Main game loop
    bool exitWindow = false;
    bool showMessageBox = false;

    while (!exitWindow)    // Detect window close button or ESC key
    {
        // Update the world and read input
        exitWindow = WindowShouldClose();

        if (IsKeyPressed(KEY_ESCAPE)) 
        {
            exitWindow = true;
        }

        if (!Grid_isGameOver(&grid))
        {

            if (IsKeyPressed(KEY_DOWN) || IsKeyPressed(KEY_S))
            {
                Grid_MoveDown(&grid);
            }

            if (IsKeyPressed(KEY_LEFT) || IsKeyPressed(KEY_A))
            {
                Grid_MoveLeft(&grid);
            }

            if (IsKeyPressed(KEY_RIGHT) || IsKeyPressed(KEY_D))
            {
                Grid_MoveRight(&grid);
            }

            if (IsKeyPressed(KEY_UP) || IsKeyPressed(KEY_W))
            {
                Grid_MoveUp(&grid);
            }

            if (IsKeyPressed(KEY_SPACE) || IsKeyPressed(KEY_KP_EQUAL) || IsKeyPressed(KEY_ENTER))
            {
                Grid_Select(&grid);
            }

            if (IsMouseButtonReleased(0))
            {
                Grid_Click(&grid, GetMouseX(), GetMouseY());
            }
        }

        // Draw
        BeginDrawing();

            ClearBackground(BLACK);

            Grid_Draw(&grid);

            if (Grid_isGameOver(&grid))
            {    
                gameWon = Grid_isGameWon(&grid);
                if (gameWon)
                    strcpy(buffer, "Congratulations! You Won!");
                else
                    strcpy(buffer, "Sorry, you lost.");
                strcat(buffer, "\nWould you like to play again ?");

                DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(BLACK, 0.5f));
                result = GuiMessageBox((Rectangle) { GetScreenWidth() / 2 - 150, GetScreenHeight() / 2 - 60, 300, 120 }
                    , GuiIconText(RICON_INFO, gameWon ? "You Win" : "Game Over")
                    , buffer, "Yes;No");
                if ((result == 0) || (result == 2))
                {
                    exitWindow = true;
                }
                else if (result == 1)
                {
                    showMessageBox = false;
                    Grid_NewGame(&grid);
                }   
            }

        EndDrawing();
    }

    CloseWindow();        // Close window and OpenGL context
    
    return 0;
}