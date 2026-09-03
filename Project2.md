# Lab_Notebook_Bi623_Project2
 
**Start date: August 27, 2026**

**Repository:** /projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/
 
---

## Project Overview
 
**Objective:**


---


## Environment & Reproducibility
 
| Item | Details |
|---|---|
| OS | Windows 11 |
| Compute resource | Talapas HPCC |
| Package manager | Pixi |
| Environment file location | Project-2-Electric-organ-RNA-seq-analysis/pixi.toml |
| fastqc Version | 0.12.1 |
| cutadapt Version | 5.2 |
| trimmomatic Version | 0.41 |
| sra-tools Version | 3.4.1 |
| samtools Version | 1.24 |
| numpy version | 2.5.2 |
| star version | 2.7.10b |
| matplotlib version | 3.11.1 |
| htseq version | 2.1.2 |
 
**Environment setup notes:**
```bash
# inside Project-2-Electric-organ-RNA-seq-analysis directory
pixi init
pixi add fastqc cutadapt trimmomatic sra-tools samtools numypy star matplotlib htseq
pixi shell
```
 
---

### 2026-08-27
 
**Goal for today:**
Complete part1 of Project2: download SRR files with sra toolkit and perform fastqc analysis
 
**Commands / scripts run:**
```bash
# within shell script ./Project2_Part1/srr_fetch_and_qc.sh
# SRR datasets to be downloaded: SRR25630296, SRR25630382

prefetch SRR25630296
fasterq-dump SRR25630296

prefetch SRR25630382
fasterq-dump SRR25630382

fastqc SRR*.fastq

``` 
 
**Results / Output:**
all sra toolkit fastq file outputs and fastqc zipped output data stored in ./srr_data except for 4 output html files which are stored in ./Project2_Part1

**Next steps:**
 part2


---
### 2026-09-02
 
**Goal for today:**
Complete part2 of Project2

**Steps performed**
1. Cutadapt adapter removal/trimming
2. trimmomatic quality trimming
3. plotting read length distributions in R
 
**Commands / scripts run:**
```bash
# sanity check of the adapter sequences in the files
# confirmed that both adapters are 3' adapters because they are at end of sequence with below bash command
sed -n "2~4p" SRR25630296_1.fastq | grep -E "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
sed -n "2~4p" SRR25630296_2.fastq | grep -E "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
``` 
 
**Results / Output:**

[slurm script with cutadapt and trimmomatic code](/projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/Project2_Part2/part2.sh)

|Dataset|Tool|Time|%CPU|Memory|
|---|---|---|---|---|
|SRR25630296|cutadapt|1:21|449|97628|
|SRR25630296|trimmomatic|4:25|1002|11946616|
|SRR25630382|cutadapt|0:0.08|87|63252|
|SRR25630382|trimmomatic|0:40|1032|10418032|

---

Trimmomatic outputs:
- SRR25630296_1_trimmed.paired.fq.gz
- SRR25630296_1_trimmed.unpaired.fq.gz
- SRR25630296_2_trimmed.paired.fq.gz
- SRR25630296_2_trimmed.unpaired.fq.gz
- SRR25630382_1_trimmed.paired.fq.gz
- SRR25630382_1_trimmed.unpaired.fq.gz
- SRR25630382_2_trimmed.paired.fq.gz
- SRR25630382_2_trimmed.unpaired.fq.gz

Bash pipeline to obtain read length distribution counts

```bash
zcat {zipped paired trimmomatic output file} | sed -n "2~4p" | awk '{print length($0)}' | sort -n | uniq -c
```

Length distributions data bash command and outputs
- SRR25630296_1_trimmed.counts
- SRR25630296_2_trimmed.counts
- SRR25630382_1.trimmed.counts
- SRR25630382_2.trimmed.counts

---
**Next steps:**
 Part 3

