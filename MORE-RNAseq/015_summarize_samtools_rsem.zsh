#!/bin/zsh

###################################
## Summarize samtools stats (RSEM)
###################################

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

echo "## OUTPUT_RSEM_DIR : ./${OUTPUT_RSEM_DIR}"

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

echo "## Summarize of samtools.stats result of RSEM transcript.bam."

echo "Data" > ./${TEMP_DIR}/temp_015_01_result01

FIRSTONE=`cat ./${DATA_LIST_FILE} | head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
less ./${OUTPUT_RSEM_DIR}/RSEM_${FIRSTONE}/samtools.stats.${FIRSTONE}.transcript.bam.txt \
    | grep ^SN \
    | cut -f2 \
    | perl -pe 's/\:$//;' \
	   >> ./${TEMP_DIR}/temp_015_01_result01

if [ -f ./${TEMP_DIR}/temp_015_01_table ]
then
	rm ./${TEMP_DIR}/temp_015_01_table
fi

if [ -f ./${TEMP_DIR}/temp_015_01_result ]
then
	rm ./${TEMP_DIR}/temp_015_01_result
fi

while read DATANAME
do
    echo "## ${DATANAME} "
    FILENAME=${OUTPUT_RSEM_DIR}/RSEM_${DATANAME}/samtools.stats.${DATANAME}.transcript.bam.txt
    
    echo ${DATANAME} > ./${TEMP_DIR}/temp_015_01_result
    less ./${FILENAME} \
	| grep ^SN \
	| cut -f3 \
	      >> ./${TEMP_DIR}/temp_015_01_result
    
    paste ./${TEMP_DIR}/temp_015_01_result01 ./${TEMP_DIR}/temp_015_01_result \
	   > ./${TEMP_DIR}/temp_015_01_table
    mv ./${TEMP_DIR}/temp_015_01_table ./${TEMP_DIR}/temp_015_01_result01
    rm ./${TEMP_DIR}/temp_015_01_result
    
done < ./${DATA_LIST_FILE}

mv ./${TEMP_DIR}/temp_015_01_result01 ./${RESULT_DIR}/RESULT_SAMTOOLS_RSEM_transcript.txt
ls -Fal ./${RESULT_DIR}/RESULT_SAMTOOLS_RSEM_transcript.txt

#############################

echo -n "## DONE $0 : "
date
