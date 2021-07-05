// --------------------------------------------------------------------------------
// MUGWUMP 2D
// ----------
// A graphical version of MUGWUMP from BASIC COMPUTER GAMES
// by Bob Albrecht, Bud Valenti, Edited by David H.Ahl
// ported by SeggiePants
//
// Notes: 
// This uses the Raylib Game Engine. Please see licence under the 
// 3rd_party/raylib folder.
//
// --------------------------------------------------------------------------------
//
#include "raylib.h"
#include "Grid.h"

int main(void)
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");

    Font f = GetFontDefault();
    Grid grid;
    Grid_Init(&grid, "MUGWUMP_2D", 10, 10, 10, 12, 4, 4);
    Grid_NewGame(&grid, 4);

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(BLACK);

            //DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
            //Mugwump_Draw(&mugwump, 100, 100, 50);
            Grid_Draw(&grid);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}