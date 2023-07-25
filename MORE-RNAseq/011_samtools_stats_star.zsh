#!/bin/zsh

#########################
## Samtools stats (STAR)
#########################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh : exist"
    source ./00000setup.zsh
else
    echo "## not ./00000setup.zsh"
    echo -n "## Abort $0 : "
    date
    exit 0
fi

#############################

echo -n "## OUTPUT_STAR_DIR: ./${OUTPUT_STAR_DIR}"

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

while read SAMPLE
do
    
    echo -n "## SAMTOOLS stats: Sample: ${SAMPLE} start "
    date
    
    EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${SAMPLE}
    for DATANAME in sortedByCoord toTranscriptome
    do
	echo -n "## ${DATANAME} (${SAMPLE})"
	date
	ls -Fal ./${EACH_DIR}/Aligned.${DATANAME}.out.bam
	
	${TOOL_SAMTOOLS} stats ./${EACH_DIR}/Aligned.${DATANAME}.out.bam \
	   > ./${EACH_DIR}/samtools.stats.Aligned.${DATANAME}.out.bam.txt
    done
    
    ls -Fal ./${EACH_DIR}/samtools.stats.Aligned.*.out.bam.txt
    echo -n "# SAMTOOLS stats: Sample: ${SAMPLE} finished "
    date
    
done < ./${DATA_LIST_FILE}

#############################

echo -n "## DONE $0 : "
date
