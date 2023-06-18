# MORE-RNAseq

RNAseq
==

This is the MORE-RNAseq pipeline, a series of detailed scripts analyzing RNA sequencing of genes and L1 transpooons.

Details
--

1. Sample check:
    1. md5sum check: **CAUTION** NOT PREPARED, DO AS YOU LIKE
    1. make filename list and sample annotation table (000)
1. Quality check of raw data: FastQC and/or fastq-stats
    1. FastQC (001)
    1. fastq-stats (ea-utils) (002)
    1. summarize the fastq stats (003): Optional
1. Trimming: cutadapt and/or Trimmomatic
    1. remove G-streches in R2-tail by cutadapt (004): Optional
    1. trim adapters and low-quality reads by Trimmomatic (005)
1. Confirmation of quality after trimming
    1. re-check by FastQC (006)
    1. re-check by fastq-stats (007): Optional
    1. summarize the fastq stats (008)
1. Mapping and counting: STAR/RSEM
    1. prepare the references for STAR/RSEM (009): **CAUTION** YOU NEED THE REWRITE "READ_LENGTH" VALUE BEFORE USE, AND IF YOU USE AS "MORE-RNAseq", ADDITIONAL COMMAND LINES ARE NEEDED (PLEASE SEE THE COMMENTS IN THIS SCRIPT)
    1. mapping by STAR (010): **CAUTION** IF YOU USE AS "MORE-RNAseq", ADDITIONAL OPTIONS ARE NEEDED (PLEASE SEE THE COMMENTS IN THIS SCRIPT)
    1. quality check of BAM data from STAR by samtools (011)
    1. summarize the STAR logs and BAM stats (012)
    1. calculate the expression by RSEM (013)
    1. quality check of BAM data from RSEM by samtools (014): Optional
    1. summarize the RSEM logs and BAM stats (015)
    1. create an expected-count data matrix by RSEM (016)
    1. create TPM and FPKM data matrix (017)
    1. create ReadPerGenes (from STAR) matrix (018): Optional
1. Detection: edgeR
    1. reformat each matrix to R-friendly-data (019)
    1. Detect the DEGs (Differentially Expressed Genes) by edgeR (020): **CAUTION** Sorry, not prepared yet...



Requires
--

In our lab's servers/workstations, the installations and preparations are already OK.

- CentOS7/8/Rockey
- perl5
    - w/ local::lib for RSEM (maybe...)
- java
- R and Bioconductor
- and these tools
    - fastqc
    - ea-utils
    - cutadapt
    - Trimmomatic
    - STAR
    - samtools
    - RSEM



Usage
--




MORE-RNAseq
--

If you use the pipeline as "MORE-RNAseq", you have to change the some part of command lines and options as follows:

- In the step of creating the reference for STAR/RSEM (as 009_prepare_star_rsem_ref.zsh), uncomment the two lines.
These lines are commented on by default.
```
#L1_GTF=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1/L1_Utr5toUtr3.${GENOME}.gtf
#cat ${L1_GTF} >> ${REF_GTF}
```
Change like this.
```
L1_GTF=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1/L1_Utr5toUtr3.${GENOME}.gtf
cat ${L1_GTF} >> ${REF_GTF}
```

- In the STAR mapping step (as template_010_STAR_mapping.zsh), uncomment the three lines and add these three options to the last line of the STAR command:
These options of the STAR command are commented on and not used by default.
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
	
	
	### MORE RNA-seq settings
	### NEED TO ADD THE THREE OPTIONS TO STAR COMMAND ABOVE
	#--outSAMprimaryFlag AllBestScore \
	#--outSAMmultNmax -1 \
	#--outFilterMultimapNmax 10000 \
	### 
```
Change like this. (If you need, the much greater value of `--outFilterMultimapNmax` like 1000000 is also OK)
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
	--outFilterMultimapNmax 3000 \

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


