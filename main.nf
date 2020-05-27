#!/usr/bin/env nextflow
fasta_ch = Channel.fromPath('subreads.fasta.fofn')
bam_ch = Channel.fromPath('subreads.bam.fofn')
hic_ch = Channel.fromPath('F1_bull_test.HiC_R*.fastq.gz')

process fc_run {
    publishDir "${dir}"

    input:
        file x from fasta_ch

    output:
        file("0-rawreads/*") into rawreads
        file("1-preads_ovl/*") into preads
        file("2-asm-falcon/*") into asm

    script:
        """
        source /group/$PAWSEY_PROJECT/$USER/miniconda3/bin/activate
        fc_run /group/$PAWSEY_PROJECT/$USER/dunnart/fc_run.cfg
        """
}

process fc_unzip {
    publishDir "${dir}"

    input:
        file x from bam_ch
        file '2-asm-falcon/all_h_ctg.fa' from asm

    output:
        file("3-unzip/*") into unzip
        file("4-polish/*") into polish

    script:
        """
        source /group/$PAWSEY_PROJECT/$USER/miniconda3/bin/activate
        fc_unzip.py /group/$PAWSEY_PROJECT/$USER/dunnart/fc_unzip.cfg &> run1.std
        """
}
process fc_phase {
    publishDir "${dir}"
    
    input:
        file x from hic_ch
        file '4-polish/cns_h_ctg.fasta' from polish
    
    output:
        file("5-phase/*") into phase

    script:
        """
        source /group/$PAWSEY_PROJECT/$USER/miniconda3/bin/activate
        fc_phase.py /group/$PAWSEY_PROJECT/$USER/dunnart/fc_phase.cfg &> run2.std
        """
}
