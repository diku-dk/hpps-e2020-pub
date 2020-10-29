# Lab: dynamic memory and data formats

This lab is intended to familiarise you with the programming
techniques and tools you will need to implement the second weekly
assignment.

Even if you do not finish the lab tasks during the lab hours, it may
still be productive to finish the tasks before starting work on the
assignment, as everything here is directly relevant.

* The [`src`](src/) directory contains the code handout.

* The [`ref`](ref/) directory contains our solutions.  It's best to
  look at them only when you have tried yourself first, or are stuck.
  When you do look at them, make sure you understand why they work
  before moving on.

You should consider writing and extending a `Makefile` during your
work, as you will be creating several different files for htis lab.
The code handout contains the start of one that you can extend as
needed.

## Reading data files

In this task you will be implementing functions for converting on-disk
data to in-memory data.

### Data formats

We will be working with two kinds of data files.

* *Points files* represent sequences of *d*-dimensional points (note
  that we can view a collection of *n* *d*-dimensional points as an
  *n✕d* matrix).  These files are binary and have the following format:

  1. First, a 32-bit integer representing the number of *rows* (that is, *n*).

  2. Second, 32-bit integer representing the number of *columns* (that is, *d*).

  3. Then *n✕d* `double` values, each 8 bytes in size.

  Example files for testing: [`20_5.points`](20_5.points),
  [`10_2.points`](10_2.points).

  The file `20_5.points` contains a properly formatted data file that
  you can use for testing.

* *Index files* are much like points files, but instead of containing
  `double` values, they contain 4-byte `int` values, which are
  supposed to be valid 0-based indexes into the points of some other
  points file (but this is not checked by the file format itself).

  Example files for testing: [`10_3.indexes`](10_3.indexes),
  [`5_5.indexes`](5_5.indexes).

### Functions

The header file `io.h` contains function *prototypes* for reading and
writing these data files. Your task is to write a corresponding
implementation in `io.c` for each of the prototypes.

For example, the function

```C
double* read_points(FILE *f, int *n_out, int* d_out);
```

should read (from a file opened with `fopen()`) an *n✕d* matrix whose
elements are double-precision floats, returning a pointer that points
to the raw data.  The size of the matrix must be written to the
variables pointed to by the `n_out` and `d_out` parameters.  If an
error occurs during reading, the function should return `NULL`.

An example of how to use the function (but here without error
checking) is as follows:

```C
FILE *f = fopen("20_5.points", "r");
int n, d;
double *data = read_points(f, &n, &d);
```

You must also implement the `read_indexes()` function.  The data
format for an indexes file (e.g. `10_3.indexes`) is very similar to a
points file, except that the elements are now 4-byte integers instead
of 8-byte `double`s.

#### Hints

A sketch of the intended implementation:

* Call `fread()` to read *n*.

* Call `fread()` again to read *d*.

* Allocate space for *n✕d* `double`s with `malloc()`.

* Use a final `fread()` call to read data into the memory you just
  allocated.

### Testing point reading

Write a program `printpoints.c` that can be run as

```
$ ./printpoints 20_5.points
```

and which will then print a human-readable description of the data
[that looks like this](20_5.points.txt).

### Testing index reading

Write a program `verifyindexes.c` that can be run as

```
$ ./verifyindexes 20_5.points 10_3.indexes
```

and checks whether all the indexes in the indexes files refer to a
valid point in the points file (in this case each index must be zero
or greater and less than 20).  For example, the above command [should
finish succesfully with no
output](https://www.linuxtopia.org/online_books/programming_books/art_of_unix_programming/ch11s09.html),
while the following command should fail:

```
$ ref/verifyindexes 10_2.points 10_3.indexes 
Invalid index: 17
```

## Writing data files

### Generating random points files

### Generating random index files (tricky)

## Multidimensional index calculations

## Function pointers

