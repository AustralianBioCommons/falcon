# Falcon on Zeus @ Pawsey Supercomputing Centre

## Accessing tool/workflow

Includes straightforward sign in to Zeus.

## Quickstart tutorial

### Install

The following steps cover installation of the tools required for performing the *de novo* assembly of the Fat-tailed Dunnart genome using Falcon on Pawsey's HPC system Zeus. The original Falcon documentation that this workflow is derived from can be found [here](https://github.com/PacificBiosciences/pb-assembly#tutorial).

### Start an interactive SLURM session

On Zeus, you will need to run your jobs on a work node; to do so, start an interactive session as follows:

    > salloc -n 1 -t 1:00:00

### Clone the Dunnart repository

The Dunnary repository contains the scripts and config files required for running the workflow. Clone it to your current working directory, e.g. /group/$PAWSEY_PROJECT/$USER

    > cd /group/$PAWSEY_PROJECT/$USER
    > git clone https://github.com/AustralianBioCommons/falcon.git
    > cd falcon

### Download your raw sequencing data

You will need both the fasta and bam formats of the raw sequencing data. Download them to your current working directory, which should be the `falcon/` directory.

### Set the fasta and bam filenames in the run script

Ensure the filenames are set in the `falcon-conda.sh` script. Do so by replacing the words `YOUR_FASTA_FILE_NAME` and `YOUR_BAM_FILE_NAME` with your raw filenames for the below commands. 

Note: Your fasta and bam filenames should have a suffix .subreads.fasta.gz and .subreads.bam, respectively.

    > sed -i "s|F1_bull_test.subreads.fasta.gz|YOUR_FASTA_FILE_NAME|g" falcon-conda.sh
    > sed -i "s|F1_bull_test.subreads.bam|YOUR_BAM_FILE_NAME|g" falcon-conda.sh 

### Set the HiC filename in the Nextflow script

Set your HiC filename in the Nextflow `main.nf` script. 

Note: The files should have the suffixes .HiC_R1.fastq.gz and .HiC_R2.fastq.gz.

You will replace the words `YOUR_HIC_FILE_NAME` with your HiC filename for the below. It should look similar to this - `sample1.HiC_R*.fastq.gz`.

    > sed -i "s|F1_bull_test.HiC_R*.fastq.gz|YOUR_HIC_FILE_NAME|g" main.nf

### Set up FALCON

Run the FALCON script falcon-conda.sh.

    > bash falcon-conda.sh    

### Exit the SLURM interactive session

Once the FALCON set up script has completed running, exit the session.

    > exit

### Run FALCON

Run FALCON with the sbatch script as follows:

    > sbatch --account=$PAWSEY_PROJECT sbatch_nextflow.sh

### Check job progress

While FALCON is running, you can check the progress of your jobs.

#### fc_run

Jobs left:
    
    > ls 0-rawreads/daligner-chunks/ | wc -l

Jobs completed:

    > find 0-rawreads/daligner-runs/j_*/uow-00 -name "daligner.done" | wc -l

Stats for reads and pre-assembled reads:

    > singularity exec pb-assembly_0.0.8.sif DBstats 0-rawreads/build/raw_reads.db

    > singularity exec pb-assembly_0.0.8.sif DBstats 1-preads_ovl/build/preads.db 

Check pre-assembly performance:

    > cat 0-rawreads/report/pre_assembly_stats.json

Check assembly performance:

    > python get_asm_stats.py 2-asm-falcon/p_ctg.fasta

#### fc_unzip 

Check haplotype resolution

    > python get_asm_stats.py 3-unzip/all_p_ctg.fasta 

    > python get_asm_stats.py 3-unzip/all_h_ctg.fasta

    > head 3-unzip/all_h_ctg.paf 

Check phase polishing

    > python get_asm_stats.py 4-polish/cns-output/cns_p_ctg.fasta
   
    > python get_asm_stats.py 4-polish/cns-output/cns_h_ctg.fasta


#### fc_phase

See haplotig placement file
   
    > head 5-phase/placement-output/haplotig.placement

See final output stats 

    > python get_asm_stats.py 5-phase/output/phased.0.fasta

    > python get_asm_stats.py 5-phase/output/phased.1.fasta

## Optimisation required

### Note 1
We encountered a bug in the 2-asm_falcon ovlp_filtering stage, where preads.m4 had an erroneous '---' at the end of the file. We fixed this by following this github issue: https://github.com/PacificBiosciences/pbbioconda/issues/294. This step is now automatically taken care of in the nextflow pipeline.

### Note 2
Falcon depends on on the `pbgcpp` package. You might find the software version needs to be changed, depending on the chemistry used for your sequencing. If the `pbgcpp` versions clashes with the sequencing chemisty, you will encounter an error in the `quiver-run` step. Specifically, something along the lines of the following:

```
20211209 03:48:25.313 -|- FATAL -|- Run -|- 0x2af6570cb7c0|| -|- gcpp ERROR: [pbbam] chemistry compatibility ERROR: unsupported sequencing chemistry combination:
    binding kit:        100-862-200
    sequencing kit:     100-861-800
    basecaller version: 4.0.0.189308
See SMRT Link release documentation for details about consumables compatibility or contact PacBio Technical Support.
```

It might not be obvious which version of `pbgcpp` is required. In this case, you can test each version, working backwards from the most recent, until you find which one works. The steps would be as follows:

```
conda activate pb-assembly
conda install -c bioconda pbgcpp=2.0.2
<test falcon unzip; if same error, try rolling back to version>
conda install -c bioconda pbgcpp=2.0.0
<test falcon unzip; if same error, try rolling back to version>
conda install -c bioconda pbgcpp=1.9.0
<test falcon unzip; if same error, try rolling back to version>
conda install -c bioconda pbgcpp=1.0.0
```

## Infrastructure usage and benchmarking

### Summary
Falcon works best on smaller genomes, less than 0.7Gbp. Below this size, it tends to run with a reasonable wall time (<24 hours) and creates <500,000 small intermediate files for the fc_run and fc_unzip steps combined. Falcon struggled with larger reference datasets due to either exeeding the file number limit on the /scratch partition (1,000,000 file limit per user at Pawsey), or taking too long to perform each step and therefore having a total job time that would run into weeks or months. This appears to be linked to the inefficiency of reading and writing such a large number of small files. Hi-Fi data is meant to reduce some of the computational overhead and may therefore allow Falcon to be used for larger genomes. This remains to be tested in our hands, as of Jan 2022. 

### Exemplar 1: *halobacterium salinarum*, 28 cores, 112GB memory, fc_run and fc_unzip steps combined

| Parameter | Data |
|--------|----------|
| Genome size | 2571010 |
| Wall time | 11:00:36 |
| CPU time | 23:55:06 |
| Memory Efficiency |  100.61% of 112.00 GB |

### Exemplar 2: *Saccharomyces cerevisiae*, yeast 28 cores, 112GB memory, fc_run and fc_unzip steps combined

| Parameter | Data |
|--------|----------|
| Genome size | 12000000 |
| Wall time | 01:46:50 |
| CPU time | 03:54:12|
| Memory Efficiency | 97.44% of 112.00 GB |

### Exemplar 3: *Anabas testudineus*, climbing perch, 28 cores, 112GB memory, fc_run and fc_unzip steps combined

| Parameter | Data |
|--------|----------|
| Genome size | 660000000 |
| Wall time | 09:52:33 |
| CPU time | 3-13:28:05 |
| Memory Efficiency | 21.53% of 112 GB |
| Number of files produced | 485,086 |

## Acknowledgements / citations / credits
