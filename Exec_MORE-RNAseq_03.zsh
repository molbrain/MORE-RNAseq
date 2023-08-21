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
    echo -n "## PEFROM THE PIPELINE WITH LOG IN LOGS DIRECTORY: "
    date
else
    echo -n "## PEFROM THE PIPELINE WITH LOG IN LOGS DIRECTORY (CREATED): "
    mkdir ./LOGS
fi

echo "## Step 010 (STAR: Mapping to the reference genome)"
date
zsh ./MORE-RNAseq/010_STAR_mapping.zsh > LOGS/LOG_010.txt 2>&1

echo "## Step 011 (samtools: Calculate stats of BAM)"
date
zsh ./MORE-RNAseq/011_samtools_stats_star.zsh > LOGS/LOG_011.txt 2>&1

echo "## Step 012 (Summarize the stats)"
date
zsh ./MORE-RNAseq/012_summarize_samtools_star.zsh > LOGS/LOG_012.txt 2>&1

echo "## Step 013 (RSEM: Calculation of the expression values)"
date
zsh ./MORE-RNAseq/013_rsem_calc_expr.zsh > LOGS/LOG_013.txt 2>&1

echo "## Step 014 (samtools: Calculate stats of BAM)"
date
zsh MORE-RNAseq/014_samtools_stats_rsem.zsh > LOGS/LOG_014.txt 2>&1

echo "## Step 015 (Summarize the stats)"
date
zsh ./MORE-RNAseq/015_summarize_samtools_rsem.zsh > LOGS/LOG_015.txt 2>&1

echo "## Step 016 (RSEM: Generate data matrix and extract expected_count)"
date
zsh ./MORE-RNAseq/016_rsem_gen_data_mtx.zsh > LOGS/LOG_016.txt. 2>&1

echo "## Step 017 (Extract data matrix; TPM and FPKM)"
date
zsh ./MORE-RNAseq/017_tpm_fpkm_mtx.zsh > LOGS/LOG_017.txt 2>&1

echo "## Step 018 (Generate data matrix; count data from STAR readPerGenes option)"
date
zsh ./MORE-RNAseq/018_readsPerGene_mtx.zsh > LOGS/LOG_017.txt 2>&1

echo "## Step 019 (Formating to analyze with R)"
date
zsh ./MORE-RNAseq/019_forR_Prepare.zsh > LOGS/LOG_019.txt 2>&1

echo -n "## DONE : "
date
