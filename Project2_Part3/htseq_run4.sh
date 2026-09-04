#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=8
#SBATCH --time=10:00:00

set -e # Stop task when error is encountered

DATA=/projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3
SAM_296=$DATA/SRR25630296_alignment/SRR25630296.aligned.samAligned.out.sam
SAM_382=$DATA/SRR25630382_alignment/SRR25630382.aligned.samAligned.out.sam


# SRR25630382 reverse stranded 
/usr/bin/time -v pixi run htseq-count --format=sam --stranded=reverse --mode=union --idattr=Parent $SAM_382 $DATA/campylomormyrus.gff > SRR25630382.rev.tsv