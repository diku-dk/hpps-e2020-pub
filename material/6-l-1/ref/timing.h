#ifndef TIMING_H
#define TIMING_H

#include <sys/time.h>

double seconds() {
  struct timeval tv;
  gettimeofday(&tv, NULL); // The null is for timezone information.
  return tv.tv_sec + tv.tv_usec/1000000.0;
}

#endif
