#!/bin/zsh

############
## Cutadapt
############

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh : exist"
    source 00000setup.zsh
else
    echo "# not ./00000setup.zsh"
    echo -n "## Abort $0 : "
    date
    exit 0
fi

#############################

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt
echo "## READ_LENGTH: ${READ_LENGTH}"
echo "## NEXTSEQ_TRIM: ${NEXTSEQ_TRIM}"
echo "## RAWDATA_DIR: ${RAWDATA_DIR}"
echo "## OUTPUT_CUTADAPT_DIR: ${OUTPUT_CUTADAPT_DIR}"

#############################
### This example scirpt for paired-end data
### If you use single-end data, please modify

while read SAMPLE
do
	
	OUTPUT_NAME=`echo -n ${SAMPLE} | perl -pe 's/^.+\///;'`
	echo -n "## Cutadapt / $SAMPLE ($OUTPUT_NAME) : "
	date
	
	INPUT_FASTQ_R1=./${RAWDATA_DIR}/${SAMPLE}_R1.fastq.gz
	INPUT_FASTQ_R2=./${RAWDATA_DIR}/${SAMPLE}_R2.fastq.gz
	OUTPUT_FASTQ_R1=./${OUTPUT_CUTADAPT_DIR}/temp_${OUTPUT_NAME}_R1.fastq.gz
	OUTPUT_FASTQ_R2=./${OUTPUT_CUTADAPT_DIR}/temp_${OUTPUT_NAME}_R2.fastq.gz
	
	echo "## INPUT_FASTQ_R1 : $INPUT_FASTQ_R1  >>> OUTPUT: $OUTPUT_FASTQ_R1"
	echo "## INPUT_FASTQ_R2 : $INPUT_FASTQ_R2  >>> OUTPUT: $OUTPUT_FASTQ_R2"
	ls -Fal ./${INPUT_FASTQ_R1} ./${INPUT_FASTQ_R2}
	
	${TOOL_CUTADAPT} \
	   --nextseq-trim=${NEXTSEQ_TRIM} \
	   --length=${READ_LENGTH} \
	   -o ./${OUTPUT_FASTQ_R1} \
	   -p ./${OUTPUT_FASTQ_R2} \
	   ./${INPUT_FASTQ_R1} \
	   ./${INPUT_FASTQ_R2}
	
	ls -Fal ./${OUTPUT_FASTQ_R1} ./${OUTPUT_FASTQ_R2}
	
done < ./${DATA_LIST_FILE}

echo -n "## Cutadapt end : "
date

#############################

echo -n "## DONE $0 : "
date
