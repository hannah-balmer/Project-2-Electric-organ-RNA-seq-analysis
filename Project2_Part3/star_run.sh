#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00

set -e # Stop task when error is encountered

DATA=/projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part3
CAMP=$DATA/camp_db
SRR=/projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/srr_data


# gff to gtf comversion
/usr/bin/time -v pixi run agat_convert_sp_gff2gtf.pl --gff $DATA/campylomormyrus.gff -o $DATA/campylomormyrus.gtf

# generate STAR db from gtf and fasta file
/usr/bin/time -v pixi run STAR \
 --runThreadN 16 \
 --runMode genomeGenerate \
 --genomeDir $CAMP \
 --genomeFastaFiles $DATA/campylomormyrus.fasta \
 --sjdbGTFfile $DATA/campylomormyrus.gtf

# Alignment for SRR25630296
/usr/bin/time -v pixi run STAR \
 --runThreadN 16 \
 --runMode alignReads \
 --outFilterMultimapNmax 3 \
 --outSAMunmapped Within KeepPairs \
 --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
 --readFilesCommand zcat \
 --readFilesIn $SRR/SRR25630296_1_trimmed.paired.fq.gz $SRR/SRR25630296_2_trimmed.paired.fq.gz \
 --genomeDir $CAMP \
 --outFileNamePrefix SRR25630296.aligned.sam

# Alignment for SRR25630382
/usr/bin/time -v pixi run STAR \
 --runThreadN 16 \
 --runMode alignReads \
 --outFilterMultimapNmax 3 \
 --outSAMunmapped Within KeepPairs \
 --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
 --readFilesCommand zcat \
 --readFilesIn $SRR/SRR25630382_1_trimmed.paired.fq.gz $SRR/SRR25630382_2_trimmed.paired.fq.gz \
 --genomeDir $CAMP \
 --outFileNamePrefix SRR25630382.aligned.sam

 