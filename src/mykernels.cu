#include <stdio.h>
#include <cuda_runtime.h>

__global__ void k_square(float *a,
                         int numElements)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < numElements) {
    a[i] = a[i] * a[i];
  }
}


extern "C" void square(float *a,
                       int numElements)
{

  cudaError_t err = cudaSuccess;

  int threadsPerBlock = 256;
  int blocksPerGrid = (numElements + threadsPerBlock - 1) / threadsPerBlock;
  printf("CUDA kernel launch with %d blocks of %d threads\n", blocksPerGrid,
         threadsPerBlock);
  k_square<<<blocksPerGrid, threadsPerBlock>>>(a, numElements);
  err = cudaGetLastError();
  cudaDeviceSynchronize();

  if (err != cudaSuccess)
    printf("Something bad happened !\n");
}