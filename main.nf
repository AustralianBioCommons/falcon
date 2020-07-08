#!/usr/bin/env nextflow
fasta_ch1 = Channel.fromPath('subreads.fasta.fofn')
fasta_ch2 = Channel.fromPath('subreads.fasta.fofn')
fasta_ch3 = Channel.fromPath('subreads.fasta.fofn')
bam_ch = Channel.fromPath('subreads.bam.fofn')
hic_ch = Channel.fromPath('F1_bull_test.HiC_R*.fastq.gz')
dir = "/group/$PAWSEY_PROJECT/$USER/dunnart/"

process fc_run {
    publishDir "${dir}"

    input:
        file x from fasta_ch1

    output:
        file("0-rawreads/") into (rawreads1, rawreads2)
        file("1-preads_ovl/") into (preads1, preads2)
        file("2-asm-falcon/") into (asm1, asm2)

    script:
        """
        sed -i "s/outs.write('/#outs.write('/" ${dir}/nf-work/conda/*/lib/python3.7/site-packages/falcon_kit/mains/ovlp_filter.py
        fc_run /group/$PAWSEY_PROJECT/$USER/dunnart/fc_run.cfg
        """
}

process fc_unzip {
    publishDir "${dir}"

    input:
        file x from rawreads1
        file x from preads1
        file x from asm1
        file x from bam_ch
        file x from fasta_ch2

    output:
        file("3-unzip/*") into unzip
        file("4-polish/*") into polish

    script:
        """
        fc_unzip.py /group/$PAWSEY_PROJECT/$USER/dunnart/fc_unzip.cfg &> run1.std
        """
}
process fc_phase {
    publishDir "${dir}"
    
    input:
        file x from rawreads2
        file x from preads2
        file x from asm2
        file("3-unzip/") from unzip
        file("4-polish/") from polish
        file x from hic_ch
        file x from fasta_ch3
    
    output:
        file("5-phase/*") into phase

    script:
        """
        fc_phase.py /group/$PAWSEY_PROJECT/$USER/dunnart/fc_phase.cfg &> run2.std
        """
}
