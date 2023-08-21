#!/bin/zsh

################
## Trimmomatic
################
## v.1.0.1

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

ADAPTER_FILE=./MORE-RNAseq/210331_adapters.fa
DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

echo "## OUTPUT_CUTADAPT_DIR : ${OUTPUT_CUTADAPT_DIR}"
echo "## OUTPUT_TRIMMOMATIC_DIR : ${OUTPUT_TRIMMOMATIC_DIR}"

#############################
### This example scirpt for paired-end data
### If you use single-end data, please modify

while read SAMPLE
do
	
	FILENAME1=./${OUTPUT_CUTADAPT_DIR}/temp_${SAMPLE}_R1.fastq.gz
	FILENAME2=./${OUTPUT_CUTADAPT_DIR}/temp_${SAMPLE}_R2.fastq.gz
	
	TRIMMED1=./${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_R1.fq.gz
	TRIMMED2=./${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_R2.fq.gz
	UNPAIRED1=./${OUTPUT_TRIMMOMATIC_DIR}/unpaired_${SAMPLE}_R1.fq.gz
	UNPAIRED2=./${OUTPUT_TRIMMOMATIC_DIR}/unpaired_${SAMPLE}_R2.fq.gz
	
	echo "## adapter>>${ADAPTER_FILE}<<"
	ls ${ADAPTER_FILE}
	echo "## R1>>${FILENAME1}<<"
	ls ${FILENAME1}
	echo "## R2>>${FILENAME2}<<"
	ls ${FILENAME2}
	echo "## TRIMMED1  : ${TRIMMED1}"
	echo "## TRIMMED2  : ${TRIMMED2}"
	echo "## UNPAIRED1  : ${UNPAIRED1}"
	echo "## UNPAIRED2  : ${UNPAIRED2}"
	echo "## MIN_LENGTH : ${MIN_LENGTH}"
	echo "## MIN_QUAL   : ${MIN_QUAL}"
	
	echo -n "## Trimmomatic START ${SAMPLE} ..."
	date
	
	${JAVA} \
	    -jar ${JAR_TRIMMOMATIC} \
	    PE \
	    -phred33 \
	    -threads ${THREAD} \
	    ${FILENAME1} \
	    ${FILENAME2} \
	    ${TRIMMED1} ${UNPAIRED1} \
	    ${TRIMMED2} ${UNPAIRED2} \
	    ILLUMINACLIP:${ADAPTER_FILE}:2:40:15 \
	    LEADING:10 \
	    TRAILING:10 \
	    SLIDINGWINDOW:4:${MIN_QUAL} \
	    MINLEN:${MIN_LENGTH}
	
	ls -Fal ${TRIMMED1} ${TRIMMED2}
	ls -Fal ${UNPAIRED1} ${UNPAIRED2}
	
	echo -n "## Trimmomatic FINISHED ${SAMPLE} : "
	date
	
done < ./${DATA_LIST_FILE}

#############################

echo -n "## DONE $0 : "
date
