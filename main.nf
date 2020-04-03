#!/usr/bin/env nextflow
dir = "user-dir"
fasta_ch = Channel.fromPath('subreads.fasta.fofn')
//params.bam_ch = '${dir}/subreads.bam.fofn'
//params.hic_ch = '${dir}/F1_bull_test.HiC_R*.fastq.gz'
//params.run_ch = '${dir}/fc_run.cfg'

//fasta_ch = file(params.fasta_ch)
//bam_ch = file(params.bam_ch)
//hic_ch = file(params.hic_ch)
//run_ch = file(params.run_ch)

process fc_run {
    input:
        file x from fasta_ch

    output:
        file("0-rawreads/*") into rawreads
        file("1-preads_ovl/*") into preads
        file("2-asm-falcon/*") into asm

    script:
        """
        fc_run $dir/fc_run.cfg
        """
}


//fc_unzip.py fc_unzip.cfg &> run1.std
//fc_phase.py fc_phase.cfg &> run2.std