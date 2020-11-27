# Lab: processes

For today's lab, feel free to use the definitions from the
[csapp.h](csapp.h)/[csapp.c](csapp.c) utility library.  It contains
wrappers around system functions (such as `fork()`) that do their own
error checking with proper error message.  These wrappers are with a
leading capital (e.g. `Fork()`).  If you do use the `csapp` library,
remember to link it with your own code, as you did for `io.c` last
week!

This directory also contains a program [`forks.c`](forks.c) (buildable
via the [`Makefile`](Makefile)) that contains some of the code shown
in the videos, and demonstrates process control.

## Problems from CSAPP

* 8.6 (page 788)
* 8.22 (page 829)

## Memory problems

Write a program that allocates 2GiB of memory with `malloc()`, then
goes into an infinite loop so the process will stick around until you
kill it.  Use a process manager (such as `top` or `htop`) to check how
much memory your process is using. How much is it?

Now change the infinite loop to continuously fill the 2GiB of memory
you allocated with zeroes (or any other value).  How much memory is
your process using now, according to the process manager?
