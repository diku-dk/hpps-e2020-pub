# Lab: processes

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
