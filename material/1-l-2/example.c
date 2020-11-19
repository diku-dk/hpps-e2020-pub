#include <stdio.h>
#include "tfl.h"

// Bit patterns taken from assignment text
#define POSITIVE_ZERO (0b0000000000000000)
#define NEGATIVE_ZERO (0b1000000000000000)
#define POSITIVE_ONE (0b0000011000000000)
#define NEGATIVE_ONE (0b1000011000000000)

tfl16_t tfl_sign(tfl16_t value) {
  if ((value == POSITIVE_ZERO) || (value == NEGATIVE_ZERO)) {
    // Assignment definition is weak, could also return value, which would keep the sign bit      
    return POSITIVE_ZERO;
  }
  
  uint16_t sign_only = value & 0x8000; //0x8000 == 0b1000000000000000;
  if (sign_only == 0x8000) {
    return NEGATIVE_ONE;
  }
  
  return POSITIVE_ONE; 
}

int test_tfl_sign() {
  if (tfl_sign(POSITIVE_ZERO) != POSITIVE_ZERO) {
    printf("Failed tfl_sign(+0.0)\n");
    return 1;
  }
  if (tfl_sign(NEGATIVE_ZERO) != POSITIVE_ZERO) {
    printf("Failed tfl_sign(-0.0)\n");
    return 1;
  }
  if (tfl_sign(NEGATIVE_ONE) != NEGATIVE_ONE) {
    printf("Failed tfl_sign(-1.0)\n");
    return 1;
  }
  if (tfl_sign(POSITIVE_ONE) != POSITIVE_ONE) {
    printf("Failed tfl_sign(+1.0)\n");
    return 1;
  }
  if (tfl_sign(0b0000101100100100) != POSITIVE_ONE) {
    printf("Failed tfl_sign(+3.141)\n");
    return 1;
  }
  if (tfl_sign(0b1000101100100100) != NEGATIVE_ONE) {
    printf("Failed tfl_sign(-3.141)\n");
    return 1;
  }
  
  // ... add more tests as you see fit

  return 0;
}

int8_t tfl_exponent(tfl16_t value) {
    // TODO: Fix this!
    return 0;
}

int test_tfl_exponent() {
  if (tfl_exponent(POSITIVE_ZERO) != 0) {
    printf("Failed tfl_exponent(+0.0)\n");
    return 1;
  }
  if (tfl_exponent(NEGATIVE_ZERO) != 0) {
    printf("Failed tfl_exponent(-0.0)\n");
    return 1;
  }
  if (tfl_exponent(NEGATIVE_ONE) != 1) {
    printf("Failed tfl_exponent(-1.0)\n");
    return 1;
  }
  if (tfl_exponent(POSITIVE_ONE) != 1) {
    printf("Failed tfl_exponent(+1.0)\n");
    return 1;
  }
  if (tfl_exponent(0b0000101100100100) != 2) {
    printf("Failed tfl_exponent(+3.141)\n");
    return 1;
  }
  if (tfl_exponent(0b1000101100100100) != 2) {
    printf("Failed tfl_exponent(-3.141)\n");
    return 1;
  }
  
  // ... add more tests as you see fit

  return 0;
}

int main() {
  if (test_tfl_sign() != 0) {
      return 1;
  }

  if (test_tfl_exponent() != 0) {
      return 1;
  }

  printf("All tests passed!\n");

  return 0;
}
