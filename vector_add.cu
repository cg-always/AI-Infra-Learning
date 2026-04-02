#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>

__global__ void add(int *a, int *b, int *c, int n) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if (idx < n) c[idx] = a[idx] + b[idx];
}

int main() {
    int n = 100;
    int *a, *b, *c;
    size_t size = n * sizeof(int);

    // 分配主机内存
    a = (int*)malloc(size);
    b = (int*)malloc(size);
    c = (int*)malloc(size);

    // 初始化数组
    for (int i = 0; i < n; ++i) {
        a[i] = i;
        b[i] = i * 2;
    }

    // 分配设备内存
    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, size);
    cudaMalloc(&d_b, size);
    cudaMalloc(&d_c, size);

    // 拷贝数据到设备
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    // 启动 kernel
    int threadsPerBlock = 256;
    int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;
    add<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, n);

    // 拷贝结果回主机
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // 打印前10个结果验证
    for (int i = 0; i < 10; ++i) {
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }

    // 释放内存
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);

    return 0;
}