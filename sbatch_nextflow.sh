#!/bin/bash

#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

unset SBATCH_EXPORT
module load singularity
module load nextflow

srun nextflow run main.nf -profile zeus