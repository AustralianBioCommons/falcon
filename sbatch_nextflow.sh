#!/bin/bash

#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28
#SBATCH --time=24:00:00

unset SBATCH_EXPORT
module load nextflow

srun nextflow run main.nf -profile conda
