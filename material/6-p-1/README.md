# Exercises in loop analysis, transformations, and acceleators

## Direction vectors

Construct all direction vectors for the following loop nests and
indicate the type of dependency associated with each.

### A

```
for (int k = 0; k < 100; k++)
  for (int j = 0; j < 100; j++)
    for (int i = 0; i < 100; i++)
      A[i+1][j+2][k+1] = A[i][j][k+1] + B;
```

Can this loop nest be parallelised?  How?

### B

```
for (int k = 0; k < 100; k++)
  for (int j = 0; j < 100; j++)
    for (int i = 0; i < 100; i++)
      A[I+1][J][K] = A[I][J][5] + B;
```

Can this loop nest be parallelised?  How?

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
