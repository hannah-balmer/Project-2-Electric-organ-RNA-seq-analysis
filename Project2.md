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
| agat version | 1.7.0 |
 
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

 
**Results / Output:**

all sra toolkit fastq file outputs and fastqc zipped output data stored in ./srr_data except for 4 output html files which are stored in ./Project2_Part1

```bash
# within shell script ./Project2_Part1/srr_fetch_and_qc.sh
# SRR datasets to be downloaded: SRR25630296, SRR25630382

prefetch SRR25630296
fasterq-dump SRR25630296

prefetch SRR25630382
fasterq-dump SRR25630382

fastqc SRR*.fastq
``` 

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
 
 
**Results / Output:**

[slurm script with cutadapt and trimmomatic code](./Project2_Part2/part2.sh)

```bash
# sanity check of the adapter sequences in the files prior to trimming
# confirmed that both adapters are 3' adapters because they are at end of sequence with below bash command
sed -n "2~4p" SRR25630296_1.fastq | grep -E "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
sed -n "2~4p" SRR25630296_2.fastq | grep -E "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
``` 

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

### 2026-09-03
 
**Goal for today:**
Complete part3 of Project2

**Steps performed**
1. Download Campylomormyrus compressirostris genome (fasta and gff) files
2. Convert gff to gtf with agat
3. Create STAR db with fasta and gtf files
4. Perform STAR alignment with trimmed paired forward and reverse reads from part2 above
5. Compute mapped/unmapped in each output SAM file
6. Compute counts with htseq-count

 
**Results / Output:**

[slurm script with gff file conversion and star database creation and alignment](./Project2_Part3/star_run.sh)

- gtf file: Project2_Part3/campylomormyrus.gtf
- STAR database: Project2_Part3/camp_db/
- SAM file outputs: 
    - Project2_Part3/SRR25630296_alignment/SRR25630296.aligned.samAligned.out.sam
    - Project2_Part3/SRR25630382_alignment/SRR25630382.aligned.samAligned.out.sam

[python script for SAM file mapping counts](./Project2_Part3/SAM.parse.py)

```bash
# Counting of mapped and unmapped reads from alignment sam files
./SAM.parse.py -f ./SRR25630296_alignment/SRR25630296.aligned.samAligned.out.sam
Unmapped reads: 4583682
Mapped reads: 82388670

./SAM.parse.py -f ./SRR25630382_alignment/SRR25630382.aligned.samAligned.out.sam
Unmapped reads: 664650
Mapped reads: 13152004
``` 
[htseq run script for SRR25630296 forward strand](./Project2_Part3/htseq_run1.sh)

[htseq run script for SRR25630296 reverse strand](./Project2_Part3/htseq_run2.sh)

[htseq run script for SRR25630382 forward strand](./Project2_Part3/htseq_run3.sh)

[htseq run script for SRR25630382 reverse strand](./Project2_Part3/htseq_run4.sh)

htseq output files:
- SRR25630296 forward strand: SRR25630296.str.stv
- SRR25630296 reverse strand: SRR25630296.rev.tsv
- SRR25630382 forward strand: SRR25630382.str.stv
- SRR25630382 reverse strand: SRR25630382.rev.stv



```bash
# Calculating %mapped from htseq counts within forward and reverse strands

#SRR25630296: reverse
grep -v "__" SRR25630296.rev.tsv | awk '{sum += $2} END {print sum}'
24281412
awk '{sum += $2} END {print sum}' SRR25630296.rev.tsv
43486176

24281412/43486176 * 100 = 55.84%

#SRR25630296: stranded
grep -v "__" SRR25630296.str.stv | awk '{sum += $2} END {print sum}'
1253838
awk '{sum += $2} END {print sum}' SRR25630296.str.stv
43486176

24281412/43486176 * 100 = 2.88%

#SRR25630382: reverse
grep -v "__" SRR25630382.rev.tsv | awk '{sum += $2} END {print sum}'
3524485
awk '{sum += $2} END {print sum}' SRR25630382.rev.tsv
6908327

3524485/6908327 * 100 = 51.02%

#SRR25630382: stranded
grep -v "__" SRR25630382.str.tsv | awk '{sum += $2} END {print sum}'
186582
awk '{sum += $2} END {print sum}' SRR25630382.str.tsv
6908327

186582/6908327 * 100 = 2.70%
```

|Step|Tool|Time|%CPU|Memory|
|---|---|---|---|---|
|GFF to GTF conversion|agat|19:29|97|27503676|
|Database creation|STAR|4:45|453|22706468|
|SRR25630296 alignment|STAR|6:57|1472|12789900|
|SRR25630382 alignment|STAR|1:18|1324|12419780|
|SRR25630296 stranded count |htseq|24:16|99|154660|
|SRR25630296 reverse count |htseq|44:41|99|155060|
|SRR25630382 stranded count |htseq|7:41|100|153896|
|SRR25630382 reverse count |htseq|7:59|99|153376|

---
**Next steps:**
part 4

### 2026-mm-dd
 
**Goal for today:**

**Steps performed**

 
**Commands / scripts run:**
```bash

``` 
 
**Results / Output:**

---
**Next steps:**

### 2026-mm-dd
 
**Goal for today:**

**Steps performed**

 
**Commands / scripts run:**
```bash

``` 
 
**Results / Output:**


**Next steps:**

---
### 2026-mm-dd
 
**Goal for today:**

**Steps performed**

 
**Commands / scripts run:**
```bash

``` 
 
**Results / Output:**


**Next steps:**

---
### 2026-09-02
 
**Goal for today:**

**Steps performed**

 
**Commands / scripts run:**
```bash

``` 
 
**Results / Output:**

---
**Next steps:**