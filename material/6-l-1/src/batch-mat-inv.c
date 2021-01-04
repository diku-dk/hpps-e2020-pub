#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <float.h>
#include <assert.h>
#include "timing.h"

int min(int x, int y) {
  if (x < y) {
    return x;
  } else {
    return y;
  }
}

// Find 'i' such that i<j and A[i*m+j] is most distant from zero.  The
// loop here is not parallel (at least not within the framework you've
// been taught), and you will not need to modify it.
int find_pivot(int n, int m, int j, double *A) {
  int best_i = -1;
  double best = 0;
  for (int i = j; i < n; i++) {
    double x = fabs(A[i*m+j]);
    if (x > best) {
      best_i = i;
      best = x;
    }
  }

  return best_i;
}

// A is a row-major order matrix of size n by m.
//
// Note: this implementation is not very numerically stable, and it
// will start to fail for large inputs.
void gaussian_elimination_seq(int n, int m, double *A) {
  int steps = min(n,m);
  double *irow = malloc(m*sizeof(double));
  for (int s = 0; s < steps; s++) {
    int pivot_idx = find_pivot(n, m, s, A);
    assert(pivot_idx >= 0);
    double r = (1-A[s*m+s]) / A[pivot_idx*m+s];
    for (int i = 0; i < m; i++) {
      irow[i] = r * A[pivot_idx*m+i] + A[s*m+i];
    }

    for (int i = 0; i < n; i++) {
      double f = -A[i*m+s];
      if (i == s) {
        for (int j = 0; j < m; j++) {
          double x = irow[j];
          A[i*m+j] = x;
        }
      } else {
        for (int j = 0; j < m; j++) {
          double x = irow[j];
          double y = A[i*m+j];
          A[i*m+j] = f * x + y;
        }
      }
    }
  }
  free(irow);
}

void matrix_inverse_seq(int n, double *M) {
  // Create a matrix A that is M padded to the right with the identity
  // matrix (producing an n by 2n matrix).
  int m = 2*n;
  double *A = malloc(n * m * sizeof(double));

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      if (j < n) {
        A[i*m+j] = M[i*n+j];
      } else {
        A[i*m+j] = (j-n) == i;
      }
    }
  }

  gaussian_elimination_seq(n, m, A);

  // Drop the identity matrix that is now at the front.
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      M[i*n+j] = A[i*m+j+n];
    }
  }

  // Free the intermediate storage.
  free(A);
}

// Invert 'k' matrices that are each 'n' by 'n'.
void batch_matrix_inverse_seq(int k, int n, double *Ms) {
  for (int l = 0; l < k; l++) {
    matrix_inverse_seq(n, &Ms[l*n*n]);
  }
}

// Just make sure the array has some reasonable contents.
void init_array(int l, double *M) {
  srand(l);
  for (int i = 0; i < l; i++) {
    M[i] = ((double)rand()) / RAND_MAX;
  }
}

typedef void (*batch_matrix_inverse_fn)(int, int, double*);

void benchmark(const char *desc, int k, int n,
               batch_matrix_inverse_fn f, double *golden) {
  int runs = 5;
  double *M = malloc(k * n * n * sizeof(double));

  printf("%20s; k=%4d; n=%3d; ", desc, k, n);
  fflush(stdout);

  double t = 0;
  for (int i = 0; i < runs; i++) {
    init_array(k*n*n, M);
    double bef = seconds();
    f(k, n, M);
    double aft = seconds();
    t += aft-bef;
  }

  printf("%8.2f ms/run", t/runs*1000);

  for (int i = 0; i < k*n*n; i++) {
    if (fabs(M[i]/golden[i]) > 1.02) {
      printf(" (invalid at offset %d: %f != %f)", i, M[i], golden[i]);
      break;
    }
  }
  printf("\n");

  free(M);
}

double* compute_golden(int k, int n) {
  double *M = malloc(k * n * n * sizeof(double));
  init_array(k*n*n, M);
  batch_matrix_inverse_seq(k, n, M);
  return M;
}

int main() {
  // Pairs of (n,k)-values for benchmarking.
  int sizes[][2] = {{1, 100},
                    {8, 50},
                    {32, 25},
                    {4, 100},
                    {1024, 64},
                    {8096, 4}};

  int num_sizes = sizeof(sizes)/sizeof(sizes[0]);
  for (int i = 0; i < num_sizes; i++) {
    int k = sizes[i][0];
    int n = sizes[i][1];
    double *golden = compute_golden(k, n);
    benchmark("Sequential",
              k, n, batch_matrix_inverse_seq, golden);
    printf("\n");
    free(golden);
  }
}
