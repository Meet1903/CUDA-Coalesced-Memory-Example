// This Kernel adds two Vectors A and B in C on GPU
// using coalesced memory access.

__global__ void AddVectors(const float *A, const float *B, float *C, int N)
{
    int threadIndex = threadIdx.x + blockIdx.x * blockDim.x;
    int totalThreads = blockDim.x * gridDim.x;
    int i;
    for (i = threadIndex; i < totalThreads * N; i = i + totalThreads) {
        C[i] = A[i] + B[i];
    }
}
