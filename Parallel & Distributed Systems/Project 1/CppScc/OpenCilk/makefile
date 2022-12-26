CC=/opt/opencilk/bin/clang++
CFLAGS=-I. -Wall -O3 -g -fopencilk -std=c++20
DEPS=colorSCC.hpp sparse_util.hpp
OBJ=colorSCC.o sparse_util.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC