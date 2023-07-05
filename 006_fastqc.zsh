#!/bin/zsh

NUM=___SAMPLE___

echo -n "## START : $0 (${NUM}). "
date

TOOL_FASTQC=/usr/local/fastqc/bin/fastqc
echo -n "## TOOL_FASTQC : ${TOOL_FASTQC} "
${TOOL_FASTQC} -v

CLEAN_FASTQ_DIR=./TRIMMOMATIC

if [ -d ${CLEAN_FASTQ_DIR} ]
then
    
    echo "# Rawdata/$NUM is using..."
    ls -Fl ${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R1.fq.gz
    ls -Fl ${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R2.fq.gz
    
    for PAIR in 1 2
    do
	FILENAME=${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R${PAIR}.fq.gz
	echo -n "# FastQC : $FILENAME "
	date
	
	EACH_DIR=./FASTQC/trimmed_${NUM}_R${PAIR}
	if [ -d ${EACH_DIR} ]
	then
	    echo "# Exist : $EACH_DIR"
	else
	    mkdir ${EACH_DIR}
	    echo "# Create : $EACH_DIR"
	fi
	
	${TOOL_FASTQC} \
	    --nogroup \
            -o ${EACH_DIR} \
            ${FILENAME}
	
	echo -n "# FastQC ($NUM, $PAIR) done. "
	date
    done
    ls -Fl ${EACH_DIR}
    
    echo -n "# DONE $0 ($NUM) : "
    date
    
else
    ls -Fl ${CLEAN_FASTQ_DIR}
    echo "## $1 is not exist..."
    echo -n "## Abort $0 : "
    date
fi
