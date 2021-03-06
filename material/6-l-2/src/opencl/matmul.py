import numpy as np
import pyopencl as cl
import time

# Generate input data
n = np.uint32(42)
m = np.uint32(42)
k = np.uint32(42)
a = np.random.rand(n,k).astype(np.float32)
b = np.random.rand(k,m).astype(np.float32)
c = np.zeros((n,m)).astype(np.float32)
c_expected = np.zeros((n,m)).astype(np.float32)

# Compute the expected result using CPU
c_expected = np.matmul(a,b)

# Create the OpenCL context
context = cl.create_some_context()
queue = cl.CommandQueue(context)

# Allocate device memory
mf = cl.mem_flags
a_device = cl.Buffer(context, mf.READ_ONLY, a.nbytes)
b_device = cl.Buffer(context, mf.READ_ONLY, b.nbytes)
c_device = cl.Buffer(context, mf.WRITE_ONLY, c.nbytes)

# Load and compile the kernel
with open('matmul.cl', 'r') as f:
    kernel_source = f.read()
program = cl.Program(context, kernel_source).build()

# Copy input to device
cl.enqueue_copy(queue, a_device, a)
cl.enqueue_copy(queue, b_device, b)

# Execute kernel
program.matmul(queue, c.shape, None, a_device, b_device, c_device, n, k, m)

# Copy result from device
cl.enqueue_copy(queue, c, c_device)

# Wait for the device
queue.finish()

# Check results
print ('Is correct:', np.isclose(c, c_expected).all())
