# Exercises in concurrent programming and scalability

This page contains the exercise problems related to concurrency and
parallelism for week 5.

**Note:** _The solutions are not hidden on Internet Explorer/Edge_ as
it does not support the feature used to hide them. Please use any
other browser, or avoid scrolling into the solution.

## Concurrent programming

* Problem 12.9 (page 1042)

* Problem 12.10 (page 1044)

* Problem 12.19 (page 1068)

## Scalability and speedup

### Amdahl's Law

For this question we use Amdahl's Law to estimate speedup.  Suppose we
have a program where 4% of the work is *not* parallelisable.  Assuming
the rest can be fully parallelised without any overhead:

1. What is the speedup if we run it on a 4-processor machine?
2. What about with 128 processors?
3. What is the smallest number of processors that will give us a speedup of at least 5?
4. What is the smallest number of processors that will give us a speedup of at least 30?

<details>
  <summary>Open this to see the answer</summary>

Since 4% is not parallelisable, *p=0.96*, which gives us *S(N) =
1/(1-0.96+(0.96/N))*.

1. *S(4) = 1 / (1-0.96+(0.96/4)) = 3.57*

2. *S(128) = 1 / (1-0.96+(0.96/128)) = 21.05*

3. *S(N) = 5*.  Solving for *N*, we get *N=6*.

4. Since the limit of *S(N)* is *25* as *N* goes to infinity, we
   cannot ever get a speedup of at least 30 with this program.

</details>

### Gustafson's Law

For this question we use Gustafson's Law to estimate speedup.  Suppose
we have a program where 4% of the work is *not* parallelisable.
Assuming the rest can be fully parallelised without any overhead, and
that the parallel workload is proportional to the amount of
processors/threads we use:

1. What is the speedup if we run it on a 4-processor machine?
2. What about with 128 processors?
3. What is the smallest number of processors that will give us a speedup of at least 5?
4. What is the smallest number of processors that will give us a speedup of at least 30?

<details>
  <summary>Open this to see the answer</summary>

Since 4% is not parallelisable, *s=0.04*, which gives us *S(N) =
N + (1-N) * 0.04*.

1. *S(4) = 3.88*

2. *S(128) = = 122.92*

3. *S(N) = 5*.  Solving for *N*, we get *N=31/6*, and since we cannot
   have a fractional number of processors, we round up to *N=6*.

4. *S(N) = 30*.  Solving for *N*, we get *N=749/24*, which we round up
   to *N=32*.

</details>
