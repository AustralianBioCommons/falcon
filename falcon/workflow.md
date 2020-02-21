# Falcon workflow (WIP)
This workflow documents the steps required for performing de novo assembly of the fat-tailed Dunnart genome using Falcon on Pawsey's HPC system Zeus.

## Download data

Create a directory for the workflow, then download the raw reads in their fasta and bam formats.

    mkdir falcon-dunnart

## Pull PacBio containers

Using the Singularity container engine, pull PacBio's [pb-assembly (v0.0.8--0)](https://quay.io/repository/biocontainers/pb-assembly?tab=info) and [pbcore (v1.7.1--py27_0)](https://quay.io/repository/biocontainers/pbcore) containers from Biocontainers:

    >module load singularity
    >singularity pull docker://quay.io/biocontainers/pb-assembly:0.0.8--0
    >singularity pull docker://quay.io/biocontainers/pbcore:1.7.1--py27_0

Git clone the PacBio repository that contains some files and scripts needed later:

    >git clone https://github.com/PacificBiosciences/pb-assembly.git

## Create .fofn files and modify config files

Create the files `subreads.fasta.fofn` and `subreads.bam.fofn`, which should contain the path for the raw reads. E.g.:

    >cat subreads.fasta.fofn
    path/to/raw_reads.subreads.fasta.gz

    >cat subreads.bam.fofn
    path/to/raw_reads.subreads.bam

Copy the following default config files from the pb-assembly directory to your workflow directory, then modify them to suit:

    >cp pb-assembly/cfgs/fc_phase.cfg pb-assembly/cfgs/fc_unzip.cfg .
    >cp pb-assembly/cfgs/fc_run_human.cfg fc_run.cfg

Once they are modified accordingly, Falcon can then be run.

## Run the first Falcon command

Create an sbatch script for a SLURM srun job. This script will include the first Falcon command, which is run using the `pb-assembly_0.0.8--0.sif` container.

For example:

    #!/bin/bash

    #SBATCH --account=pawsey0002
    #SBATCH --partition=workq
    #SBATCH --nodes=2
    #SBATCH --cpus-per-task=28

    module load singularity

    srun singularity exec pb-assembly_0.0.8--0.sif fc_run fc_run.cfg 
    

### Check job progress

Jobs left:

Jobs completed:

Stats for reads and pre-assembled reads:

Check pre-assembly performance:

Check assembly performance:

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 2-asm-falcon/p_ctg.fasta