#!/bin/bash

###########################################################################################################################
# This script assumes you have your raw datasets downloaded in the folder.
# Running it downloads and installs Conda to run your Falcon commands, and sets up your directory for the workflow to run.
# It is written specifically for use on Pawsey Supercomputing resources, but can be tailored to other computing resources.
# If required, change the path to your directory and raw reads here:
dir=/group/$PAWSEY_PROJECT/$USER/falcon
fasta_reads=F1_bull_test.subreads.fasta.gz 
bam_reads=F1_bull_test.subreads.bam
###########################################################################################################################

echo 'Creating .fofn files...'
echo '$dir/${fasta_reads}' > subreads.fasta.fofn
echo '$dir/${bam_reads}' > subreads.bam.fofn

echo 'Pulling pb-core containers...'
module load singularity
singularity pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0

echo 'Downloading Miniconda3 from Anaconda repo...'
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

echo '********************************************************************************************************

R E A D    T H I S   

Installation of Miniconda3 will begin soon...
Follow the prompts... 
Press ENTER... 
Accept license terms...
Make sure to install to /group/$PAWSEY_PROJECT/miniconda3, not /home/$USER/miniconda3
Say yes to running conda init...

********************************************************************************************************'

bash Miniconda3-latest-Linux-x86_64.sh
echo 'Miniconda3 installation done... removing Miniconda3-latest-Linux-x86_64.sh...'
rm Miniconda3-latest-Linux-x86_64.sh

echo '********************************************************************************************************
Falcon set up is complete'
