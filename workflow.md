# Falcon workflow (WIP)
This workflow covers the steps required for performing de novo assembly of the fat-tailed Dunnart genome using Falcon on Pawsey's HPC system Zeus. The original Falcon documentation that this workflow is derived from can be found [here](https://github.com/PacificBiosciences/pb-assembly#tutorial).

## Download raw sequencing data

Create a directory for the workflow, then download the raw reads in their fasta and bam formats.

    mkdir falcon-dunnart
    cd falcon-dunnart

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

## Run FALCON

Run the sbatch_run.sh script for a SLURM srun job. This script will execute the first Falcon command, which is performed using the `pb-assembly_0.0.8--0.sif` container.

    >sbatch sbatch_run.sh

sbatch_run.sh:

    #!/bin/bash

    #SBATCH --account=pawsey0002
    #SBATCH --partition=workq
    #SBATCH --nodes=2
    #SBATCH --cpus-per-task=28

    module load singularity

    srun singularity exec pb-assembly_0.0.8--0.sif fc_run fc_run.cfg 
    

### Check job progress

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

## Run FALCON-Unzip

Run the sbatch_unzip.sh script for a SLURM srun job.

    >sbatch sbatch_unzip.sh

sbatch_unzip.sh:
    #!/bin/bash

    #SBATCH --account=pawsey0002
    #SBATCH --partition=workq
    #SBATCH --nodes=2
    #SBATCH --cpus-per-task=28

    module load singularity

    // to ensure log file from fc_run is not overwritten by this step
    mv all.log all0.log

    srun singularity exec pb-assembly_0.0.8--0.sif fc_unzip.py fc_unzip.cfg &> run1.std

### Check haplotype resolution

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 3-unzip/all_p_ctg.fa 

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 3-unzip/all_h_ctg.fa

    >head 3-unzip/all_h_ctg.paf 

### Check phase polishing

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 4-polish/cns-output/cns_p_ctg.fasta
   
    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 4-polish/cns-output/cns_h_ctg.fasta

## Run FALCON-Phase

Run the sbatch_phase.sh script for a SLURM srun job.

    >sbatch sbatch_phase.sh

sbatch_phase.sh:
    #!/bin/bash

    #SBATCH --account=pawsey0002
    #SBATCH --partition=workq
    #SBATCH --nodes=2
    #SBATCH --cpus-per-task=28

    module load singularity

    // to ensure log file from fc_run is not overwritten by this step
    mv all.log all1.log

    srun singularity exec pb-assembly_0.0.8--0.sif fc_phase.py fc_phase.cfg &> run2.std

### See haplotig placement file
   
    >head 5-phase/placement-output/haplotig.placement

### See final output stats 

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 5-phase/output/phased.0.fasta

    >singularity exec pbcore_1.7.1--py27_0.sif python pb-assembly/scripts/get_asm_stats.py 5-phase/output/phased.1.fasta 
