#include "io.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdint.h>
#include <time.h>

int main(int argc, char** argv) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s <n> <d>\n", argv[0]);
    exit(1);
  }

  int32_t n = atoi(argv[1]);
  int32_t d = atoi(argv[2]);

  srand(time(NULL) ^ d ^ n);

  double *data = malloc(n*d*sizeof(double));

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < d; j++) {
      double x = ((double)rand())/RAND_MAX;
      data[i*d+j] = x;
    }
  }

  int err = write_points(stdout, n, d, data);
  assert(err == 0);

  free(data);
}
