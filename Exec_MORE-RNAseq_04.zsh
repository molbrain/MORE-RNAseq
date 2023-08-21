#!/bin/zsh

Rscript -e 'source("MORE-RNAseq/020_001_dataLoad.R.txt"); source("MORE-RNAseq/020_002_initial_PCA.R.txt"); source("MORE-RNAseq/020_003_boxplot.R.txt"); source("MORE-RNAseq/020_004_edgeR.R.txt"); source("MORE-RNAseq/020_005_boxplot_intergene_intragene.R.txt")'

cp boxplot_*pdf heatmap.pdf hits.txt scatterplot.pdf PCA_plot_TR-0001.pdf PCA_ProportionOfVariance_TR-0001.pdf Results/
