# Follow up after the lab session

This document contains notes and hints based on feedback from students in the second lab session.

## Material extent

It was reported that the material required for the lectures this week was too much for the allocated time. 

## Writing a program in C requires a `main()` function

For a program to work, it needs an entry-level function. This is unlike the way Python works, in that a C file cannot contain code statements that are not enclosed in a function. For a minimal start to the assignment, one could use an example such as:
```c
#include <stdio.h>
#include "tfl.h"

void my_function_a() {
}

void another_function() {
}

int main() {
  my_function();
  another_function();
  return 0;
}
```

## Bits are bits and nothing more

One of the core concepts in the assignment is that a sequence of bits (16 in this case) does not have an intrinsic meaning, the program decides how to interpret them. This is different from, say Python, where a value is always of a particular type. With a sequence of bits, we can manipulate it as we see fit, and are not constrained to the types inherent in C or in the processor.

## Implementing the `tfl_sign` function

There was some confusion as to how the sign function should be implemented. If we look at the declaration it is: 
```c
tfl16_t  tfl_sign(tfl16_t value);
```

The text says that the input (and output) must be a "float", and the type is `tfl16_t`. This means that we must pass in some sequence of 16 bits, and return some sequence of 16 bits. As mentioned above, we are free to treat the bits as we like, and in this case, the input (and output) sequences must follow the format given in the assignment. As an example, to send the _interpreted_ value `1.0` we must send the bit pattern `0 00001 1000000000` (taken from the assignment example table). Reading the assignment text, the output of the function should return `0.0` if the input is zero, `-1.0` if the input is negative, otherwise `1.0`.

From this we can deduce that we will need at least three `return` statements (one for each value), and by trial-and-error, you can see that you will need at least two `if` statements to allow for three `return` statements.

If you have already implemented the function when you read this, you should keep your solution, it is not necessarily wrong or worse, just because it looks different from mine. There are many ways to solve it, such as looking at the `uint16_t` values where the most-significant bit is set. 

But I would start with the check for zero. This is slightly harder than it looks because we have both `-0` and `+0`. My solution is to declare these common values, using `#define`, which lets me re-use the values without needing to copy-paste it:
```c
// Bit patterns taken from assignment text
#define POSITIVE_ZERO (0b0000000000000000)
#define NEGATIVE_ZERO (0b1000000000000000)
#define POSITIVE_ONE (0b0000011000000000)
#define NEGATIVE_ONE (0b1000011000000000)
```

With those in place, we can perform the zero check (note that you could have typed in the bit patterns as well):
```c
tfl16_t tfl_sign(tfl16_t value) {
  if ((value == POSITIVE_ZERO) || (value == NEGATIVE_ZERO)) {
    return POSITIVE_ZERO; // Assignment definition is weak, could also return value, which would keep the sign bit
  }
  
  // TODO: Handle negative values
  return POSITIVE_ONE; 
}
```

Now the function is _almost_ done, but we need to examine the sign bit to figure out if the number is negative. In other words, we need to isolate the part we want to examine, and then compare. If we tried something like `if (value > 0)`, it would treat `value` as an `uint16`, which would not work. One solution is to use the bitwise `AND` operator (single `&`) to set the other bits to zero. We know from the `AND` truth table that it requires both bits to be `1` for the result to be `1`. We can use this with a set of `0`'s to "clear" bits we do not care about. If we use ? as a placeholder for a bit (we don't know which), the bitwise `AND` operator works such as this:
```
  0b???? ????
& 0b1000 0000
  -----------
  0b?000 0000
```

If required, we can also selectively set bits with the bitwise `OR` operator (single `|`):
```
  0b???? ????
| 0b0111 1111
  -----------
  0b?111 1111
```


With the bitwise `AND` we can then clear everything but the sign bit, leaving us with only two possible values (`0b1000...` or `0b0000...`).

We can use these directly in the comparison, giving us a method that looks like this:
```c
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
```

## Testing the method

A few students reported that they were not used to writing test functions and were unsure of how to start.

While it is possible to test with one value at a time, and manually verify the results, it is usually much more robust to write a small function that tests for outcomes, and automatically reports errors. You could write a method such as this to test:
```c
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
```

I have combined the functions `main()`, `tfl_sign()` and `test_tfl_sign()` in a [template-like file](example.c) where you can add on.


## Hints for `tfl_exponent()` and `tfl_significand()`

For the two next functions, we need to extract a set of bits, similar to how we did with `tfl_sign()`. The easiest is perhaps the `tfl_significand()` function that needs the lower 10 bits. You can isolate these using the bitwise `AND` operator with an appropriate mask. As the result is unsigned, you can convert it to an `uint16_t` with something like this:
```c
uint16_t significand = value & BIT_MASK_YOU_DECIDE;
```

The `tfl_exponent()` method is somewhat similar, but here we have the problem that we can isolate the bits in the same way, but to get them into an 8-bit value, we need to "move" them into place. The most efficient way is to use the bit shift operators (`>>` and `<<`). As an example with an 8 bit value:
```
0b???? ???? >> 1 = 0b0??? ????
0b???? ???? >> 2 = 0b00?? ????
0b???? ???? >> 6 = 0b0000 00??
0b???? ???? >> 7 = 0b0000 000?

0b110 11100 >> 1 = 0b0110 1110
0b110 11100 >> 2 = 0b0011 0111
0b110 11100 >> 6 = 0b0000 0011
0b110 11100 >> 7 = 0b0000 0001
```

You can use a bitwise `AND` to mask before or after the shifting as you like. When you have the result you will discover that the 5 bits placed into an 8-bit value will not correctly work with negative numbers. Remember that negative values have all leading `1`s. Again, there are many ways to deal with it, but you _could_ use the same method as we used to examine the sign bit in `tfl_sign()` to examine the sign bit in the 8-bit number. If this bit is set, you can use the bitwise `OR` operator to set the 3 upper bits to `1`. It could look something like:
```c
// Assumes value is the 5 exponent bits isolated and moved into place
if (value & 0b00010000) {
  return (int8_t)(value | 0b11100000);
}
return (int8_t)value;
```

## Debugging help

You may want to visualize the values you are working on. I have added two methods `print_bits()` and `print_parts()` to the [example template file](example.c) which will print a `tfl16_t` value to the console in either the bit pattern or the formula-style format, so you can compare with the values in the assignment table.
