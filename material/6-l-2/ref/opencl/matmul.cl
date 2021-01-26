__kernel void matmul(
                         __global float *a,
                         __global float *b,
                         __global float *c,
                         const unsigned int N,
                         const unsigned int K,
                         const unsigned int M) {
    // Get the thread ids
    int i = get_global_id(0);
    int j = get_global_id(1);

    float tmp = 0.0f;
    for (int k = 0; k < K; k++) {
        tmp += a[i*K+k] * b[k*M+j];
    }
    c[i*M+j] = tmp;
}
