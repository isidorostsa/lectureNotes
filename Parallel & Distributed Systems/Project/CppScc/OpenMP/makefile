CC=g++
CFLAGS=-I. -Wall -O3 -g -fopenmp
DEPS = colorSCC.hpp
OBJ = colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC