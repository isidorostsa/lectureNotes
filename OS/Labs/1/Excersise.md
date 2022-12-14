Only #3 will be covered.

Given the directory `Images`, containing a file hierarchy with `.png/.jpg` files, find all that are  $\ge$ 5MiB and move them to a directory `Large-Images`, adjecent to `Images`. (You need to create that dir, and also must use `find` and `xargs`).

1. Let's find the images matching `.jpg` or `.png`:
	- `find Images/ ( -iname '*.jpg' -o -iname '*.png')`
2. Now filter for size:
	- `find Images/ ( -iname '*.jpg' -o -iname '*.png') -size +5242879c`
	this number is the size of `5MiB` in characters $-1$ . The `+` is used to only keep those with greater size, and the `c` at the end means size in `char`. This will print the files in different lines. Adding `-print0` at the end makes `find` seperate results with `null character`.
4. Parse the args:
	- `find Images/ \( -iname '\*.jpg' -o -iname '\*.png' \) -size +5242879c -print0 | xargs -0`
	`-0` means the args will be delimited by a `null char`.
5. Pass them to the moving function in the correct order:
	- `find Images/ \( -iname '\*.jpg' -o -iname '\*.png' \) -size +5242879c -print0 | xargs -0 -I {} mv {} Large-Images/`
	`mv` needs the destination directory to be the last argument, so we specify which string `xargs` needs to replace by the list of args. `-I {}` means _replace {} with the args_. So `mv {} Large-Images` becomes `mv fi\le\1.jpg f\i\le\3.png (and all other files) Large-Images/`. 
6. Make the directory in the start, and we are done:
- `mkdir Large-Images; find Images/ \( -iname '\*.jpg' -o -iname '\*.png' \) -size +5242879c -print0 | xargs -0 -I {} mv {} Large-Images/`