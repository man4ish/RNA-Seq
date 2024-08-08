#!/bin/bash

# Define input parameters
FASTQ1="/path/to/forward.fastq"
FASTQ2="/path/to/reverse.fastq"
ADAPTERS="/path/to/adapters.fasta"
PREFIX="my_prefix"
SKEWER_THREADS=4
MINIMUM_READ_LENGTH=50
KALLISTO_THREADS=8
BOOTSTRAP_SAMPLES=100
IDX="/path/to/kallisto/index"
GTF="/path/to/annotations.gtf"
STAR_THREADS=8
REF_TAR="/path/to/reference.tar.gz"
REF_FLAT="/path/to/ref_flat.txt"
RIBOSOMAL_INTERVAL="/path/to/ribosomal_intervals.bed"
REF_SEQ="/path/to/reference.fasta"

# Run Nextflow pipeline with specified parameters
nextflow run RNASeq.nf \
    --fastq1 "$FASTQ1" \
    --fastq2 "$FASTQ2" \
    --adapters "$ADAPTERS" \
    --prefix "$PREFIX" \
    --skewer_threads "$SKEWER_THREADS" \
    --minimum_read_length "$MINIMUM_READ_LENGTH" \
    --kallisto_threads "$KALLISTO_THREADS" \
    --bootstrap_samples "$BOOTSTRAP_SAMPLES" \
    --idx "$IDX" \
    --gtf "$GTF" \
    --STAR_threads "$STAR_THREADS" \
    --ref_tar "$REF_TAR" \
    --ref_flat "$REF_FLAT" \
    --ribosomal_interval "$RIBOSOMAL_INTERVAL" \
    --ref_seq "$REF_SEQ"


