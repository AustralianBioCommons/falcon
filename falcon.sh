#!/bin/bash

###########################################################################################################################
# This script assumes you have your raw datasets downloaded in the folder.
# Running it pulls the Pacific Biosciences containers to run your Falcon commands, and sets up your directory for the workflow to run.
# It is written specifically for use on Pawsey Supercomputing resources, but can be tailored to other computing resources.
# Change the path to your directory and raw reads here:
dir=/group/pawsey0002/astott/dunnart/
fasta_reads=dunnart.subreads.fasta.gz
bam_reads=dunnart.subreads.bam
###########################################################################################################################

Moving raw sequencing files to dunnart/...
mv ${fasta_reads} ${bam_reads} dunnart/

Changing directory to dunnart/...
cd dunnart

Loading the Singularity module...
module load singularity

Pulling PacBio pb-assembly and pb-core containers...
srun singularity pull docker://marcodelapierre/pb-assembly:0.0.8
srun singularty pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0

Creating .fofn files...
echo '$dir/${fasta_reads}' > subreads.fasta.fofn
echo '$dir/${bam_reads}' > subreads.bam.fofn

Assigning directory for Nextflow...
sed -i "s|user-dir|${dir}|g" main.nf

Loading the Nextflow module...
module load Nextflow

Running FALCON via Nextflow...
nextflow run main.nf -profile zeus
