#pragma once

// Global Constants
#define NUM_MUGWUMPS 4
#define GRID_W 10
#define GRID_H GRID_W

#define BUFFER_SIZE 256
#define CONSOLE_W 80

#define MAX(a,b) (a > b ? a : b)

typedef int bool;
#define TRUE 1
#define FALSE 0

typedef struct position {
	int x;
	int y;
	bool found;
} position;

// Forward function declarations.
void CenterPrint(char*);
void PrettyPrint(char*);
void PrintIntroduction();
void InitMugwumps(struct position*);

