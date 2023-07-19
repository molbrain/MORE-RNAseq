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

## Step 009 (RSEM w/STAR: Create the reference files)
zsh ./MORE-RNAseq/009_prepare_star_rsem_ref.zsh > LOGS/LOG_009.txt 2>&1

## Step 010 (STAR: Mapping to genome)
zsh ./MORE-RNAseq/010_STAR_mapping.zsh > LOGS/LOG_010.txt 2>&1

## Step 013 (RSEM: Calculation of the expression values)
zsh ./MORE-RNAseq/013_rsem_calc_expr.zsh > LOGS/LOG_013.txt 2>&1

## Step 016 (RSEM: Generate data matrix; expected_count)
zsh ./MORE-RNAseq/016_rsem_gen_data_mtx.zsh > LOGS/LOG_016.txt. 2>&1

## Step 017 (RSEM: Generate data matrix; TPM and FPKM)
zsh ./MORE-RNAseq/017_tpm_fpkm_mtx.zsh > LOGS/LOG_017.txt 2>&1

## Step 019 (Formating to analysis by R)
zsh ./MORE-RNAseq/019_forR_Prepare.zsh > LOGS/LOG_019.txt 2>&1


echo -n "## DONE : "
date
