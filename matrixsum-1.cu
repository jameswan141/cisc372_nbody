#include <iostream>
#include <vector>
#include <stdlib.h>
#include <time.h>
#include <cuda_runtime.h>
#include "kernel.h"
#include "kernel.cu"
#include "compute.h"
#include <math.h>

using namespace std;

int main()
{
    int NUMELEMENTS=10;
    int SIZE=NUMELEMENTS*NUMELEMENTS;

    vector<float> h_i(SIZE);
    vector<float> h_j(SIZE);
    vector<float> h_k(SIZE);

    for (int i=0; i<NUMELEMENTS; i++){
        for (int j=0; j<NUMELEMENTS; j++){
            h_a[i*NUMELEMENTS+j]=sin(i);
            h_b[i*NUMELEMENTS+j]=cos(j);
        }
    }

    compute<float> d_a(SIZE);
    compute<float> d_b(SIZE);
    compute<float> d_c(SIZE);

    d_a.set(&h_a[0], SIZE);
    d_b.set(&h_b[0], SIZE);

    matrixSum(d_a.getData(), d_b.getData(), d_c.getData(), NUMELEMENTS);
    cudaDeviceSynchronize();

    d_c.get(&h_c[0], SIZE);
    cudaDeviceSynchronize();

    float *cpu_c;
    cpu_c=new float[SIZE];

    float sum;
    for (int row=0; row<NUMELEMENTS; row++){
        for (int col=0; col<NUMELEMENTS; col++){
            sum=0.f;
            for (int n=0; n<NUMELEMENTS; n++){
                sum+=h_a[row*NUMELEMENTS+n]*h_b[n*NUMELEMENTS+col];
            }
            cpu_c[row*NUMELEMENTS+col]=sum;
        }
    }

    double err=0;
    for (int ROW=0; ROW<NUMELEMENTS; ROW++){
        for (int COL=0; COL<NUMELEMENTS; COL++){
            err+=cpu_c[ROW*NUMELEMENTS+COL]-h_c[ROW*NUMELEMENTS+COL];
        }
    }

    cout << "Error: " << err << endl;

    return 0;
}
