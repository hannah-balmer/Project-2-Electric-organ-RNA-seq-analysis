# Lab_Notebook_Bi623_Project1
 
**Start date: August 27, 2026**

**Repository: /projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/**
 
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
| Environment file location | /projects/bgmp/hbalmer/bioinfo/Bi623/Project-2-Electric-organ-RNA-seq-analysis/pixi.toml |
| Version control repo | 2026-BGMP/Project-2-Electric-organ-RNA-seq-analysis|
 
**Environment setup notes:**
```bash
# inside Project-2-Electric-organ-RNA-seq-analysis directory
pixi init
pixi add fastqc cutadapt trimmomatic sra-tools
pixi shell
```
 
---

### 2026-08-27
 
**Goal for today:**
Complete part1 of Project2: download SRR files with sra toolkit and perform fastqc analysis

**Steps performed**

 
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
 

**Time spent:**