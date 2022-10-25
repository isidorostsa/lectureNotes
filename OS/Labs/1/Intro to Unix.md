
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

Example:
`hellomake.c` depends on `hellomake.h` and uses `hellofunc.c`
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
	- `-o` put output of compilation in `$@`
	- We don't mention `DEPS` in the compilation step because it is already `#include`d.
	This telescopes to:
```Makefile
hellomake.o: hellomake.c hellomake.h
	gcc -c -o hellomake.o hellomake.c -I
	
hellofunc.o: hellofunc.c hellomake.h
	gcc -c -o hellofunc.o hellofunc.c -I
```
- `clean` this is called because no file with this name exists, and neither is ever created. 








