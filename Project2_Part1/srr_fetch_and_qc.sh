#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=8

#sbatch srr_fetch_and_qc.sh

prefetch SRR25630296
fasterq-dump SRR25630296

prefetch SRR25630382
fasterq-dump SRR25630382

fastqc SRR*.fastq