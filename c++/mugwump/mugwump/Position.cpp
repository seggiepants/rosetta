#include <cstdlib>
#include "Position.h"

// Constructor.
Position::Position()
{
	// Set member variables to sane defaults.
	x = 0;
	y = 0;
	found = false;
}

// Destructor
Position::~Position()
{
}

// x-coordinate getter
int Position::get_x()
{
	return x;
}

// y-coordinate getter.
int Position::get_y()
{
	return y;
}

// found flag getter
bool Position::get_found()
{
	return found;
}

/* 
found flag setter
Parameters:
* value - New value for found.
*/
void Position::set_found(bool value)
{
	found = value;
}

/*
Set the position to a random location on the map.
Parameters:
* maxX - Maximum location on the x-coordinate goes from 0 to maxX - 1
* maxY - Maximum location on the y-coordinate goes from 0 to maxXY- 1
*/
void Position::random_position(int maxX, int maxY) 
{
	x = rand() % maxX;
	y = rand() % maxY;
	found = false;
}
