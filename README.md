# MORE-RNAseq v1.0.1

## Summary

This is the MORE-RNAseq pipeline, a series of scripts analyzing RNA sequencing of genes and L1 transposons.
(Du J, Nakachi Y, Watanabe R, Yanagida Y, Bundo M and Iwamoto K. 2023. In preparation)

## Quick usage

(1) Download the **MORE-RNAseq** scripts from https://github.com/molbrain/MORE-RNAseq/releases and decompress.
```sh
## In this case, yourDir (decompressed and renamed directory) is as your working directory
$ curl -OL https://github.com/molbrain/MORE-RNAseq/archive/refs/tags/v1.0.1.tar.gz
$ tar zxvf v1.0.1.tar.gz
$ mv MORE-RNAseq-1.0.1 yourDir
$ cd yourDir
$ ls .

## Of course the way with web browser downloads and put each file via GUI (with mouse drag-and-drop) manually are OK.
```




(2) Confirm and modify the information described in **`Sample_Annot.txt`** and **`00000setup.zsh`** of **`MORE-RNAseq`** directory.

- **`Sample_Annot.txt`** is a tab-delimited plain text file for your sample annotation. An example is below. `Feature1` column is used in R script of edgeR (020).
```
Data	Sample	Dataset	Feature1
Sample_001	CB6_A	TR-0001	Control
Sample_002	CB6_B	TR-0001	Control
Sample_003	CB6_C	TR-0001	Control
Sample_006	CB6_D	TR-0001	Treat
Sample_007	CB6_E	TR-0001	Treat
Sample_008	CB6_F	TR-0001	Treat
```

- **`00000setup.zsh`** is the setting file including the variables used in the pipeline. You should confirm the contents, like the below variables.
```sh
GENOME=GRCh38
SPECIES=home_sapiens
ENSRELEASE=102
#  (if mouse, use GRCm38/mus_musculus/102)
...
READ_LENGTH=150
...
THREAD=4
...
...
```


(4) Prepare your **RNA-seq data (fastq)** and **reference data (fastq/gtf)** in the `Rawdata` and `Reference/Original` directory, respectively.
```bash
## in yourDir as your working directory
$ cd /root/yourDir
$ mkdir Reference
$ mkdir Reference/Original
$ source 00000setup.zsh
$ curl -s -o Reference/Original ${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz ./Reference/Original ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/fasta/${SPECIES}/dna/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz
$ curl -s -o Reference/Original/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/gtf/${SPECIES}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz

## Of course the way with web browser downloads and put each file via GUI manually are OK.
## http://ftp.ensembl.org/pub/release-102/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
## http://ftp.ensembl.org/pub/release-102/gtf/homo_sapiens/Homo_sapiens.GRCh38.102.gtf.gz
```



(3) Setup the environment via **Dockerfile**
```sh
## in yourDir as your working directory
$ docker build -t yourtest:MORE-RNAseq MORE-RNAseq/docker/
$ docker run -dit --name more-rnaseq yourtest:MORE-RNAseq
$ docker cp ../yourDir more-rnaseq:/root/yourDir
$ docker exec -it more-rnaseq /bin/bash
```


(5) Execute the **MORE-RNAseq** pipeline via scripts **`Exec_MORE-RNAseq_...zsh`** inside of Docker container.
```bash
## in bash of Docker container
$ cd /root/test
$ zsh ./Exec_MORE-RNAseq_01.zsh
$ zsh ./Exec_MORE-RNAseq_02.zsh
$ zsh ./Exec_MORE-RNAseq_03.zsh
$ zsh ./Exec_MORE-RNAseq_04.zsh
$ exit
```

(5) Get the results from Docker container
```sh
## in yourDir as your working directory
$ docker cp more-rnaseq:/root/testdata/Results/ ./Results
$ ls Results
```


## Outline of the pipeline workflow

##### 1. **Pre-preparation**: `Exec_MORE-RNAseq_01.zsh`
- 000: Initial setup
- 001: Quality check of raw fastq data by FastQC
- 002: Quality check of raw fastq data by fastq-stats
- 003: Summarize the QC of raw data
- 004: Care of G-stretch sequences as library artifacts by Cutadapt
- 005: trimming adapter sequences and removing low-quality bases by Trimmoamtic
- 006: Quality check after trimmed by FastQC
- 007: Quality check after trimmed by fastq-stats
- 008: Summarize the QC of trimmed data

