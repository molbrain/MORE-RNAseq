#!/bin/zsh

echo "## $0 Start : "
date

source 00000setup.zsh

NUM=___SAMPLE___

RAWDATA_DIR=./Rawdata
READ_LENGTH=150
TOOL_CUTADAPT=/usr/local/miniconda2/envs/cutadapt-1.18/bin/cutadapt
#module load cutadapt
#LD_LIBRARY_PATH=/usr/local/miniconda2/envs/cutadapt-1.18/lib/:$LD_LIBRARY_PATH
TEMP_TRIM_DIR=CUTADAPT
INPUT_NAME=${NUM}

OUTPUT_NAME=`echo -n ${INPUT_NAME} | perl -pe 's/^.+\///;'`

INPUT_FASTQ_R1=${RAWDATA_DIR}/${INPUT_NAME}_1.fastq.gz
INPUT_FASTQ_R2=${RAWDATA_DIR}/${INPUT_NAME}_2.fastq.gz
OUTPUT_FASTQ_R1=${TEMP_TRIM_DIR}/temp_${OUTPUT_NAME}_R1.fastq.gz
OUTPUT_FASTQ_R2=${TEMP_TRIM_DIR}/temp_${OUTPUT_NAME}_R2.fastq.gz

echo "# INPUT_FASTQ_R1 : $INPUT_FASTQ_R1  >>> OUTPUT: $OUTPUT_FASTQ_R1"
echo "# INPUT_FASTQ_R2 : $INPUT_FASTQ_R2  >>> OUTPUT: $OUTPUT_FASTQ_R2"
ls -Fal $INPUT_FASTQ_R1 $INPUT_FASTQ_R2

echo "# TOOL_CUTADAPT : ${TOOL_CUTADAPT}"
echo -n "# "
cutadapt --help | grep "^cutadapt version"

echo -n "# cutadapt / $NUM ($INPUT_NAME) : "
date

echo "# READ_LENGTH: ${READ_LENGTH}"

${TOOL_CUTADAPT} \
    --nextseq-trim=5 \
    --length=${READ_LENGTH} \
    -o ${OUTPUT_FASTQ_R1} \
    -p ${OUTPUT_FASTQ_R2} \
    ${INPUT_FASTQ_R1} \
    ${INPUT_FASTQ_R2}

echo -n "# cutadapt end : "
date

ls -Fal ${OUTPUT_FASTQ_R1} ${OUTPUT_FASTQ_R2}



echo -n "## $0 DONE : "
date
