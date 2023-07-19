#!/bin/zsh

###################################
## FastqQC: trimmed fastq (option)
##################################

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

echo "## TOOL_FASTQC : ${TOOL_FASTQC}"
echo "## OUTPUT_FASTQC_DIR : ./${OUTPUT_FASTQC_DIR}"

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

while read SAMPLE
do
	NAME=trimmed_${SAMPLE}
	echo -n "## fastqc using $NAME (${SAMPLE})"
	date
	TRIMMED1=./${OUTPUT_TRIMMOMATIC_DIR}/${NAME}_R1.fq.gz
	TRIMMED2=./${OUTPUT_TRIMMOMATIC_DIR}/${NAME}_R2.fq.gz
	ls -Fl ${TRIMMED1} ${TRIMMED2}
	
	OUTPUT_EACH_DIR1=${OUTPUT_FASTQC_DIR}/${NAME}_R1
	OUTPUT_EACH_DIR2=${OUTPUT_FASTQC_DIR}/${NAME}_R2
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
	
	echo -n "## FastQC ($NAME) R1 "
	date
	
	${TOOL_FASTQC} \
	   --nogroup \
	   -o ./${OUTPUT_EACH_DIR1} \
	   ${TRIMMED1}
	
	ls -Fl ./${OUTPUT_EACH_DIR1}
	
	echo -n "## FastQC ($NAME) R2 "
	date
	
	${TOOL_FASTQC} \
	   --nogroup \
	   -o ./${OUTPUT_EACH_DIR2} \
	   ${TRIMMED2}
	
	ls -Fl ./${OUTPUT_EACH_DIR2}
	
	echo -n "## FastQC ($NAME) done. "
	date
done < ./${DATA_LIST_FILE}

#############################

echo -e "## DONE $0 : "
date
