#!/bin/zsh

echo "## $0 START : "
date


if [ -e ./00000setup.zsh ]
then
    echo -n "## USING ./00000setup.zsh : "
    date
else
    echo -n "## NOT FOUND ./00000setup.zsh : "
    date
    exit 0
fi

if [ -d ./LOGS ]
then
    echo -n "## PEFROM THE PIPELINE WITH LOG IN LOGS DIRECTORY : "
    date
else
    echo -n "## PEFROM THE PIPELINE WITH LOG IN LOGS DIRECTORY (CREATED): "
    mkdir ./LOGS
fi

## Step 000 (Data preaparation & confirmation)
zsh ./MORE-RNAseq/000_dataPreparation.zsh > LOGS/LOG_000.txt 2>&1

## Step 001 (Quality check: FastQC; raw fastq)
zsh ./MORE-RNAseq/001_fastqc_rawdata.zsh > LOGS/LOG_001.txt 2>&1

## Step 002 (Quality check: fastq-stats; raw fastq)
zsh ./MORE-RNAseq/002_fastq_stats_rawdata.zsh > LOGS/LOG_002.txt 2>&1

## Step 003 (Summarize of FastQC and fastq-stats results; raw fastq)
zsh ./MORE-RNAseq/003_summarize_qcstats_rawdata.zsh > LOGS/LOG_003.txt 2>&1z

## Step 004 (Trimming by Cutadapt)
zsh ./MORE-RNAseq/004_cutadapt.zsh > LOGS/LOG_004.txt 2>&1

## Step 005 (Trimming by Trimmomatic)
zsh ./MORE-RNAseq/005_trimmomatic.zsh > LOGS/LOG_005.txt 2>&1

## Step 006 (Quality check: FastQC; Trimmed fastq)
zsh ./MORE-RNAseq/006_fastqc_trimmed.zsh > LOGS/LOG_006.txt 2>&1

## Step 007 (Quality check: fastq-stats; Trimmed fastq)
zsh ./MORE-RNAseq/007_fastq-stats_trimmed.zsh > LOGS/LOG_007.txt 2>&1

## Step 008 (Summarize of FastQC and fastq-stats results; Trimmed fastq)
zsh ./MORE-RNAseq/008_summarize_qcstats_trimmed.zsh > LOGS/LOG_008.txt 2>&1


echo -n "## DONE : "
date
