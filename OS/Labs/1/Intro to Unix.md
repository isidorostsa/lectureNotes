## Sample known commands
- ls
- cd 
- pwd
- more (like cat but page by page)
- mkdir
- touch (touch -t 12312359 oldfile) -> new date is 31/12, 23:59
- cp
- grep (input lines and regex to return lines matching)
- rmdir
- find startDict -name target_filename -print (look through lower dirs, return to print )
- ps (list processes -e for all)

## Redirecting outputs
Operator: >
Write to file
- cat file1 > file2 (write contents of file1 to file2)

Operator: >>
Append to file

Operator: |
Give the output of command 1 to programs expecting input
- ps -e | grep msav

Operator: xargs
Turn output to text and input it as a command line argument 
- ls | xargs echo

## Makefiles
[A Simple Makefile Tutorial](https://cs.colby.edu/maxwell/courses/tutorials/maketutor/)
[GNU make](https://www.gnu.org/software/make/manual/make.html#Simple-Makefile)

### Example 1:
`hellomake.c` depends on `hellomake.h` and uses `hellofunc.c`

The `Default Target` of make will be the first thing it reads, as a result of a recipe, that doesn't have a `.`. Here It is hellomake.

Make will try to compose the `Default Target` by composing every one of it's dependencies, working recursively to compose each of their dependencies, until it reaches stuff that only depends on `.c` or `.h` files.  

```Makefile
CC=gcc
CFLAGS=-I.
DEPS = hellomake.h

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

hellomake: hellomake.o hellofunc.o 
	$(CC) -o hellomake hellomake.o hellofunc.o

clean:
	rm hellomake.o hellofunc.o
```

- `%.o`: Do this for all files ending in .o
- `%.o: %.c $(DEPS)`: thing.o depends on thing.c and all things in DEPS.
- `$(CC) -c -o $@ $< $(CFLAGS)`:
	- `-c` create only object file
	- `-o` put output of compilation and link all stuff made into `$@`
	- We don't mention `DEPS` in the compilation step because it is already `#include`d.
	This telescopes to:
```Makefile
hellomake.o: hellomake.c hellomake.h
	gcc -c -o hellomake.o hellomake.c -I
	
hellofunc.o: hellofunc.c hellomake.h
	gcc -c -o hellofunc.o hellofunc.c -I
```
- `clean` this is called because no file with this name exists, and neither is ever created.

### Example 2:
Project `episode_rename`:
- `episode_rename.c`
```c
#include "utilities.h"

void main(int argc, char* argv[]){

    if (argc != 2) {
        fprintf(stderr, "Wrong input amount, fatal.");
        exit(EXIT_FAILURE);
    }

    char* filename = argv[1];
    fprintf(stdout, "\"%s\"", filename);
    fprintf(stdout, " ");

    char *new_filename = updateFilename(filename);
    fprintf(stdout, "%s\n", new_filename);
    free(new_filename);

    return;
}
```
- `utilities.h`
```c
#ifndef UTILITIES_H
#define UTILITIES_H

#include <stdio.h>
#include <stdlib.h>

char* updateFilename(char* filename);

#endif
```
- `utilities.c`
```c
include "utilities.h"

char *updateFilename(char* filename) {
    
    char temp1[20], temp2[20];
    int season, episode;

    char* result = (char*)malloc(7*sizeof(char));
    sscanf(filename, "%s %d %s %d", temp1, &season, temp2, &episode);
    sprintf(result, "S%02d_E%02d", season, episode);

    return result;
}
```

1. The compilation command would normaly be:
	- `gcc episode_rename.c utilities.c -o episode_rename`  (`-o` links the object files of the two things into one)
	- This translates to the Makefile:
```Makefile
episode_rename: episode_rename.c utilities.c
	gcc -o $@ $^
#-o to link, $@ is file before ':', $^ is everything after ':'
```

This solves the problem of portability, but everything is compiled everytime.
2. We want to specify a seperate way for each `.c` file to be compiled into an object file.
```Makefile
episode_rename: episode_rename.o utilities.o
	gcc $^ -o $@

%.o: %.c
	gcc -c $@ $<
#instructions to build .o files. It already knows so this is not needed.
```
This will check if `episode_rename.o` is more recent than it's source file, and will only compile it then.

*BUT* both `.c` files also "depend" on `utilities.h` so we should check if that has been updated too:
```Makefile
%.o: %.c -----> %.o: %.c utilities.h  
```

3. Let's use parameters for scalability:
```Makefile
CC=gcc
CFLAGS=-I.
DEPS = utilities.h
OBJ = episode_rename.o utilities.o

%.o: %.c $(DEPS)
	$(CC) -c $@ $< $(CFLAGS)
	
episode_rename: $(OBJ)
	$(CC) $^ -o $@ $(CFLAGS)
```

But now we have the `.o` files leftover.

4. Simply add 
```Makefile
.PHONY: clean
clean:
	rm -f episode_rename *.o *~
```
- Now by running `make clean` we delete all files we created, leaving behind a clean directory, with only source code.

If instead we want to have only the source files and the resulting program `episode_rename` leftover after running `make` we can declare all `.o` files as `intermediate` by adding:
```Makefile
.INTERMEDIATE: $(OBJ)
```
so _make_ runs `rm $(OBJ)` after composing the `Default Target`. 