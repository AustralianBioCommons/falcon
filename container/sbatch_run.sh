#!/bin/bash

#SBATCH --account=pawsey0002
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

module load singularity
module load nextflow

nextflow run main.nf -profile zeus