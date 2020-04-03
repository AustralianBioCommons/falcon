# Falcon workflow (WIP)
This workflow covers the steps required for performing de novo assembly of the fat-tailed Dunnart genome using Falcon on Pawsey's HPC system Zeus. The original Falcon documentation that this workflow is derived from can be found [here](https://github.com/PacificBiosciences/pb-assembly#tutorial).

## Download raw sequencing data

You will need both the fasta and bam formats of the raw sequencing data. Download them to  your current working directory.

## Clone the Dunnart repository

This directory contains the scripts and config files required for running the workflow. Clone it to your current working directory.

    >git clone https://github.com/audreystott/dunnart.git

## Set the variables in the run script

In the cloned repository, you will find a run script `falcon.sh`. You will need to set the variables for your directory and sequencing reads. 

    >cd dunnart
    >pwd

In the following command, replace the words `path/to/your/directory` with the dunnart directory, then run it:

    >sed -i "s|user-dir-path|path/to/your/directory|g" falcon.sh

## Run FALCON

Run the FALCON script falcon.sh. This script covers all the steps required in the FALCON pipeline for fc_run, fc_unzip, and fc_phase.

    >bash falcon.sh    

### Check job progress

Meanwhile you can check the progress of the jobs.

#### fc_run

Jobs left:
    
    >ls 0-rawreads/daligner-chunks/ | wc -l

Jobs completed:

    >find 0-rawreads/daligner-runs/j_*/uow-00 -name "daligner.done" | wc -l

Stats for reads and pre-assembled reads:

    >singularity exec pb-assembly_0.0.8--0.sif DBstats raw_reads.db

    >singularity exec pb-assembly_0.0.8--0.sif DBstats 1-preads_ovl/build/preads.db 

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