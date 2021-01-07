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


# Accelerators

The next set of questions is about computation using acceleration devices such as GPGPUs and FPGAs.

## Performance of an FPGA design

You have designed a circuit on an FPGA using a 5-staged pipeline. The circuit can be timed to run at 200 MHz, and will input 32 bits of data for each clock cycle.

How long will it take to process 100 MiB of data?

<details>
  <summary>Open this to see the answer</summary>

* A clock frequency of `200 MHz` is equvalent to `1000/200 = 5 ns` pr clock cycle
* With `100 MiB` as 32 bits we get `100*1,024*1,024 / 32 = 3,276,800` words.
* We can process one word per clock cycle so the bulk processing time is `3,276,800 * 5 ns = 16,384,000 ns`.
* Due to the pipeline, we will not see any output for the first 5 cycles, so we get an additional delay of `5 * 5 ns = 25 ns`
* The total time is then `16,384,000 + 25 = 16,384,025 ns`, or appx. `16 ms`

</details>


## Theoretical maximum CPU performance

A top-end CPU is the [AMD Ryzen 3990x](https://www.amd.com/en/products/cpu/amd-ryzen-threadripper-3990x). The specifications for this CPU lists `64 cores`, `4,300 MHz` and `4 FLOPs` pr instruction.

What is the theoretical compute power of this processor?

<details>
  <summary>Open this to see the answer</summary>

```
64 * 4,300 * 4 = 1,100,800 MFLOP/s = 1,100 GFLOP/s
```

</details>

## Theoretical maximum GPGPU performance

A top-end GPGPU is the [Nvidia RTX 3090](https://www.nvidia.com/en-us/geforce/graphics-cards/30-series/rtx-3090/). This card is listed as having `10,496 cores`, `1,695 MHz` and `2 FLOPs` pr instruction.

What is the theoretical compute power of this GPGPU?

<details>
  
  <summary>Open this to see the answer</summary>

```
10,496 * 1,695 * 2 = 35,581,440 MFLOP/s = 35,581 GFLOP/s
```

</details>

## Running time of a program on a GPGPU

**Note:** For this question you should compute the optimal theoretic best speed, ignoring cache issues, datapath utilization etc.

Given a program, which uses 8 GiB data (meaning 8 GiB read and 8 GiB write), a parallelizable loop with `16,384 iterations` containing `256 floating point operations`, how long time does it take to execute on a CPU with `64 cores`, running at `4,300 MHz` with `4 FLOPs` per instruction, with a memory bandwith of `102.4 GB/s`?


<details>
  
  <summary>Open this to see the answer</summary>

* Memory access takes `8 / 102.4 = 0.0781 s`
* We split the iterations on the cores, so we have `ceil(16384 / 64) = ceil(256) = 256` iterations pr core.
* With 4 FLOPs pr cycle we need `256 / 4 = 64` cycles pr iteration
* One cycle takes `1000 / 4300 = 0.2326 ns`
* One iteration takes `64 * 0.2326 = 14.8864 ns`
* The computation takes `256 * 14.8864 = 3810.9184 ns`
* The program taes a total of `memory + compute + memory` giving `781,000 + 3.8110 us + 781,000 us = 1,562,003.811 us` or `1.562 s`

  
</details>

## Running time of a program on a GPGPU

**Note:** For this question you should compute the optimal theoretic best speed, ignoring cache issues, datapath utilization etc.

Given a program, which uses 8 GiB data (meaning 8 GiB read and 8 GiB write), a parallelizable loop with `16,384 iterations` containing `256 floating point operations`, how long time does it take to execute on a GPGPU with `10,496` cores, running at `1,695 MHz` with `2 FLOPs` per instruction, and a memory bandwith of `936.2 GB/s`?

<details>
  
  <summary>Open this to see the answer</summary>


* Memory access is `8 / 936.2 = 0.0086 s`
* Iterations pr core is `ceil(16384 / 10496) = ceil(1.5610) = 2` iterations
* With two FLOPs pr cycle, we get `256 / 2 = 128` cycles pr iteration
* One clock cycle is `1000 / 1,695 = 0.5899 ns`
* One iteration is `128 * 0.5899 = 75.5162 ns`
* Computation takes `2 * 75.5162 = 151.0324 ns`
* Total is then `memory + compute + memory`, giving `8,550 + 0.151 + 8,550 = 17,100.151 us` or appx. `0.0171 s`

</details>
