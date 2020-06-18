#!/bin/bash

###########################################################################################################################
# This script assumes you have your raw datasets downloaded in the folder.
# Running it sets up your directory for the workflow to run.
# It is written specifically for use on Pawsey Supercomputing resources, but can be tailored to other computing resources.
# If required, change the path to your directory and raw reads here:
dir=/group/$PAWSEY_PROJECT/$USER/dunnart
fasta_reads=F1_bull_test.subreads.fasta.gz 
bam_reads=F1_bull_test.subreads.bam
###########################################################################################################################

echo 'Creating .fofn files...'
echo '$dir/${fasta_reads}' > subreads.fasta.fofn &&
echo '$dir/${bam_reads}' > subreads.bam.fofn &&

echo 'Pulling pb-core containers...'
module load singularity &&
singularity pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0