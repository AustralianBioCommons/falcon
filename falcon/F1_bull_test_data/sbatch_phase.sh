#!/bin/bash

#SBATCH --account=pawsey0002
#SBATCH --partition=workq
#SBATCH --nodes=2
#SBATCH --cpus-per-task=28

module load singularity

// to ensure log file from fc_unzip is not overwritten by this step
mv all.log all1.log

srun singularity exec pb-assembly_0.0.8--0.sif fc_phase.py fc_phase.cfg &> run2.std
