#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=16
#SBATCH --time=5:00:00

#cutadapt
# SRR25630296
/usr/bin/time -v pixi run cutadapt -j 8 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o SRR25630296_1_cut.fastq.gz -p SRR25630296_2_cut.fastq.gz SRR25630296_1.fastq.gz SRR25630296_2.fastq.gz

# SRR25630382
/usr/bin/time -v pixi run cutadapt -j 8 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o SRR25630382_1_cut.fastq.gz -p SRR25630382_2_cut.fastq.gz SRR25630382_1.fastq.gz SRR25630382_2.fastq.gz

# trimmomatic
# SRR25630296
/usr/bin/time -v pixi run trimmomatic PE -Xmx16g -threads 16 \
SRR25630296_1_cut.fastq.gz SRR25630296_2_cut.fastq.gz \
SRR25630296_1_trimmed.paired.fq.gz SRR25630296_1_trimmed.unpaired.fq.gz \
SRR25630296_2_trimmed.paired.fq.gz SRR25630296_2_trimmed.unpaired.fq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35

# SRR25630382
/usr/bin/time -v pixi run trimmomatic PE -Xmx16g -threads 16 \
SRR25630382_1_cut.fastq.gz SRR25630382_2_cut.fastq.gz \
SRR25630382_1_trimmed.paired.fq.gz SRR25630382_1_trimmed.unpaired.fq.gz \
SRR25630382_2_trimmed.paired.fq.gz SRR25630382_2_trimmed.unpaired.fq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35