CC=/opt/opencilk/bin/clang++
CFLAGS=-I. -Wall -O3 -fopencilk
DEPS = colorSCC.hpp
OBJ = colorSCC.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC