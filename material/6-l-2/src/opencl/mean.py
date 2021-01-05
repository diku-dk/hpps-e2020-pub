import numpy as np
import pyopencl as cl
import time
from scipy.ndimage import uniform_filter

# Generate input data
n = np.uint32(42)
m = np.uint32(42)
k = np.uint32(5)
img = np.random.rand(n,m).astype(np.float32)
result = np.zeros((n,m)).astype(np.float32)
result_expected = np.zeros((n,m)).astype(np.float32)

# Compute the expected result using CPU
result_expected = uniform_filter(img, k, mode='constant')

# Create the OpenCL context
context = cl.create_some_context()
queue = cl.CommandQueue(context)

# Allocate device memory
mf = cl.mem_flags
img_device = cl.Buffer(context, mf.READ_ONLY, img.nbytes)
result_device = cl.Buffer(context, mf.WRITE_ONLY, result.nbytes)

# Load and compile the kernel
with open('mean.cl', 'r') as f:
    kernel_source = f.read()
program = cl.Program(context, kernel_source).build()

# Copy input to device
cl.enqueue_copy(queue, img_device, img)

# Execute kernel
program.mean(queue, (n, m), None, img_device, result_device, n, m, k)

# Copy result from device
cl.enqueue_copy(queue, result, result_device)

# Wait for the device
queue.finish()

# Check results
print ('Is correct:', np.isclose(result, result_expected).all())
