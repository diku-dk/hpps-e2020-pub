# Lab: transforming batched matrix inversion to obtain more parallelism

In this lab you will practice transforming a program to expose more
parallelism.  The basic steps are:

* Identifying which loops are parallel.

* If possible, transforming non-parallel loops to make them parallel.

* Apply *non-nested* OpenMP pragmas to parallelise loop nests (using
  the `collapse` clause to parallelise multiple loops, see the
  lectures notes or the OpenMP videos if you forgot what this is
  about).

* Use techniques like interchange and distribution to maximise the
  amount of exposed parallelism.

*Maximising parallelism* is not always (or even usually) the same as
*maximimising performance*.  Many of your transformations will
actually make the program slower.  That doesn't mean you messed up, as
long as the program still computes the right result.
The goal for this lab is just to ensure that as many of the loops are
executed in parallel as possible.  While this kind of fine-grain
parallelism is *sometimes* useful (in particular when programming
accelerators - the topic on Thursday), it is usually not on CPUs.

The lab will also try to show you the value of having *validation*
when trying to optimise or otherwise transform a program.
Specifically, the [code handout](src/) contains a sequential
"reference implementation", that you should *not* modify.  Instead,
you should work on a copy of the functions, and after every change,
compare the result of your modified program with the original.  You
are given scaffolding code that does this.

## The program to parallelise

You will be parallelising an implementation of *batched* matrix
inversion via [Gaussian
elimination](https://en.wikipedia.org/wiki/Gaussian_elimination).  By
*batched* we mean that the program is inverting multiple matrices of
the same size.  You do not have to understand the algorithm, but you
will have to understand the code structure.

* The function `find_pivot` finds the best pivot element for a step in
  the Gaussian elimination.  You do not have to modify (or even really
  understand) this function.

* The function `gaussian_elimination_seq(n,m,A)` function performs
  Gaussian elimination on an `n` by `m` matrix stored at `A`.  There
  is an outer loop and multiple inner loops.

* The function `matrix_inverse_seq(n,M)` inverts the `n` by `n` matrix
  stored at `M`.  It does this by constructing a new matrix `A` of
  size `n` by `2n`, where the right half of this matrix is an `n` by
  `n` identity matrix.  It then uses
  `gaussian_elimination_seq(n,2*n,A)` to perform Gaussian elimination
  on `A`, and then extracts the rightmost half of `A`, which will now
  contain an inverted form of `M` (you don't have to understand the
  algorithmic reasons for why this works).

* The function `batch_matrix_inverse_seq(k,n,Ms)` inverts the `k`
  matrices (each `n` by `n`), that are stored consecutively at `Ms`,
  by applying `matrix_inverse_seq` to each of them.

The rest of the code handout contains code for generating random
matrices of various sizes, and benchmarking how fast they can be
inverted.  You can compile the program with

```
$ make
```

and then it run with

```
$ ./match-mat-inv
```

which will then tell you how fast the specified implementation of
batched matrix inversion runs for various values of *k* and *n*.

In the handout, there is only the sequential version.  See the
`main()` function for how to add new versions.  For example, suppose
you end up defining a function called `batch_matrix_inverse_par`.  You
would then add this statement to the loop in `main()`:

```
benchmark("Parallel",
          k, n, batch_matrix_inverse_par, golden);
```

## Preparing parallelisation

1. Start by *copying* the sequential functions
   (`gaussian_elimination_seq`, `matrix_inverse_seq`,
   `batch_matrix_inverse_seq`) and give them new names.

2. Make sure to also update the function calls in their definitions.

3. Add a call to your new batched matrix inversion to the
   test/benchmark scaffolding in `main()`.  Compile and run and verify
   that you did everything correctly.

4. Make a change to your implementation such that your functions no
   longer compute the right result (e.g. add a constant to one of the
   intermediate computations, or break out of a loop early).
   Recompile and rerun, and verify that the program reports the
   invalid result.

From now on, whenever you modify something, *always* recompile and
rerun to see whether you made a mistake.  It's *much* easier to find
mistakes if you test frequently, rather than trying to figure out what
detail you wrong modifying dozens of lines of code.

## Parallelising the outermost loop

* Find the outermost loop you believe can be parallelised (not
  counting the one in `main()`).

* Justify to yourself why parallelisation is safe.  This does not have
  to involve low-level analysis with dependency vectors.  Just try to
  reason informally why the different iterations cannot affect each
  other.

* Add an appropriate OpenMP pragma.

* Run the benchmarks and reflect on the results.

## Exposing more parallelism in Gaussian elimination

The `gaussian_elimination()` function contains several loops.

* Is the outermost `for`-loop parallel?  Why or why not?

* Can the first inner `for`-loop (the one that writes to `irow`) be
  run in parallel?

* Can the second inner `for`-loop be run in parallel?  If not, can you
  think of a way to fix it so that it can?

The second inner `for`-loop is interesting because it contains a
branch, and those branches then contain further `for`-loops.  Try to
see if you can rewrite the loop nest so that it contains two
*perfectly nested* loops, which can then be parallelised by OpenMP
with a `collapse` clause.

### Hints

* The second inner `for`-loop is not parallel, because there WAR
  dependency on `A`.

* As discussed in the videos, you can often circumvent WAR
  dependencies by copying in advance the values that would be
  overwritten.

* Use something like this:

  ```
  double *f_copy = malloc(n * sizeof(double));
  for (int i = 0; i < n; i++) {
    f_copy[i] = -A[i*m+s];
  }
  ```

  Then replace the definition of `f` in the loop nest with:

  ```
  double f = f_copy[i];
  ```

  Is the loop parallel now?  Can the creation of `f_copy` be
  parallelised?

* You can turn the second `for`-loop into two-deep perfect loop nest
  by moving the `if`s inside the innermost loop.  This is the
  structure you need:

  ```
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      ...
      if (i == s) {
        ...
      } else {
        ...
      }
    }
  }
  ```

## Maximising parallelism with interchange loop distribution

In `batch_matrix_inverse()` we have a parallel loop over all the
matrices, and in `gaussian_elimination()` we have more parallel loops.
Two things prevent us from exploiting this parallelism with OpenMP
`collapse` clauses:

* The outer sequential loop in `gaussian_elimination()` gets in the way.

* The `collapse` clauses requires *perfect nests*.

To address this, we need to use *loop interchange* and *loop
distribution*.  Unfortunately, these are non-modular transformations,
so this is where the code will have to become uglier.

* First, *inline* `gaussian_elimination()` directly in
  `batch_matrix_inverse()`, so there is no function call (except to
  `find_pivot()`, which you can leave as is).

* Test to make sure you didn't make any mistakes.

Now you have a whole mess of loops that you can start restructuring
radically.

* Why is it legal to *interchange* the outermost loop (the one with
  `k` iterations) and the sequential `for`-loop?

* Interchange those two loops.

* Test.

Now you can apply loop distribution to form (multiple) perfect
parallel loop nests.  You will end up with at least five, and you will
need to apply memory expansion to the `A`, `irow`, `f`, `f_copy`, and
`pivot_idx` variables.
