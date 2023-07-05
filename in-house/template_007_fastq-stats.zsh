#!/bin/zsh

NUM=___SAMPLE___

echo -n "## START : $0 (${NUM}). "
date

TOOL_FASTQSTATS=/home/Shared/Miscellaneous/Tools/ea-utils/fastq-stats
echo -n "## TOOL_FASTQSTATS : ${TOOL_FASTQSTATS}"
${TOOL_FASTQSTATS} --help 2>&1 | grep Version

CLEAN_FASTQ_DIR=./TRIMMOMATIC

if [ -d ${CLEAN_FASTQ_DIR} ]
then
    
    echo "# Rawdata/$NUM is using..."
    ls -Fl ${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R1.fq.gz
    ls -Fl ${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R2.fq.gz
    
    for PAIR in 1 2
    do
	FILENAME=${CLEAN_FASTQ_DIR}/trimmed_${NUM}_R${PAIR}.fq.gz
	echo -n "# fastq-stats : $FILENAME "
	date
	
	EACH_DIR=./FASTQSTATS/trimmed_${NUM}_R${PAIR}
	if [ -d ${EACH_DIR} ]
	then
	    echo "# Exist : $EACH_DIR"
	else
	    mkdir ${EACH_DIR}
	    echo "# Create : $EACH_DIR"
	fi

	${TOOL_FASTQSTATS} \
	    -s 5 \
	    ${FILENAME} \
	    | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
		   > ${EACH_DIR}/fastq-stats.txt

	echo -n "# fastq-stats ($NUM, $PAIR) done. "
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
