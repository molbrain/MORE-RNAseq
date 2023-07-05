#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

########################################################

OUTPUT_RSEM_DIR=./RSEM

echo "# Summarize of RSEM results by $0."

echo "Data" > temp_014_01_result01

FIRSTONE=`cat list_dataName.txt | head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
less ${OUTPUT_RSEM_DIR}/RSEM_${FIRSTONE}/samtools.stats.${FIRSTONE}.transcript.bam.txt \
    | grep ^SN \
    | cut -f2 \
    | perl -pe 's/\:$//;' \
	   >> temp_014_01_result01

rm temp_014_01_table
rm temp_014_01_result 

while read DATANAME
do
    echo "## ${DATANAME} "
    FILENAME=${OUTPUT_RSEM_DIR}/RSEM_${DATANAME}/samtools.stats.${DATANAME}.transcript.bam.txt
    
    echo ${DATANAME} > temp_014_01_result
    less ${FILENAME} \
	| grep ^SN \
	| cut -f3 \
	      >> temp_014_01_result
    
    paste temp_014_01_result01 temp_014_01_result > temp_014_01_table
    mv temp_014_01_table temp_014_01_result01
    rm temp_014_01_result
    
done < list_dataName.txt

mv temp_014_01_result01 RESULT_SAMTOOLS_RSEM_transcript.txt

echo -n "# DONE $0 : "
date
