#include <stdlib.h>
#include <math.h>
#include "vector.h"
#include "config.h"

void compute()
#pragma acc kernel
{
	int i,j,k;
	vector3* values=(vector3*)malloc(sizeof(vector3)*NUMELEMENTS*NUMELEMENTS);
	vector3** accels=(vector3**)malloc(sizeof(vector3*)*NUMELEMENTS);
	#pragma acc parallel loop
	for (i=0;i<NUMELEMENTS;i++)
		accels[i]=&values[i*NUMELEMENTS];
	#pragma acc parallel loop collapse(2)
	for (i=0;i<NUMELEMENTS;i++){
		for (j=0;j<NUMELEMENTS;j++){
			if (i==j){
				FILL_VECTOR(accels[i][j],0,0,0);
			}
			else{
				vector3 distance;
				for (k=0;k<3;k++) distance[k]=hPos[i][k]-hPos[j][k];
				double magnitude_sq=distance[0]*distance[0]+distance[1]*distance[1]+distance[2]*distance[2];
				double magnitude=sqrt(magnitude_sq);
				double accelmag=-1*GRAV_CONSTANT*mass[j]/magnitude_sq;
				FILL_VECTOR(accels[i][j],accelmag*distance[0]/magnitude,accelmag*distance[1]/magnitude,accelmag*distance[2]/magnitude);
			}
		}
	}
	#pragma acc parallel loop
	for (i=0;i<NUMELEMENTS;i++){
		vector3 accel_sum={0,0,0};
		#pragma acc parallel loop collapse(2)
		for (j=0;j<NUMELEMENTS;j++){
			#pragma acc parallel loop reductions(sum, accel_sum[j])
			for (k=0;k<3;k++)
				accel_sum[k]+=accels[i][j][k];
		}
		#pragma acc parallel loop
		for (k=0;k<3;k++){
			#pragma acc atomic update
			hVel[i][k]+=accel_sum[k]*INTERVAL;
			hPos[i][k]=hVel[i][k]*INTERVAL;
		}
	}
	free(accels);
	free(values);
}
