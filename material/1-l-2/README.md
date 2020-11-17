# Lab: Numeric representations with C

This lab is intended to get you started with the C programming language and the first assignment. We will discuss a number of the methods that needs to be implemented, and try implementing these by ourselves.

You can choose to work in your groups if you feel more comfortable, but I encourage you to work individually during the lab session, and then compare your own work with your group members afterwards.

If you did not yet watch the videos, they can be found here:
 - [Video 1](https://sid.erda.dk/share_redirect/cO5fYbAdIo/1%20-%20Lecture.mp4) ([slides for video 1](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/1-l-2/1%20-%20Lecture.pdf))
 - [Video 2](https://sid.erda.dk/share_redirect/hMrFbYiUgC/2%20-%20Lecture.mp4) ([slides for video 2](https://github.com/diku-dk/hpps-e2020-pub/raw/master/material/1-l-2/2%20-%20Lecture.pdf))

# Understanding the bit layout

The C programming language will default to treating a sequence of bits with the type we apply. When we get to pointers, you will be able to peek behind this abstraction, but for the first assignment we initially need to consider the numbers as bit sequences.

```
uint16  0000 |  0000 | 0000 | 0000
tlf16  0 000 | 00 00 | 0000 | 0000
```

This allows us to store the 16 bits we need for tlf16 in a 16-bit variable. Since the C programming language allows us to manipulate the bits directly, we can ignore the `|` symbols in the above illustration, and instead treat it as (sign, exp, significand):
```
tfl16: 0 00000 0000000000
```

# The header file

As mentioned in the assignment, we need to implement a number of methods. These are declared in a header file, and as such you can include them with a simple line near the top of yor main C file, such as:
```c
#include "./tfllib.h"
```

If you prefer to work in single-file mode for now, you can also simply copy-n-paste the contents of the header file into your main file (this is what the C compiler does behind the scenes anyway).

Whichever you choose, you should start with a blank file, add the methods signatures, include `<stdio.h>` (we always need it for debugging), and write the main function. You can add the `printf("Hello World!");` line if you prefer, and then make sure your code compiles and runs.

Once you have a basic template up and running, we can start with the first method that we need to implement.

# The sign method

If we observe the figure of the bit locations, we can find the sign bit as the left-most (the most significant) bit. To implement the first method in the assignment, we need to somehow toggle on this bit.

There are multiple ways to accomplish this, but try to consider the problem a bit, and use the information you have learned from the videos and text books.

The description says that we need to return either `-1`, `0`, or `+1`, so we know that there needs to be at least two `if` statements.

Depending on your solution, you can choose different ways to return the result. One method would be to type in the bit pattern directly for each of the three cases, like `return 0b0000000000000000;`, or more succintly: `return 0x0;`.

## Testing the method

Now that you have a working sign method, it is a good idea to write a set of tests for the method. You can write a new method, say `void test_tfl_sign();` that will call the sign method with a set of pre-defined values and check that the results are correct. The method can use `printf()` to report success or failure. 

You should include the output of this method as a table or appendix in your assignment.

# The exponent method

The exponent is slightly more tricky than the sign and significand methods, because the bits are "inside" the other bits. Try to figure out a way to "extract" the bits that you need and then convert (hint: type cast coversion) into a signed representation.

Once you have the exponent extracted and converted, simply return it. And once again, make sure you write a test method for it. You can perhaps use the same test values as you used for the `tfl_sign()` method.

# The significand method

The significand should be easy now that you managed the two other methods. The function needs to isolate the rightmost bits and return an unsigned value.

Again, once extracted, simply return it. And again, make sure you write a suitable test method.


# Making helper functions

As we will need to verify and test the apperance of the bit sequence repeatedly through this assignment, it is usually a good investment of time to write a small debug function that displays the contents in a human readable manner.

I suggest adding a function such as this:
```c
void debug_print_tfl(tfl16_t value) {
    ... your code here
}
```

The output could be something like:
```
DEBUG: 0 000001 000000000; 1 * 2^1 * 768/1024; 1.5f
```

# Equals

The next method will compare two values. While this is simple enough with the equality operator, we need to make sure that `+0` and `-0` are considered equals. Like with the other methods, think of a strategy, implement it and write a test for it.

# Greater than

The last method in the lab session is the method `tfl_greaterthan(tlf16_t a, tfl16_t b)`. This is, different from the `tfl_equals()` method, as we need to evaluate each of the number parts before we can give a result. 

*A small hint*: you have already implemented methods that extract the number components. No need to re-invent or copy/paste the code when you can simply call the existing methods.

Remember that returning `0` is considered `false` and anything non-zero is considered `true`.

And again, write a method that tests a few comparison methods.

# Wrapping up

You should now have a good basis for learning about C, and implementing the last methods should be within reach. 

Good luck and have fun!
