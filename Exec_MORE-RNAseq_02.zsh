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

echo "## Step 009 (RSEM w/STAR: Create the reference files)"
date
zsh ./MORE-RNAseq/009_prepare_star_rsem_ref.zsh > LOGS/LOG_009.txt 2>&1

echo -n "## DONE : "
date
