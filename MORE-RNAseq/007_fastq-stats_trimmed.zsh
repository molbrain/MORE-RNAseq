#!/bin/zsh

######################################
## fastq-stats: trimmed fastq (option)
######################################
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

echo "## TOOL_FASTQC : ${TOOL_FASTQSTATS}"
echo "## OUTPUT_FASTQSTATS_DIR : ./${OUTPUT_FASTQSTATS_DIR}"

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

while read SAMPLE
do
	NAME=trimmed_${SAMPLE}
	echo -n "## fastqc using $NAME (${SAMPLE})"
	date
	TRIMMED1=${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_R1.fq.gz
	TRIMMED2=${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_R2.fq.gz
	ls -Fl ${TRIMMED1} ${TRIMMED2}
	
	OUTPUT_EACH_DIR1=${OUTPUT_FASTQSTATS_DIR}/${NAME}_R1
	OUTPUT_EACH_DIR2=${OUTPUT_FASTQSTATS_DIR}/${NAME}_R2
	if [ -d ./${OUTPUT_EACH_DIR1} ]
	then
	   echo "## Exist : ./${OUTPUT_EACH_DIR1}"
	else
	   mkdir ./${OUTPUT_EACH_DIR1}
	   echo "## Create : ./${OUTPUT_EACH_DIR1}"
	fi
	if [ -d ./${OUTPUT_EACH_DIR2} ]
	then
	   echo "## Exist : ./${OUTPUT_EACH_DIR2}"
	else
	   mkdir ./${OUTPUT_EACH_DIR2}
	   echo "## Create : ./${OUTPUT_EACH_DIR2}"
	fi
	
	echo -n "## fastq-stats ($NAME) R1 "
	date
	
	${TOOL_FASTQSTATS} \
	   -s 5 \
	   ./${TRIMMED1} \
	   | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
		   > ./${OUTPUT_EACH_DIR1}/fastq-stats.txt
	
	ls -Fl ./${OUTPUT_EACH_DIR1}
	
	echo -n "## fastq-stats ($NAME) R2 "
	date
	
	${TOOL_FASTQSTATS} \
	   -s 5 \
	   ./${TRIMMED2} \
	   | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
		   > ./${OUTPUT_EACH_DIR2}/fastq-stats.txt
	
	ls -Fl ./${OUTPUT_EACH_DIR2}
	
	echo -n "## fastq-stats ($NAME) done. "
	date
done < ./${DATA_LIST_FILE}

#############################

echo -e "## DONE $0 : "
date
