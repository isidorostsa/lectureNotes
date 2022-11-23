CC=g++
CFLAGS=-I. -Wall
DEPS = colorSCC.hpp
OBJ = colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) $^ -o $@ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC