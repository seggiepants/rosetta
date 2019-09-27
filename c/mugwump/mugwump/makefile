CC=gcc
CFLAGS=

ODIR=obj
LDIR=lib

LIBS=-lm
_OBJ=mugwump.o
OBJ=$(patsubst $,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(LIBS)

mugwump: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

clean:
	rm -f $(ODIR)/*.o *~ cor $(IDIR)/*~
