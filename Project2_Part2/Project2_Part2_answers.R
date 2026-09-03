library(tidyr)
library(tidyverse)
library(dplyr)

# Reading in all my count files to create objects
SRR396_f = read.table("../srr_data/SRR25630296_1.trimmed.counts", header = FALSE, col.names = c("Frequency", "Length")) %>%
  mutate(Read = "Forward")
SRR396_r = read.table("../srr_data/SRR25630296_2.trimmed.counts", header = FALSE, col.names = c("Frequency", "Length")) %>%
  mutate(Read = "Reverse")
SRR382_f = read.table("../srr_data/SRR25630382_1.trimmed.counts", header = FALSE, col.names = c("Frequency", "Length")) %>%
  mutate(Read = "Forward")
SRR382_r = read.table("../srr_data/SRR25630382_2.trimmed.counts", header = FALSE, col.names = c("Frequency", "Length")) %>%
  mutate(Read = "Reverse")

# Concatenate forward and reverse reads into one table
SRR382 = rbind(SRR382_f, SRR382_r)
SRR396 = rbind(SRR396_f, SRR396_r)

# Bar chart plots for each SRR dataset
SRR382 %>%
  mutate(Log_Frequency = log2(Frequency)) %>%
  ggplot(aes(x = Length, y = Log_Frequency, fill = Read)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Read Length") +
  ylab("Log2 Normalized Frequency") +
  labs(title = "SRR25630382 Trimmed Sequence Length Distributions")

SRR396 %>%
  mutate(Log_Frequency = log2(Frequency)) %>%
  ggplot(aes(x = Length, y = Log_Frequency, fill = Read)) +
  geom_bar(stat = "identity", position = "dodge") +
  xlab("Read Length") +
  ylab("Log2 Normalized Frequency") +
  labs(title = "SRR25630296 Trimmed Sequence Length Distributions")
