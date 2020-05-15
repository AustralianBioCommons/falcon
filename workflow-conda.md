# Falcon workflow
This workflow covers the steps required for performing de novo assembly of the fat-tailed Dunnart genome using Falcon on Pawsey's HPC system Zeus. The original Falcon documentation that this workflow is derived from can be found [here](https://github.com/PacificBiosciences/pb-assembly#tutorial).

## Clone the Dunnart repository

This directory contains the scripts and config files required for running the workflow. Clone it to your current working directory, e.g. /group/$PAWSEY_PROJECT/$USER

    >cd /group/$PAWSEY_PROJECT/$USER
    >git clone https://github.com/audreystott/dunnart.git
    >cd dunnart

## Download your raw sequencing data

You will need both the fasta and bam formats of the raw sequencing data. Download them to  your current working directory, which should be the `dunnart/` directory.

## Set the variables in the run script

In the cloned repository, you will find a run script `falcon-conda.sh`. You will need to replace the words `your-fasta-file-name` and `your-bam-file-name` with your raw file names. Your fasta and bam file names should have a suffix .subreads.fasta.gz and .subreads.bam, respectively.

    >sed -i "s|dunnart-fasta|your-fasta-file-name|g" falcon-conda.sh
    >sed -i "s|dunnart-bam|your-bam-file-name|g" falcon-conda.sh 

## Run FALCON

Run the FALCON script falcon-conda.sh. This script covers all the steps required in the FALCON pipeline for fc_run, fc_unzip, and fc_phase.

    >bash falcon-conda.sh    

### Check job progress

Meanwhile you can check the progress of your jobs.

#### fc_run

Jobs left:
    
    >ls 0-rawreads/daligner-chunks/ | wc -l

Jobs completed:

    >find 0-rawreads/daligner-runs/j_*/uow-00 -name "daligner.done" | wc -l

Stats for reads and pre-assembled reads:

    >singularity exec pb-assembly_0.0.8.sif DBstats raw_reads.db

    >singularity exec pb-assembly_0.0.8.sif DBstats 1-preads_ovl/build/preads.db 

Check pre-assembly performance:

    >cat 0-rawreads/report/pre_assembly_stats.json

Check assembly performance:

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 2-asm-falcon/p_ctg.fasta

#### fc_unzip 

Check haplotype resolution

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 3-unzip/all_p_ctg.fa 

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 3-unzip/all_h_ctg.fa

    >head 3-unzip/all_h_ctg.paf 

Check phase polishing

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 4-polish/cns-output/cns_p_ctg.fasta
   
    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 4-polish/cns-output/cns_h_ctg.fasta


#### fc_phase

See haplotig placement file
   
    >head 5-phase/placement-output/haplotig.placement

See final output stats 

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 5-phase/output/phased.0.fasta

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 5-phase/output/phased.1.fasta 
