CC=gcc
CFLAGS=-Wall -Wextra -pedantic -pthread -fopenmp -lm -O3
EXECUTABLES=batch-mat-inv

all: $(EXECUTABLES)

batch-mat-inv: batch-mat-inv.o
	$(CC) -o $@ $^ $(CFLAGS)

%.o: %.c
	$(CC) -c $^ $(CFLAGS)

clean:
	rm -f *.o $(EXECUTABLES)
