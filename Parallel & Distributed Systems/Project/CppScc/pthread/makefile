CC=g++

CFLAGS=-I. -pthread -Wall -Ofast -g -std=c++20 -g -gdwarf-3 
LFLAGS=-pthread -std=c++20 -g -gdwarf-3

DEPS = colorSCC.hpp sparse_util.hpp
OBJ = colorSCC.o sparse_util.o main.o

%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

colorSCC: $(OBJ)
	$(CC) -o $@ $^ $(LFLAGS)

.PHONY: clean
clean:
	rm -f *.o colorSCC