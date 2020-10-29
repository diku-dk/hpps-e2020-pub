#ifndef KNN_IO_H
#define KNN_IO_H

#include <stdio.h>
#include <stdint.h>

// Read points from a points data file.  Returns a pointer to the
// data, and writes the size to the n_out and d_out arguments.
double* read_points(FILE *f, int *n_out, int* d_out);

// Read indexes from a points data file.  Returns a pointer to the
// data, and writes the size to the n_out and k_out arguments.
int* read_indexes(FILE *f, int *n_out, int* k_out);

// Write a points data file based on the given data.
int write_points(FILE *f, int32_t n, int32_t d, double *data);

// Write an indexes data file based on the given data.
int write_indexes(FILE *f, int32_t n, int32_t k, int *data);

#endif
