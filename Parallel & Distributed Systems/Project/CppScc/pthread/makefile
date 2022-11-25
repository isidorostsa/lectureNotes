CC=g++
CFLAGS=-I. -Wall -O3 -g -fopenmp -std=c++20 -g -gdwarf-3
DEPS = colorSCC.hpp
OBJ = colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC