# Working with accellerators

The prerequisite for this lab is:
  * [Video 12](https://sid.erda.dk/share_redirect/bGBNXHzM4g/12%20-%20Accelerators.mp4) ([slides for video 12](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/6-l-2/12%20-%20Accelerators.pdf))

# Working with OpenCL

While OpenCL is originally designed to work with accelerators, the model can also work with multi-core, but rarely gives a great speedup.

However, we can use this to experiment with the OpenCL programming model, even if we do not have an OpenCL compatible graphics card.

For each of the following tasks:
- Implement a solution using OpenCL. You can either use the provided `pyopencl` host program, or write your own in another language, e.g. C.
  - If you choose to implement your own host program, remember to have a reference solution which you can trust produces correct results, e.g. a library call.
  - When comparing floating point numbers, remember not to do a direct comparison (`result == expected`), but rather look at the difference (`result - expected < threshold`).
- Time the reference implementation against your OpenCL implementation. Is it faster or slower? What if you modify the problem size?
  - When timing OpenCL, remember to call `finish()` on the queue, otherwise you will be timing scheduling each operation.
- Try to time the copying to/from the device and the device execution seperately. Is the time dominated by copying or by execution? What if you modify the problem size?
  - Again, remember to call `finish()` on the queue after each step:
    1. Copy to device
    2. Execute kernel
    3. Copy from device.

**Note: as mentioned, you might not be able to beat optimized CPU implementations, such as Numpy, with a straightforward OpenCL implementation. In that case, it really depends on the available hardware.**

## 1. Vector addition

This is the "hello world" of GPU programming and is also the example presented during the lecture. In pseudo Python, this would be implemented as
```python
for i in range(n):
    c[i] = a[i] + b[i]
```
where `a` and `b` are vectors of size `n`.

## 2. Matrix multiplication

This is one of the tasks GPUs excell at. While the naive GPU implementation won't beat an optimized CPU implementation, an optimized GPU implementation beats any CPU implementation. In pseudo Python, the naive implementation is as follows:
```python
for i in range(N):
    for j in range(M):
        tmp = 0.0
        for k in range(K):
            tmp += a[i,k] * b[k,j]
        c[i,j] = tmp
```
where `a` is an `N` by `K` matrix, `b` is an `K` by `M` matrix and `c` is an `N` by `M` matrix.

Note: in OpenCL memory arguments are given as a pointer to memory, which is why the kernel should compute the flat index. E.g. for index `i,j` in an `N` by `M` matrix, the flat index would be `i*M+j`.

## 3. Mean filter

The mean filter is the same as an image convolution where all the entries in the kernel have equal weight. It is commonly used to blur images. In pseudo Python, the naive implementation is as follows:
```python
for i in range(N):
    for j in range(M):
        tmp = 0.0
        offset_i = i - (K//2)
        offset_j = i - (K//2)
        for ii in range(K):
            for jj in range(K):
                row = offset_i + ii
                col = offset_j + jj
                if row >= 0 and row < N and col >= 0 and col < M:
                    tmp += img[row,col]
                else:
                    tmp += 0.0
        result[i,j] = tmp / (K*K)
```
where `img` is an `N` by `M` matrix, `result` is an `N` by `M` matrix and `K` is the size of the kernel.

# Working with VHDL

To get started with VHDL and hardware based accellerators you can try to implement a working [ripple-carry adder](https://en.wikipedia.org/wiki/Adder_(electronics)#Ripple-carry_adder), as we presented in the first video. Hint: you could try to implement a half adder and a full adder individually. It is up to you if you want to implement them with or without registers, i.e. whether they are guarded by a clock signal.

However, the tools are a bit difficult to get working, so you might want to either use the [GHDL Docker image](https://hub.docker.com/r/ghdl/ghdl) or try it on [ERDA/DAG](https://github.com/diku-dk/hpps-e2020-pub/blob/master/ERDA.md#data-analysis-gateway-dag).

For ERDA, we have prepared all the tools such that you can set up a working environment quickly. Once you have the Jupyter start page on ERDA/DAG, use the console, and run these commands:

```bash
cd ~/work
curl -OL 'https://sid.erda.dk/share_redirect/GkfXNG21i1/ghdl.tar.bz2'
tar -xvf ghdl.tar.bz2
cd ghdl
```

Inside the folder you can now test the GHDL installation, with something like:
```bash
./ghdl --version
```
And you can test the example from the slides:
```bash
make
```


TBD
