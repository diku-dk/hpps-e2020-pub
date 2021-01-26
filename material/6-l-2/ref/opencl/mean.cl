__kernel void mean(
                         __global float *img,
                         __global float *result,
                         const unsigned int n,
                         const unsigned int m,
                         const unsigned int k) {
    // Get the thread ids
    int half_width = k >> 1;
    int i = get_global_id(0);
    int j = get_global_id(1);
    int offset_i = i - half_width;
    int offset_j = j - half_width;

    float sum = 0.0f;
    for (int ii = 0; ii < k; ii++) {
        for (int jj = 0; jj < k; jj++) {
            int gi = offset_i + ii;
            int gj = offset_j + jj;
            if (gi >= 0 && gi < n && gj >= 0 && gj < m)
                sum += img[gi*m+gj];
            // else sum += 0.0f;
        }
    }
    result[i*m+j] = sum / (k * k);
}
