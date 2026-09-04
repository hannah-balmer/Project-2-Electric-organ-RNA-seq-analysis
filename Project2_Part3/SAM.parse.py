#!/usr/bin/env python

import argparse

# argparse
def get_args():
	parser = argparse.ArgumentParser(description="This program will ...")
	parser.add_argument("-f", "--SAM_input_file", help="file path to input SAM file from STAR alignment", type=str)
	return parser.parse_args()

args = get_args()

# Shortcut variables to command line arguments
sam = args.SAM_input_file
 
mapped_reads = 0
unmapped_reads = 0

with open(sam, "r") as samf:
    for i,l in enumerate(samf):
        if l.startswith('@'):
            continue

        if i%1000000 == 0:
            print(i)
        
        flag = int(l.split('\t')[1])
        
        if ((flag & 4) != 4) and ((flag & 256) != 256):
            mapped_reads += 1
        elif ((flag & 4) == 4) and ((flag & 256) != 256):
            unmapped_reads += 1

print(f"Unmapped reads: {unmapped_reads}\nMapped reads: {mapped_reads}")