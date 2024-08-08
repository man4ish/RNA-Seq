#!/usr/bin/env nextflow

nextflow.enable.dsl2

// Define the processes
process trim {
    tag "$prefix"
    input:
    path fastq1
    path fastq2
    path adapters
    val prefix
    val skewer_threads
    val minimum_read_length

    output:
    path "${prefix}-trimmed-pair1.fastq" into trimmed_pair1
    path "${prefix}-trimmed-pair2.fastq" into trimmed_pair2

    script:
    """
    set -exo pipefail
    skewer -t ${skewer_threads} -y ${adapters} -l ${minimum_read_length} ${fastq1} ${fastq2} -o ${prefix}
    """
    container 'docker.io/man4ish/rnaseq:latest'
}

process quantification {
    tag "$base"
    input:
    path fastq1
    path fastq2
    path idx
    path gtf
    val kallisto_threads
    val bootstrap_samples

    output:
    path "${base}_kallisto_output.tar.gz" into kallisto_output

    script:
    """
    set -exo pipefail
    mkdir ${base}_output
    /software/utils/kallisto quant -t ${kallisto_threads} -b ${bootstrap_samples} --rf-stranded --genomebam -i ${idx} -g ${gtf} ${fastq1} ${fastq2} -o ${base}_output
    tar -cvzf ${base}_kallisto_output.tar.gz ${base}_output
    """
    container 'docker.io/man4ish/rnaseq:latest'
}

process align {
    tag "$base"
    input:
    path ref_tar
    path fastq1
    path fastq2
    val STAR_threads

    output:
    path "${base}_sample.bam" into aligned_bam

    script:
    """
    set -exo pipefail
    mkdir ref_bundle
    tar -xzf ${ref_tar} -C ref_bundle --no-same-owner
    ref_path=\$(realpath ref_bundle)
    mv ref_bundle/*/* ref_bundle
    /software/utils/STAR --genomeDir ${ref_path} --runThreadN ${STAR_threads} --outSAMtype BAM Unsorted --readFilesIn ${fastq1} ${fastq2} --outFileNamePrefix ${base}_sample
    cp ${base}_sampleAligned.out.bam ${base}_sample.bam
    """
    container 'docker.io/man4ish/rnaseq:latest'
}

process sort_index {
    tag "$base"
    input:
    path bam_file

    output:
    path "sorted_${base}" into sorted_bam
    path "sorted_${base}.bai" into sorted_bam_index

    script:
    """
    set -exo pipefail
    samtools sort ${bam_file} > sorted_${base}
    samtools index sorted_${base}
    """
    container 'docker.io/man4ish/rnaseq:latest'
}

process gen_summary {
    tag "$base"
    input:
    path bam_file
    path ref_flat
    path ribosomal_interval
    path ref_seq

    output:
    path "${base}.rna.summary" into summary_file
    path "${base}_position.vs.coverage.plot.pdf" into coverage_plot

    script:
    """
    set -exo pipefail
    java -jar /software/utils/picard.jar CollectRnaSeqMetrics METRIC_ACCUMULATION_LEVEL=ALL_READS \
        REF_FLAT=${ref_flat} RIBOSOMAL_INTERVALS=${ribosomal_interval} \
        STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND \
        CHART_OUTPUT=${base}_position.vs.coverage.plot.pdf \
        INPUT=${bam_file} OUTPUT=${base}.rna.summary \
        REFERENCE_SEQUENCE=${ref_seq} VALIDATION_STRINGENCY=LENIENT
    """
    container 'docker.io/man4ish/rnaseq:latest'
}

// Define the workflow
workflow Rnaseq {
    input:
    path fastq1
    path fastq2
    path adapters
    val skewer_threads
    val minimum_read_length
    val prefix

    val kallisto_threads
    val bootstrap_samples
    path idx
    path gtf

    val STAR_threads
    path ref_tar

    path ref_flat
    path ribosomal_interval
    path ref_seq

    trimmed_pair1, trimmed_pair2 = trim(fastq1: fastq1, fastq2: fastq2, adapters: adapters, prefix: prefix, skewer_threads: skewer_threads, minimum_read_length: minimum_read_length)
    kallisto_output = quantification(fastq1: trimmed_pair1, fastq2: trimmed_pair2, kallisto_threads: kallisto_threads, bootstrap_samples: bootstrap_samples, idx: idx, gtf: gtf)
    aligned_bam = align(fastq1: trimmed_pair1, fastq2: trimmed_pair2, STAR_threads: STAR_threads, ref_tar: ref_tar)
    sorted_bam, sorted_bam_index = sort_index(bam_file: aligned_bam)
    summary_file, coverage_plot = gen_summary(bam_file: sorted_bam, ref_flat: ref_flat, ribosomal_interval: ribosomal_interval, ref_seq: ref_seq)
}

