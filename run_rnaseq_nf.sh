nextflow run RNASeq.nf \
    --fastq1 /path/to/forward.fastq \
    --fastq2 /path/to/reverse.fastq \
    --adapters /path/to/adapters.fasta \
    --prefix my_prefix \
    --skewer_threads 4 \
    --minimum_read_length 50 \
    --kallisto_threads 8 \
    --bootstrap_samples 100 \
    --idx /path/to/kallisto/index \
    --gtf /path/to/annotations.gtf \
    --STAR_threads 8 \
    --ref_tar /path/to/reference.tar.gz \
    --ref_flat /path/to/ref_flat.txt \
    --ribosomal_interval /path/to/ribosomal_intervals.bed \
    --ref_seq /path/to/reference.fasta

