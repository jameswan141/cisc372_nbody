#include <math.h>
#include <iostream>
#include "cuda_runtime.h"
#include "kernel.h"
#include <stdlib.h>

using namespace std;

__global__ void matrixSumKernel(float* a, float* b, float* c, int NUMELEMENTS){

    int ROW = blockIdx.y*blockDim.y+threadIdx.y;
    int COL = blockIdx.x*blockDim.x+threadIdx.x;

    float tmpSum=0;

    if (ROW<NUMELEMENTS && COL<NUMELEMENTS){
        for (int i=0; i<NUMELEMENTS; i++) {
            tmpSum+=a[ROW*NUMELEMENTS+i]*b[i*NUMELEMENTS+COL];
        }
    }
    c[ROW*NUMELEMENTS+COL]=tmpSum;
}

void matrixSum(float *a, float *b, float *c, int NUMELEMENTS){

    dim3 threadsPerBlock(NUMELEMENTS, NUMELEMENTS);
    dim3 blocksPerGrid(1, 1);
        if (NUMELEMENTS*NUMELEMENTS>512){
            threadsPerBlock.x=512;
            threadsPerBlock.y=512;
            blocksPerGrid.x=ceil(double(NUMELEMENTS)/double(threadsPerBlock.x));
            blocksPerGrid.y=ceil(double(NUMELEMENTS)/double(threadsPerBlock.y));
        }

    matrixSumKernel<<<blocksPerGrid,threadsPerBlock>>>(a, b, c, NUMELEMENTS);
}
