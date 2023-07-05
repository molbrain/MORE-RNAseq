#!/bin/zsh

#############################
## 00000setup.zsh
#############################


echo -n "## $0 start : "
date


#############################

ORIGINAL_DATA_DIR=/home/nakachiy/Rawdata/MolBrain/NGS15/original_fastq
# ln -s ${ORIGINAL_DATA_DIR} ./Rawdata

READ_LENGTH=150
MIN_LENGTH=40
MIN_QUAL=10


GENOME=GRCm38
# human -> GRCh38, mouse -> GRCm38, chimp -> ??, marmoset -> ??
ENSRELEASE=102
SPECIES=mus_musculus
# human -> =homo_sapiens, mouse -> mus_musculus, chimp -> ??, marmoset -> ??
CAP_SPECIES=Mus_musculus
## human -> =Homo_sapiens, mouse -> Mus_musculus, chimp -> ??, marmoset -> ??

REF_NAME=${GENOME}.${ENSRELEASE}


L1_GTF=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1/L1_Utr5toUtr3.${GENOME}.gtf

RAWDATA_PREFIX_PAIR=_R
RAWDATA_SUFFIX_FASTQ=fastq.gz

#############################

TOOL_FASTQC=/usr/local/fastqc/bin/fastqc
TOOL_FASTQSTATS=/home/Shared/Miscellaneous/Tools/ea-utils/fastq-stats


TOOL_CUTADAPT=/usr/local/miniconda2/envs/cutadapt-1.18/bin/cutadapt
JAR_TRIMMOMATIC=/usr/local/Trimmomatic-0.38/trimmomatic-0.38.jar


TOOL_STAR=/home/nakachiy/bin/STAR-2.7.6a/bin/Linux_x86_64_static/STAR


TOOL_RSEM_PREP_REF=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-prepare-reference
TOOL_RSEM_CALC_EXPR=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-calculate-expression
TOOL_RSEM_GEN_DATA_MTX=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-generate-data-matrix


TOOL_SAMTOOLS=/home/nakachiy/bin/samtools/bin/samtools


#############################

RAWDATA_DIR=./Rawdata

OUTPUT_FASTQSTATS_DIR=./FASTQSTATS

TEMP_TRIM_DIR=./CUTADAPT
CLEAN_FASTQ_DIR=./TRIMMOMATIC

STAR_RSEM_REF_DIR=./Ref
CLEAN_FASTQ_DIR=./TRIMMOMATIC
OUTPUT_STAR_DIR=./STAR
OUTPUT_RSEM_DIR=./RSEM

OUTPUT_EDGER_DIR=./EDGER


#############################

echo -n "## $0 DONE : "
date


