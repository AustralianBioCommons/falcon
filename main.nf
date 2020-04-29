#!/usr/bin/env nextflow
dir = "user-dir"
fasta_ch = Channel.fromPath('subreads.fasta.fofn')
bam_ch = Channel.fromPath('subreads.bam.fofn')
hic_ch = Channel.fromPath('F1_bull_test.HiC_R*.fastq.gz')

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

process fc_unzip {
    input:
        file x from bam_ch

    output:
        file("3-unzip/*") into unzip
        file("4-polish/*") into polish

    when:
    -e */2-asm-falcon/p_ctg.fa

    script:
        """
        fc_unzip.py $dir/fc_unzip.cfg &> run1.std
        """
}
process fc_phase {

    input:
        file x from hic_ch

    output:
        file("5-phase/*") into phase

    script:
        """
        fc_phase.py $dir/fc_phase.cfg &> run2.std
        """
}
