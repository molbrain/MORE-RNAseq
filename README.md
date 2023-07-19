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

### Usage

The typical uage for MORE-RNAseq for the bulk pair-end RNA-seq data.

Please copy all scripts in the your same working directory as the below image.
```
**(Working directory)/ ─┬─ **Rawdata/ ───┬─ **Sample_001_R1.fastq.gz
                        │                ├─ **Sample_001_R2.fastq.gz
                        │                ├─ **Sample_002_R1.fastq.gz
                        │                ├─ **Sample_002_R2.fastq.gz
                        │                ├─  ...
                        │                └─  ...
                        ├─ * Sample_Annot.txt
                        ├─ * 00000setup.zsh
                        ├─ **Reference/ ─┬─ **Original/ ─┬─ **Home_sapiens.GRCh38.dna.primary_assembly.fa.gz
                        │                │               └─ **Home_sapiens.GRCh38.102.gtf.gz
                        │                │                   
                        │                │                   
                        │                │                   
                        │                │                   
                        │                ├─  GRCh38.102.gtf  # automatically created
                        │                ├─  GRCh38.102.fa   # automatically created
                        │                └─ ...              
                        │
                        ├─  Exec_MORE-RNAseq_01.zsh  # provided
                        ├─  Exec_MORE-RNAseq_02.zsh  # provided
                        │
                        ├─  MORE-RNAseq/    ─┬─ ...  # provided
                        │                    ├─ ...
                        │                    ├─ ...
                                             ├─  MORE-reference/ ─┬─ ...  # provided
                        │                                         ├─ ...
                        │                                         └─ ...
                        ├─  LOGS/  # automatically created
                        └─  TEMP/  # automatically created

** : need to prepare by the user (create/download)
*  : need to modify by the user (edit/confirm)
```
Asterisk (\*\* or *) indicates the files/directories that need to prepare or modify, respectively.
Your RNA-seq data (fastq files) is needed to copy into the subdirectory named `Rawdata` in your working directory.

After modifying some parts of the above scripts properly, do these sequentially by the order of the number of each script in the same directory.

The information on the parts which should be modified and the other points to take care of are described in the below Note section.

The workflow is the typical usage for MORE-RNAseq, so of course you can modify the pipeline and exchange the tools as you like.


After creating the directory `Reference` and the subdirectory `Original`, Prepare the reference file in `./Reference/Original` by download.
For example, like the below command.
```
## Load the GENOME, SPECIES, CAP_SPECIES, and ENSRELEASE
## or set the variables directory, like as GENOME, SPECIES, CAP_SPECIES, and ENSRELEASE
source 00000setup.zsh

## Download the references (fasta and gtf) from Ensembl directly
wget \
    --directory-prefix=./Reference/Original \
    ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/fasta/${SPECIES}/dna/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz \
    ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/gtf/${SPECIES}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz
```

### Note

When you use this pipeline of MORE-RNAseq, you have to take care of some parts in scripts as follows:

1. In all of the scripts, the path information of each tool and directory is referred from the `00000setup.zsh` file.
1. In the STAR mapping step (`010_STAR_mapping.zsh`), some options of STAR are not the default.
1. In the case that RSEM is not available because you are not the admin and cannot install the new libraries to your system, please use local::lib, miniconda/anaconda, Docker, etc.


#### Note 1. PATH and VARIABLE information

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


Additionally, several variables are needed to modify your environment. For example, the below ones.
```zsh
    THREAD=4   #number of CPU cores
```


#### Note 2. STAR options

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
	--outSAMmultNmax -1 \
	--outSAMprimaryFlag AllBestScore \
	--outFilterMultimapNmax 10000
```
The last two options `--outFilterMultimapNmax` and `--outSAMprimaryFlag` of the above STAR command are not the same as the default usages of STAR.
The value of `--outFilterMultimapNmax` above example is defined as 10000 for the MORE-RNAseq pipeline.
(The default original values of STAR are `OneBestScore` and `50`, respectively.)
The much greater value of `--outFilterMultimapNmax` like 100000 is also OK.
If you need, additional options like `--winAnchorMultimapNmax`, `--bamRemoveDuplicatesType`, etc are available.
Please modify the scripts for your analysis purposes and proper calculations.

If your RNA-seq data is single-end, you should modify to the below setting in `00000setup.zsh`. (Default is `ISPAIREDREAD=2` ; paired-end)
```zsh
ISPAIREDREAD=1
```

#### Note 3. RSEM options

In `013_rsem_calc_expr.zsh`, the RSEM (rsem_calclation-expression) setting is here.
```zsh
if [ $ISPAIREDREAD -eq 2 ]
then
    ${TOOL_RSEM_CALC_EXPR} \
        --alignments \
        --paired-end \
        --num-threads ${THREAD} \
        --strandedness ${STRANDNESS} \
        --append-names \
        ${INPUT_BAM} \
        ${RSEM_REF_DIR}/${REF_NAME} \
        ${OUTPUT_EACH_DIR}/${NUM}
elsif [ $ISPAIREDREAD -eq 1 ]
then
    ${TOOL_RSEM_CALC_EXPR} \
        --alignments \
        --num-threads ${THREAD} \
        --strandedness ${STRANDNESS} \
        --append-names \
        ${INPUT_BAM} \
        ${RSEM_REF_DIR}/${REF_NAME} \
        ${OUTPUT_EACH_DIR}/${NUM}
fi
```

If your RNA-seq data is single-end, you should modify to the below setting in `00000setup.zsh`. (Default is `ISPAIREDREAD=paired-end`)
```zsh
ISPAIREDREAD=single-end
```
With the settings above, `--paired-end` option will not be used.

Additionally, your RNA-seq data was prepared by the 'stranded' library protocol, please modify the below setting in `00000setup.zsh`.
RSEM default is `--strandedness none`, and MORE-RNAseq pipeline (this example) is also set `STRANDEDNESS=none` in `00000setup.zsh`.
For Illumina TruSeq Stranded protocols, should use 'reverse'. 
```zsh
STRANDEDNESS=reverse
```


#### Note 4. Required tool installation

In some cases, RSEM is not available in your system, because you are not the admin and cannot install the new libraries.
If that is, please use `local::lib` or miniconda/anaconda for the installation to your home directories, or use Docker/Singularity, etc.
