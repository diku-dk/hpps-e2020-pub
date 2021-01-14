---
title: Troels' research and how it relates to HPPS
---

## What I do

* I research *parallel programming languages*:

    * How should we express algorithms in a way that is friendly to
      humans?

    * How do we translate programs in those languages to efficient
      code?

### In particular

* I've worked a lot with GPUs: *massively parallel* processors with
  many programming restrictions but high numerical performance.

## I don't really believe what I have been teaching you

```C
#pragma omp parallel for
for (int i = 0; i < n; i++) {
  x[i] = f(y[i])
}
```

. . .

What if

```C
int *y = &x[100];
```

* OpenOP is not *safe*.

* It is *too low level*.

* It is *not modular*.

## Write what you mean!

We express algorithms that have plenty of parallelism with a
*sequential vocabulary*.

. . .

### What if we improved our vocabulary?

```C
for (int i = 0; i < n; i++) {
  ys[i] = f(xs[i]);            ⇨   let ys = map f xs
}
```

```C
for (int i = 0; i < n; i++) {
  ys[i+1] = f(ys[i], xs[i]);   ⇨   let ys = scan f xs
}
```

The functional programming vocabulary that you saw in F# is _almost_
what we need.

## Futhark!

* Data parallel functional programming language for numerical
  computing.

* High level and portable.

* State-of-the-art heavily optimising compiler for GPUs and CPUs.

* Research vehicle.

* *Practically useful and publicly available open source software:*
  https://futhark-lang.org

## Examples

### Basic parallelism

```Futhark
let vecprod [n] (xs: [n]i32) (ys: [n]i32): [n]i32 =
  map2 (\x y -> x * y) xs ys
```

. . .

### Dot Product

```Futhark
let dotprod [n] (xs: [n]i32) (ys: [n]i32): i32 =
  reduce (+) 0 (vecprod xs ys)
```

. . .

### Matrix Multiplication

```Futhark
let matmul [n][m][p] (a: [n][m]i32) (b: [m][p]i32): [n][p]i32 =
  map (\a_row ->
         map (\a_col ->
                dotprod a_row a_col)
             (transpose b))
      a
```

## If you want to learn more

* *Programming Massively Parallel Hardware* (master's course, block 1).

* *Parallel Functional Programming* (renamed *Data Parallel
  Programming* from next year, master's course, block 2).

* I also occasionally supervise student projects on implementing
  parallel algorithms.
