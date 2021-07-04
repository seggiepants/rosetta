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
#include "Mugwump.h"

int main(void)
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    Mugwump mugwump;
    Mugwump_Init(&mugwump, true, 0, 0, LIME, WHITE, DARKBLUE, BLACK);

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");

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

            ClearBackground(RAYWHITE);

            DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
            Mugwump_Draw(&mugwump, 100, 100, 50);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}