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



echo "## R scripts doing..."
date
Rscript -e 'source("MORE-RNAseq/020_001_dataLoad.R.txt"); source("MORE-RNAseq/020_002_initial_PCA.R.txt"); source("MORE-RNAseq/020_003_boxplot.R.txt"); source("MORE-RNAseq/020_004_edgeR.R.txt"); source("MORE-RNAseq/020_005_boxplot_intergene_intragene.R.txt")'

echo "## Copying Results of analysis with R to Results directory"
cp boxplot_*pdf heatmap.pdf hits.txt scatterplot.pdf PCA_plot_TR-0001.pdf PCA_ProportionOfVariance_TR-0001.pdf Results/



echo -n "## DONE : "
date
