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


## Recommended pipeline

### Environment of developing this pipeline

- CentOS7 (release XXX)
- zsh (ver.XXX)
- Perl (ver.XXX)
- R (ver.XXX)

### Require tools for this pipeline

- [FastQC]()
- [ea-utils](): for fastq-stats
- [Cutadapt]()
- [Trimmomatic]()
- [Perl](): for RSEM and some pipeline scripts
- [R](https://www.r-project.org) and [Bioconductor](https://www.bioconductor.org) ([edgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html))
- [STAR](https://github.com/alexdobin/STAR/)
- [RSEM](http://deweylab.github.io/RSEM/)

### Scripts of the pipeline

#### Usage

The typical uage for MORE-RNAseq for the bulk pair-end RNA-seq data.

Please copy all scripts in the your same working directory as the below image.
```
*(Working directory)/ ──┬─ *Rawdata/ ─┬─ (sampleA_R1.fa.gz)
                        │             ├─ (sampleA_R2.fa.gz)
                        │             ├─ (sampleB_R1.fa.gz)
                        │             ├─ ...
                        │             └─ ...
                        │
                        ├─ *Sample_Annotation.txt
                        │
                        ├─ *00000setup.zsh
                        ├─ 001_....zsh
                        ├─ 002_....zsh
                        ┊  ...
                        ┊  ...
                        ├─ 019_....zsh
                        ├─ 020_....zsh
                        │
                        ├─ Scripts/ ──┬─ 000_....pl
                        │             ├─ 020_....Rscript.txt
                        │             ├─ ...
                        │             └─ ...
                        │
                        └─ RESULTS/ ──┬─ ...
                                      ├─ ...
                                      └─ LOGS/ ─┬─ LOG_001_....txt
                                                └─ ...
* : need to prepare/modify
```
Astarisk(*) indicates the files/directories need to prepare/modify.
Your RNA-seq data (fastq files) is needed to copy into the subdirectory named `Rawdata` in your working directory.

After modifying some parts of the above scripts properly, do these sequentially by the order of the number of each script in the same directory.

The information on the parts which should be modified and the other points to take care of are described in the below Note section.

The workflow is the typical usage for MORE-RNAseq, so of course you can modify the pipeline and exchange the tools as you like.

#### Note

When you use this pipeline of MORE-RNAseq, you have to take care of some parts in scripts as follows:

1. In all of the scripts, the path information of each tool and directory is referred from the `00000setup.zsh` file.
1. In the STAR mapping step (`010_STAR_mapping.zsh`), some options of STAR are not the default.
1. In the case that RSEM is not available because you are not the admin and cannot install the new libraries to your system, please use local::lib, miniconda/anaconda, Docker, etc.


##### Note 1. PATH and VARIABLE information

In all of the scripts, the path information of each tool and directory is referred from the `00000setup.zsh` file.
You should write the precise PATH for all tools in the `00000setup.zsh` file like the example below.
```zsh
    TOOL_STAR=/usr/local/STAR-2.6.0c/bin/Linux_x86_64_static/STAR
```
When you already have the tools in your $PATH (for example, the `which STAR` command shows the proper PATH, or just the `STAR` command shows its usage and version information), of course, the below is no problem.
```zsh
    TOOL_STAR=STAR
```
Like PATH information, the other variables in the `00000setup.zsh` file need to modify for your environment like the example below.
Especially the variable of `GENOME` in the `00000setup.zsh`, is empty as below.
```zsh
    GENOME=
```
If you don't write the proper genome assembly name (`GRCh38` or `GRCm38`) in that, this script may abort without any output.
Change like the below.
```zsh
     GENOME=GRCh38   #for human GRCh38 genome
```
Or,
```zsh
    GENOME=GRCm38    #for mouse GRCm38 genome
```


Additionally, several variables are needed to modify to your environment. For example, the below ones.
```zsh
   THREAD=4   #number of CPU cores
```


##### Note 3. STAR options

In `010_STAR_mapping.zsh`, the STAR setting is here.
```zsh
    ${TOOL_STAR} \
	--runMode alignReads \
	--genomeDir ${STAR_RSEM_REF_DIR} \
	--readFilesCommand gunzip -c \
	--runThreadN ${THREAD} \
	--quantMode TranscriptomeSAM GeneCounts \
	--readFilesIn ${INPUT_FASTQ_R1} ${INPUT_FASTQ_R2} \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ${OUTPUT_EACH_DIR}/ \
	--outSAMprimaryFlag AllBestScore \
	--outSAMmultNmax -1 \
	--outFilterMultimapNmax 10000
```
The last three options of STAR command are not the same as the default usage of STAR (`--outSAMprimaryFlag`, `--outSAMmultNmax`, and `--outFilterMultimapNmax`).
If you need, the much greater value of `--outFilterMultimapNmax` up to 100000, or additional options like `--winAnchorMultimapNmax` etc are available. Please modify it for your analysis purpose.

If your RNA-seq data is single-end or stranded, please modified the setting in STAR and RSEM commands.

#### Note 4.RSEM installation

In some cases, RSEM is not available in your system, because you are not the admin and cannot install the new libraries.
If that is, please use local::lib or miniconda/anaconda for the installation to your home directories, or use Docker/Singularity, etc.

