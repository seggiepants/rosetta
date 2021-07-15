OBJS = main.o Console.o Grid.o Mugwump.o PlayAgain.o
CFLAGS = -O2
CC = g++
INCLUDES = 
LIBS = -lm -lpng -lX11 -lGL -lpthread -lstdc++fs -std=c++17

.cpp.o:
	$(CC) $(CFLAGS) -c $<

mugwump_2d: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LIBS)

clean:
	-rm -f *.o core *.core
