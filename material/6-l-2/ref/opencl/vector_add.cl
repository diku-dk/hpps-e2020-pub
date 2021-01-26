__kernel void vector_add(
                         __global float *a,
                         __global float *b,
                         __global float *c,
                         const unsigned int n) {
    // Get the thread id
    int id = get_global_id(0);

    if (id < n)
        c[id] = a[id] + b[id];
}
