#!/bin/bash

#SBATCH --account=$PAWSEY_PROJECT
#SBATCH --partition=workq
#SBATCH --nodes=1
#SBATCH --cpus-per-task=28

unset SBATCH_EXPORT
module load singularity

#set up SSH key
echo | ssh-keygen -P '' -t rsa -f ~/.ssh/pawsey_rsa_key &&
eval "$(ssh-agent -s)" &&
ssh-add ~/.ssh/pawsey_rsa_key &&
cat ~/.ssh/pawsey_rsa_key.pub >> ~/.ssh/authorized_keys &&

#ssh into Zeus from container
singularity pull docker://audreystott/pb-assembly:0.0.8-2 &&
singularity exec -B $HOME,$PWD pb-assembly_0.0.8-2.sif ssh $USER@zeus.pawsey.org.au &&

#submit sbatch script for nextflow run
sbatch --account=$PAWSEY_PROJECT sbatch_nextflow.sh