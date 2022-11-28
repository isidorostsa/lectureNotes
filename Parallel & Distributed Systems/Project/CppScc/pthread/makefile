CC=g++

CFLAGS=-I. -Wall -Ofast -g -std=c++20 -g -gdwarf-3 
LFALGS=-pthread -std=c++20 -g -gdwarf-3

DEPS = colorSCC.hpp
OBJ = colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(LFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC