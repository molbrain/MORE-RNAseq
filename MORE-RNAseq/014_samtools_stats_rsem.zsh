#!/bin/zsh

########################
## Samtools stats (RSEM)
########################
## v.1.0.1

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh : exist"
    source 00000setup.zsh
else
    echo "## not ./00000setup.zsh"
    echo -n "## Abort $0 : "
    date
    exit 0
fi

#############################

echo "## OUTPUT_RSEM_DIR: ${OUTPUT_RSEM_DIR}."

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

while read SAMPLE
do
	echo -n "## SAMTOOLS stats: Sample: ${SAMPLE} start "
	date
	EACH_DIR=${OUTPUT_RSEM_DIR}/RSEM_${SAMPLE}
	
	ls -Fal ./${EACH_DIR}/${SAMPLE}.transcript.bam
	
	${TOOL_SAMTOOLS} stats ./${EACH_DIR}/${SAMPLE}.transcript.bam \
	   > ./${EACH_DIR}/samtools.stats.${SAMPLE}.transcript.bam.txt
	
	ls -Fal ./${EACH_DIR}/samtools.stats.${SAMPLE}.transcript.bam.txt
	echo -n "# SAMTOOLS stats: Sample: ${SAMPLE} finished "
	date
	
done < ./${DATA_LIST_FILE}


#############################

echo -n "## DONE $0 : "
date
