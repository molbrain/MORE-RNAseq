# MORE-RNAseq

## Summary

This is the MORE-RNAseq pipeline, a series of scripts analyzing RNA sequencing of genes and L1 transposons.

## Outline of pipeline

1. Quality check: **CAUTION** NOT PREPARED, DO AS YOU LIKE
    1. File check by md5/sha1 etc.
    1. FastQC, fastq-stats (ea-utils), and so on.
1. Trimming: cutadapt and/or Trimmomatic (if you want, you can use other tools, like TrimGalore! and so on).
    1. If need, remove G-stretches in R2-tail by cutadapt (optional)
    1. trim adapters and low-quality reads by Trimmomatic
1. Mapping and counting: STAR/RSEM
    1. prepare the references for STAR/RSEM): **CAUTION** YOU NEED THE REWRITE "READ_LENGTH" VALUE BEFORE USE
    1. mapping: STAR **NOTE** IF YOU NEED, ADDITIONAL OPTIONS AND MODIFIED VALUES ARE AVAILABLE (PLEASE SEE THE COMMENTS IN THIS SCRIPT).
    1. calculate the expression: RSEM: **NOTE** IF YOU NEED, ADDITIONAL OPTIONS AND MODIFIED VALUES ARE AVAILABLE (PLEASE SEE THE COMMENTS IN THIS SCRIPT).
    1. create an expected-count data matrix: RSEM and shell scripts
    1. create TPM and FPKM data matrix: shell script
1. Detection of DEGs (Differentially Expressed Genes): edgeR (If you want, you can use other tools, like DEseq2, and so on)
1. Visualization: R scripts (Of course you can make your scripts and use other tools)


## Developed environment

- CentOS7/8/Rockey
- perl5
- java
- R and Bioconductor


## Requires, Recommends

- perl5
- java
- R and Bioconductor
- Trimming tools (like cutadapt and Trimmomatic)
- STAR
- RSEM



## Usage

If you use the pipeline of "MORE-RNAseq" with , you have to change the some part of command lines and options as follows:

- In the step of creating the reference for STAR/RSEM (as 009_prepare_star_rsem_ref.zsh), alter the proper genome (e.g. GRCh38).

Change like this.
GENOME=GRCh38
L1_GTF=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1/L1_Utr5toUtr3.${GENOME}.gtf
cat ${L1_GTF} >> ${REF_GTF}


- In the STAR mapping step (as template_010_STAR_mapping.zsh), uncomment the three lines and add these three options to the last line of the STAR command:
These last three options of the below command are not used by default usate of STAR.
If you need, the much greater value of `--outFilterMultimapNmax` like 1000000 is also OK.

```
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

How to use `./BUILDER_FROM_TEMPLATE.zsh`
--

`./BUILDER_FROM_TEMPLATE.zsh` is a scripts-creatable-script for a series of scripts to process with many samples with a script-template file like `./template_XXX_script.zsh`.

In this example case, there are several samples in the `./Rawdata` directory like these:
```
./Rawdata/MY_SAMPLE_A_DATA_R1.fastq.gz
./Rawdata/MY_SAMPLE_A_DATA_R2.fastq.gz
./Rawdata/MY_SAMPLE_B_DATA_R1.fastq.gz
./Rawdata/MY_SAMPLE_B_DATA_R2.fastq.gz
./Rawdata/MY_SAMPLE_C_DATA_R1.fastq.gz
./Rawdata/MY_SAMPLE_C_DATA_R2.fastq.gz
```


The command usage is here:
```
./BUILDER_FROM_TEMPLATE.zsh template_000_example.zsh list_dataName.txt
```

`./list_dataName.txt` as a list of data names is like this:
```
SAMPLE_A
SAMPLE_B
SAMPLE_C
```

And `./template_000_example.zsh` as a template is like this:
```
#!/bin/zsh

REPLACING=___SAMPLE___

ls -Fal ./Rawdata/MY_${REPLACING}_DATA_R1.fastq.gz
ls -Fal ./Rawdata/MY_${REPLACING}_DATA_R2.fastq.gz
```


`./BUILDER_FROM_TEMPLATE.zsh` replaces "\_\_\_SAMPLE\_\_\_" with each data name of list_dataName.txt in `template_000_example.zsh` and creates the each corresponding script in the `./scripts` directory.
```
./scripts/000_template_01.zsh (for SAMPLE_A)
./scripts/000_template_03.zsh (for SAMPLE_B)
./scripts/000_template_03.zsh (for SAMPLE_C)
```

And create executable files for qsub as `./query_000.sh` like this:
```
#!/bin/sh

./scripts/000_template_01.zsh > LOGS/LOG_000_template_01.txt 2>&1
./scripts/000_template_02.zsh > LOGS/LOG_000_template_02.txt 2>&1
./scripts/000_template_03.zsh > LOGS/LOG_000_template_03.txt 2>&1
```

`./query_000.sh` is executable by command as follows, with `qsub` (the job scheduler system in cluster servers):
```
qsub query_000.sh
```

Of course, you can execute each script like `./scripts/000_template_01.zsh` separately, with SCREEN, tmux, and so on.

Or do that:
```
./scripts/000_template_01.zsh > LOGS/LOG_000_template_01.txt 2>&1
```

When the script is working, log information from tools and systems is described in each `LOGS/LOG_XXX_XXXXX_XX.txt` file. So, if you do it in the background by qsub or screen, you can monitor the log files like this:
```
less LOGS/LOG_000_template_01.txt
# and shift-F can move and see the newest lines of the log text.
```

Or
```
tail --lines=+5 LOGS/LOG_000_template_*.txt | less
```


