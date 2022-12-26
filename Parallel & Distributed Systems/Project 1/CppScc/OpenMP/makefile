CC=g++

CFLAGS=-fopenmp -Wall -O3 -g -std=c++20 -g -gdwarf-3 
LFLAGS=-fopenmp -g -gdwarf-3 -fopenmp

DEPS = colorSCC.hpp sparse_util.hpp
OBJ = colorSCC.o sparse_util.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(LFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC