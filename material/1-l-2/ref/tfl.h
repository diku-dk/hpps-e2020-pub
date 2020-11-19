#include <stdint.h>
typedef uint16_t tfl16_t;

tfl16_t  tfl_sign(tfl16_t value);
int8_t   tfl_exponent(tfl16_t value);
uint16_t tfl_significand(tfl16_t value);
uint8_t  tfl_equals(tfl16_t a, tfl16_t b);
uint8_t  tfl_greaterthan(tfl16_t a, tfl16_t b);
tfl16_t  tfl_normalize(uint8_t sign, int8_t exponent, uint16_t significand);
tfl16_t  tfl_add(tfl16_t a, tfl16_t b);
tfl16_t  tfl_mul(tfl16_t a, tfl16_t b);