##### 2. **Indexing the reference genome**: `Exec_MORE-RNAseq_02.zsh`
- 009.zsh: Prepare the references with GTF data of **[MORE reference](https://github.com/molbrain/MORE-reference)**

##### 3. **Mapping and counting**: `Exec_MORE-RNAseq_03.zsh`
- 010: Mapping with prepared reference by STAR
- 011: Stats check of bam files from STAR by samtools
- 012: Summarize the stats data of bam files from STAR and the log outputs
- 013: Calculate the expression of L1 transposons and genes by RSEM
- 014: Stats check of bam files from RSEM by samtools
- 015: Summarize the stats data of bam files from RSEM
- 016: Create the count data matrix by RSEM
- 017: Create the TPM and FPKM data matrix
- 018: Create the matrix files of count data via STAR
- 019: Format the matrix files as R-readable files.

##### 4. **Detection of Differentially Expressed L1s and Visualization:** `Exec_MORE-RNAseq_04.zsh`
- 020_001: Data loading from `019.zsh` data
- 020_002: PCA plot of samples
- 020_003: Box plot of the total L1 expression
- 020_004: Volcano plot of the individual L1 expression
- 020_005: Box plot of the intergenic and intragenic L1 expression


## Required tools

- [zsh](https://www.zsh.org)
- [Perl](https://www.perl.org): for RSEM and some pipeline scripts
- [STAR](https://github.com/alexdobin/STAR/)
- [RSEM](http://deweylab.github.io/RSEM/)
- [Java](https://www.java.com)
- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [ea-utils](http://expressionanalysis.github.io/ea-utils/): for fastq-stats
- [Cutadapt](https://github.com/marcelm/cutadapt/)
- [Trimmomatic](https://github.com/usadellab/Trimmomatic)
- [R](https://www.r-project.org) and [Bioconductor](https://www.bioconductor.org) ([edgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html))

You can use the same tools via the Dockerfile. Please see the below.

### Environment of developing this pipeline

- CentOS linux (v7.5)
- zsh (v5.0.2)
- Java (1.8.0)
- Perl (v5.16.3)
- R (v3.5.1)

You can use the test environment via the Dockerfile. Please see the below.

## Details

The detailed description for MORE-RNAseq for the bulk pair-end RNA-seq data.

For use, please confirm all the scripts exist in the same working directory as the below image.
```
**(Working directory)/ ─┬─ ** Rawdata/ ──┬─ ** Sample_001_R1.fastq.gz
                        │                ├─ ** Sample_001_R2.fastq.gz
                        │                ├─ ** Sample_002_R1.fastq.gz
                        │                ├─ ** Sample_002_R2.fastq.gz
                        │                └─  ...
                        │
                        ├─ ** Reference/ ─┬─ **Original/ ─┬─ **Home_sapiens.GRCh38.dna.primary_assembly.fa.gz
                        │                 │               └─ **Home_sapiens.GRCh38.102.gtf.gz
                        │                 ├─
                        │                 ├─  # Many files might automatically be created
                        │                 └─ 
                        │
                        ├─ * Sample_Annot.txt
                        ├─ * 00000setup.zsh
                        │
                        ├─  docker ──────┬─ Dockerfile
                        │                └─ dockerfile.sh
                        │
                        ├─  Exec_MORE-RNAseq_01.zsh
                        ├─  Exec_MORE-RNAseq_02.zsh
                        ├─  Exec_MORE-RNAseq_03.zsh
                        ├─  Exec_MORE-RNAseq_04.zsh
                        │
                        ├─  MORE-RNAseq/    ─┬─ 000_dataPreparation.zsh
                        │                    ├─ 001_fastqc_rawdata.zsh
                        │                    ├─ 002_fastq_stats_rawdata.zsh
                        │                    ├─ 003_summarize_qcstats_rawdata.zsh
                        │                    ├─ 004_cutadapt.zsh
                        │                    ├─ 005_trimmomatic.zsh
                        │                    ├─ 006_fastqc_trimmed.zsh
                        │                    ├─ 007_fastq-stats_trimmed.zsh
                        │                    ├─ 008_summarize_qcstats_trimmed.zsh
                        │                    ├─ 009_prepare_star_rsem_ref.zsh
                        │                    ├─ 010_STAR_mapping.zsh
                        │                    ├─ 011_samtools_stats_star.zsh
                        │                    ├─ 012_summarize_samtools_star.zsh
                        │                    ├─ 013_rsem_calc_expr.zsh
                        │                    ├─ 014_samtools_stats_rsem.zsh
                        │                    ├─ 015_summarize_samtools_rsem.zsh
                        │                    ├─ 016_rsem_gen_data_mtx.zsh
                        │                    ├─ 017_tpm_fpkm_mtx.zsh
                        │                    ├─ 018_readsPerGene_mtx.zsh
                        │                    ├─ 019_forR_Prepare.zsh
                        │                    ├─ 020_001_dataLoad.R.txt
                        │                    ├─ 020_002_initial_PCA.R.txt
                        │                    ├─ 020_003_boxplot.R.txt
                        │                    ├─ 020_004_edgeR.R.txt
                        │                    ├─ 020_005_boxplot_intergene_intragene.R.txt
                        │                    ├─ 210331_adapters.fa
                        │                    ├─ mart_export.GRCh38.102.txt.gz
                        │                    ├─ mart_export.GRCm38.102.txt.gz
                        │                    │
                        │                    └─ MORE-reference/ ─┬─ LIST_MOUSE_INTER_INTRA_GENE.csv
                        │                                        ├─ LIST_HUMAN_INTER_INTRA_GENE.csv
                        │                                        ├─ L1fli_Utr5toUtr3.GRCm38.gtf
                        │                                        ├─ L1fli_Utr5toUtr3.GRCm38.bed
                        │                                        ├─ L1fli_Utr5toUtr3.GRCh38.gtf
                        │                                        └─ L1fli_Utr5toUtr3.GRCh38.bed
                        │
                        ├─  LOGS/  # automatically created
                        └─  TEMP/  # automatically created

** : need to prepare by the user (create/download)
*  : need to modify by the user (edit/confirm)
```
- Asterisk (\*\* or *) indicates the files/directories that need to prepare or modify, respectively.
Your RNA-seq data (fastq files) is needed to copy into the subdirectory named `Rawdata` in your working directory.

- After modifying some parts of the above scripts properly, do these sequentially by the order of the number of each script in the same directory.

- The information on the parts which should be modified and the other points to take care of are described in the below **Note** section.

The workflow is the typical usage for MORE-RNAseq, so of course you can modify the pipeline and exchange the tools as you like.

After creating the directory `Reference` and the subdirectory `Original`, Prepare the reference file in **`./Reference/Original`** by download.

- The reference genome sequence (**FASTA**) and the annotation (**GTF**) files in Ensembl ***release 102*** are available below.
- http://nov2020.archive.ensembl.org/info/data/ftp/index.html

For example, like the below command.
```sh
## Please set the variables GENOME, SPECIES, CAP_SPECIES, and ENSRELEASE
## Or load the variables via 00000setup.zsh
## SPECIES=home_sapiens
## CAP_SPECIES=Home_sapiens
## ENSRELEASE=102

source 00000setup.zsh

## Download the references (FASTA and GTF) from Ensembl directly

wget \
    --directory-prefix=./Reference/Original \
    ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/fasta/${SPECIES}/dna/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz \
    ftp://ftp.ensembl.org/pub/release-${ENSRELEASE}/gtf/${SPECIES}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz

## Of course, using curl and FTP software/web browsers are OK for downloading the references (FASTA and GTF) from Ensembl.
```

Additionally, when you use the R-scripts example in this pipeline, please prepare **`Sample_Annot.txt`**.

- This file is in TSV (tab-delimiter text) format and you can edit `Sample_Annot_template.txt` by using Excel and so on.


## Note

When you use this pipeline of MORE-RNAseq, you should take care of or modify some parts in scripts as follows:

1. PATH and VARIABLE information (about the **`00000setup.zsh`** file)
1. **STAR** options
1. **RSEM** options
1. Required tool preparation and **Docker** usage
1. The trimming step
1. STAR readPerGenes count data
1. Reusability of the indexed reference
1. The number of samples in the R analysis


### Note 1. PATH and VARIABLE information

In all of the scripts, the path information of each tool and directory is referred from the **`00000setup.zsh`** file.
You should write the precise PATH for all tools in the **`00000setup.zsh`** file like the example below.
```zsh
    TOOL_STAR=/usr/local/STAR-2.6.0c/bin/Linux_x86_64_static/STAR
```
When you already have the tools in your $PATH (for example, the `which STAR` command shows the proper PATH, or just the `STAR` command shows its usage and version information), of course, the below is no problem.
```zsh
    TOOL_STAR=STAR
```
Like PATH information, the other variables in the **`00000setup.zsh`** file need to modify for your environment like the example below.
Especially the variable of `GENOME` in the **`00000setup.zsh`**, is empty as below.
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


### Note 2. STAR options

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
	--outFilterMultimapNmax 100000
```
The last two options `--outFilterMultimapNmax` and `--outSAMprimaryFlag` of the above STAR command are not the same as the default usages of STAR.
The value of `--outFilterMultimapNmax` above example is defined as 100000 for the MORE-RNAseq pipeline.
(The default original values of STAR are `OneBestScore` and `50`, respectively.)
The much greater value of `--outFilterMultimapNmax` is also OK if available.
If you need, additional options like `--winAnchorMultimapNmax`, `--bamRemoveDuplicatesType`, etc are available.
Please modify the scripts for your analysis purposes and proper calculations.

If your RNA-seq data is single-end, you should modify to the below setting in **`00000setup.zsh`**. (Default is `ISPAIREDREAD=2` ; paired-end)
```zsh
ISPAIREDREAD=1
```

### Note 3. RSEM options

In the `013_rsem_calc_expr.zsh`, the RSEM (rsem_calclation-expression) setting is here.
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
elif [ $ISPAIREDREAD -eq 1 ]
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

If your RNA-seq data is single-end, you should modify to the below setting in **`00000setup.zsh`**. (Default is `ISPAIREDREAD=2` ; paired-end)
```zsh
ISPAIREDREAD=1
```
With the settings above, `--paired-end` option will not be used.

Additionally, when your RNA-seq data was prepared by the 'stranded' library protocol, please modify the below setting in **`00000setup.zsh`**.

RSEM default is `--strandedness none`, and the MORE-RNAseq pipeline (this example) is also set `STRANDEDNESS=none` in **`00000setup.zsh`**.
For Illumina TruSeq Stranded protocols, you should use 'reverse'. 
```zsh
STRANDEDNESS=reverse
```

If you use the Docker container, the recommendation of data loading and writing is via **`docker cp`** NOT `-v` option because the processing speed is quite different.

### Note 4. Required tool preparation and Docker usage

If Docker is available in your system, you can use the **Dockerfile** which includes all the tools in the pipeline.
One of the usage examples is the one below (each command is the same in **`dokcer/docker.sh`**).

```sh
## Move to the Dockerfile's directory
$ cd docker/
## Build the image from Dockerfile
$ docker build -t yourtest:MORE-RNAseq .
## Prepare the container from the image
$ docker run -dit --name more-rnaseq yourtest:MORE-RNAseq
## Use the container as your test environment
$ docker exec -it more-rnaseq /bin/bash
```

In using Docker for the test of MORE-RNAseq, the `-v` option is **NOT** recommended in `docker run` to refer your data because the process will become too slow with `-v` volume on the data input/output in STAR (009 and 010) and RSEM (013) steps. So **`docker cp`** is recommended to use your data.

```sh
$ docker cp /path/to/yourData/ more-rnaseq:/root/testdata/
```

In STAR and RSEM step, the shortage of memory or storage size frequently occur. The resource setting of docker is useful. The recommended setting are >42 GB of "Memory", >4 core of "CPUs", and "Virtual disk limit" is >180 GB.

Or in the indexing step of genome by STAR, adding the option "--limitGenomeGenerateRAM" is also good. The STAR indexing step frequently required a large memory size not only for MORE-RNAseq but also for any other usage. Please see the help and related documents of STAR.

After doing the MORE-RNAseq pipeline, the results are available in your intact storage by the below example command.

```sh
$ docker cp more-rnaseq:/root/testdata/Results/ /path/to/copiedResults/
```

All the tools prepared in Dockerfile are the follows (Except for the CentOS linux minier version, all tools have the same versions as the ones described in the manuscript, Du et al.):
- CentOS linux (v7.9)
- zsh (v5.0.2)
- Java (1.8.0)
- Perl (v5.16.3)
- R (v3.5.1)
- STAR (v2.6.0c)
- RSEM (c1.3.3)
- FastQC (v0.11.8)
- fastq-stats (ea-utils) (v1.01)
- Cutadapt (v1.18)
- Trimmomatic (v0.38)
- edgeR (v3.22.5, with limma v3.36.5)

### Not using Dockerfile

In the case of the Docker-unavailable environment on your using system (e.g. you don't have permission for Docker execution), all tools are needed to install. In some cases, any installation are unavailable in your system, because you are not the admin and cannot install the new libraries.
If those, please use **`local::lib`** or **miniconda/anaconda** for the installation to your home directories.



### Note 5. If you don't need the trimming step

If your FASTQ files are already trimmed, you can skip the `Exec_MORE-RNAseq_01.zsh` step and directly can do the `Exec_MORE-RNAseq_02.zsh`. In this case, you should create the `TEMP/TRIMMOMATIC` and `Results` directories by yourself, and put your **RENAMED** FASTQ files like below in the `TEMP/TRIMMOMATIC` directory. And also you should prepare the `Results/list_dataName.txt` file in the `Result` directory, like below.

If your FASTQ files which already been trimmed are :
```text
foo01_R1.fastq.gz
foo01_R2.fastq.gz
foo02_R1.fastq.gz
foo02_R2.fastq.gz
bar01_R1.fastq.gz
bar01_R2.fastq.gz
bar02_R1.fastq.gz
bar02_R2.fastq.gz
```

RENAMEED files in the `TEMP/TRIMMOMATIC` directory should be :
(The filenames are added "trimmed_" prefixes, and altered "fastq" to "fq")
```text
trimmed_foo01_R1.fq.gz
trimmed_foo01_R2.fq.gz
trimmed_foo02_R1.fq.gz
trimmed_foo02_R2.fq.gz
trimmed_bar01_R1.fq.gz
trimmed_bar01_R2.fq.gz
trimmed_bar02_R1.fq.gz
trimmed_bar02_R2.fq.gz
```


`Results/list_dataName.txt` should be :
```text
foo01
foo02
bar01
bar02
```

### Note 6. STAR `readPerGenes` count data

The `readPerGenes` count data output directly from STAR is also available using the script `018.zsh`.
You can use the data instead of the RSEM `expected_count` data alternatively.

### Note 7. The version of the reference genome and annotation

All the data of Ensembl release 102 (which version used in this pipeline) are available from the URL below.
http://nov2020.archive.ensembl.org/index.html

Especially, the original data of **`"mart_export.GRCm38.102.txt.gz"`** or **`"mart_export.GRCh38.102.txt.gz"`** (used in `019.zsh`) are available from the [BioMart on Ensembl 102](http://nov2020.archive.ensembl.org/biomart/martview).

1. The data of `"Gene stable ID"`, `"Gene name"`, `"Chromosome/scaffold name"`, `"Strand"`, `"Gene start (bp)"`, `"Gene end (bp)"`, `"Gene description"`, and `"Gene type"` columns in `Attribute` section are required for output `Results` as those `"mart_export....txt.gz"` files, with the order of columns above.
1. And the Export format is `TSV` and `"Compressed file (.gz)"` with checking `"Unique results only"`.

If you want, Filtering by `"Transcript support level (TSL)"` and/or `"Gene Type"` is of course OK.

If you need, you can use the other release version of Ensembl (of course the latest one), but using L1 location information depends on GRCh38/GRCm38. So please use the corresponding release versions.


### Note 7. Reuse the indexed reference

The indexing step of the reference genome will need quite huge time and machine resources. So during the calculation with the same dataset or another data with the same library conditions, you can reuse and share the indexed reference files which have been calculated once.

The way of using symbolic links (like `ln -s Reference230820 Reference`) is also OK and works well. (However, maybe the '-v' option of 'docker run' is not recommended for the slow I/O speed and consumed resources.)


### Note 8. R analysis

In R analysis, the sample number of each group is recommended more than 2, especially for analysis with edgeR (020_004), regardless of whether some parts of 020 R scripts seem to be working.

And please prepare the preferred **`Sample_Annot.txt`**.

- This file is in TSV (tab-delimiter text) format and you can edit `Sample_Annot_template.txt` by using Excel and so on.

