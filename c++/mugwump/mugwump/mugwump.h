#pragma once
#include <string>
#include "Position.h"

void center_print(std::string message);

void get_console_size(int&, int&);
unsigned int pretty_print(unsigned int, const std::string&);
void init_mugwumps(std::vector<Position*>& mugwumps, int, int);
void print_introduction();
std::vector<std::string> split(const std::string&, const std::string&);
void trim(std::string&, const std::string&);
void upper_case(std::string&);