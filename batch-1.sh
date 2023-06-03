#!/bin/bash -l
#SBATCH --job-name=compute.c
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
#SBATCH --output compute.c-job_%j.out
#SBATCH --error compute.c-job_%j.err
#SBATCH --partition=gpu-v100

# Start my application
srun compute.c
