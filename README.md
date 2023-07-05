# MORE-RNAseq

## Summary

This is the MORE-RNAseq pipeline, a series of scripts analyzing RNA sequencing of genes and L1 transposons.
(Du J, Nakachi Y, Watanabe R, Bundo M and Iwamoto K. 2023. In preparation)

## Outline of workflow

1. Pre-preparation (as you like)
    1. Quality check, trimming adapter, removing low-quality bases, and so on.
1. Mapping and counting
    1. Prepare the references with GTF data of [MORE reference](https://github.com/molbrain/MORE-reference)
    1. Mapping with prepared reference
    1. Calculate the expression of L1 transposons and genes
    1. Create the read-count/TPM data matrix
1. Summarize the L1 expression and visualization
1. Detection of Differentially Expressed L1s/Genes and Visualization
