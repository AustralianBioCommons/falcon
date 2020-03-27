#!/bin/bash

###########################################################################################################################
# This script assumes you have your raw datasets downloaded in the folder, and pulls the Pacific Biosciences containers to run your Falcon commands.
# It is written specifically for use on Pawsey Supercomputing resources, but can be tailored to other computing resources.
# Change the path to your directory and raw reads here:
dir=/group/pawsey0002/astott/dunnart/
fasta_reads=dunnart.subreads.fasta.gz
bam_reads=dunnart.subreads.bam
###########################################################################################################################

git clone https://github.com/audreystott/dunnart.git
cd dunnart
module load singularity
srun singularity pull docker://quay.io/biocontainers/pb-assembly:0.0.8--0
srun singularty pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0
echo '$dir/${fasta_reads}' > subreads.fasta.fofn
echo '$dir/${bam_reads}' > subreads.bam.fofn
