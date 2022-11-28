CC=g++
CFLAGS=-I. -Wall -O3
DEPS = colorSCC.hpp sparse_utillities.hpp
OBJ = sparse_utillities.o colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC