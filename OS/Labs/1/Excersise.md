Only #3 will be covered.

Given the directory `Images`, containing a file hierarchy with `.png/.jpg` files, find all that are  $\ge$ 5MiB and move them to a directory `Large-Images`, adjecent to `Images`. (You need to create that dir, and also must use `find` and `xargs`).

1. Let's find the images depending on their name first


mkdir Large-Images; find Images/ \( -iname '\*.jpg' -o -iname '\*.png' \) -size +5242879c -print0 | xargs -0 -I {} mv {} Large-Images/