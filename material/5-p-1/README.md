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

Suppose we have a program where 4% of the work is not parallelisable.
Assuming the rest can be fully parallelised without any overhead, what
is the speedup if we run it on a 4-core machine?  What about with 128
cores?  How many cores do we need to get a speedup of 30?

<details>
  <summary>Open this to see the answer</summary>

  ```
  p = 0.96

  S(4) = 1 / (1-0.96+(0.96/4)) = 3.57

  S(128) = 1 / (1-0.96+(0.96/128)) = 21.05

  ```

  Since the limit of *S(N)* is *25* as *N* goes to infinity, we cannot
  ever get a speedup of 30 with this program.

</details>
