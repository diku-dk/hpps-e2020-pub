# Exercises in loop analysis, transformations, and accelerators

**Note:** _The solutions are not hidden on Internet Explorer/Edge_ as
it does not support the feature used to hide them. Please use any
other browser, or avoid scrolling into the solution.

## Direction vectors

Construct all direction vectors for the following loop nests and
indicate the type of dependency associated with each.  Also explain
whether any of the loops can be executed in parallel.

### A

```
for (int k = 0; k < 100; k++)
  for (int j = 0; j < 100; j++)
    for (int i = 0; i < 100; i++)
      A[k+1][j+2][i+1] = A[k+1][j][i] + B;
```

<details>
  <summary>Open this to see the answer</summary>

The access to `A` has a RAW dependency with directions `[=, <, <]`

This implies the outer loop can be executed in parallel.

</details>

### B

```
for (int k = 0; k < 100; k++)
  for (int j = 0; j < 100; j++)
    for (int i = 0; i < 100; i++)
      A[k][j][i+1] = A[5][j][i] + B;
```

<details>
  <summary>Open this to see the answer</summary>

* The access to A has:

  * A RAW dependency with directions `[*, =, <]`.

  * A WAR dependency with directions `[*, =, <]`

This implies that the middle loop can be executed in parallel.

</details>

## Parallellisation

### Loop reversal

Loop reversal is a transformation that rewrites a loop header from

```
for (int i = 0; i < n; i++)
```

to

```
for (int n-1 = 0; i >= 0; i--)
```

without changing the loop body.  That is, it changes the loop to run
iterations in reverse order.  Can you come up with a sufficient
condition for when this transformation is valid?  Can you come up with
an example of where your sufficient condition is false, but the loop
can still be safely reversed?

#### Hints

* A *sufficient condition* means that if the condition holds, then the
  transformation is safe, but there might also be cases where it is
  safe regardless (a *necessary condition* is one that is *always*
  true when the transformation is valid).

* The loop being reversed might be part of a bigger nest.

### Reversability of loop

Is loop reversal valid on the `i` loop in the following nest? Why or
why not?

```
for (int j = 0; j < n; j++)
  for (int i = 0; i < m; i++)
    A[I+1][J+1] = A[I][J] + c;
```

### Does reversability imply parallelisability?

**Claim:** if you can reverse a loop and get the same result as when
the original loop, then the loop can be safely executed in parallel.
Is this claim true?  If not, show a counterexample.

<details>
  <summary>Open this to see the answer</summary>

The claim is **false**, because the different loop iterations might
write to a shared local variable.

```
float x;
for (int i = 0; i < n; i++) {
  x = A[i];
  B[i] = x;
}
```

</details>
