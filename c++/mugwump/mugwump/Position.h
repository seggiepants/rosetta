#pragma once
class Position
{
public:
	Position();
	~Position();
	int get_x();
	int get_y();
	bool get_found();
	void set_found(bool);
	void random_position(int, int);
private:
	int x;
	int y;
	bool found;
};

