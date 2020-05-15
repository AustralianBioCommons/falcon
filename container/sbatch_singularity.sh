#!/bin/bash

#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

module load singularity

srun singularity pull docker://marcodelapierre/pb-assembly:0.0.8
srun singularity pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0