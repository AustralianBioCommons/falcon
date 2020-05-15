#!/bin/bash

###########################################################################################################################
# This script assumes you have your raw datasets downloaded in the folder.
# Running it pulls the Pacific Biosciences containers to run your Falcon commands, and sets up your directory for the workflow to run.
# It is written specifically for use on Pawsey Supercomputing resources, but can be tailored to other computing resources.
# Change the path to your directory and raw reads here:
dir=user-dir-path
fasta_reads=dunnart-fasta
bam_reads=dunnart-bam
###########################################################################################################################

Pulling PacBio pb-assembly and pb-core containers...
sbatch --account=$PAWSEY_PROJECT sbatch_singularity.sh &&

Creating .fofn files...
echo '$dir/${fasta_reads}' > subreads.fasta.fofn &&
echo '$dir/${bam_reads}' > subreads.bam.fofn &&

Assigning directory for Nextflow...
sed -i "s|user-dir|${dir}|g" main.nf &&

Running FALCON via Nextflow...
sbatch --account=$PAWSEY_PROJECT sbatch_nextflow.sh
