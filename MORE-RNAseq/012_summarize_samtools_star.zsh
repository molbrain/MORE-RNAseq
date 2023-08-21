#!/bin/zsh

###################################
## Summarize samtools stats (STAR)
###################################
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

echo "## OUTPUT_STAR_DIR : ./${OUTPUT_STAR_DIR}"

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

for STATS in toTranscriptome sortedByCoord
do
    
    echo "## Summarize of samtools.stats result of Aligned.${STATS}.out.bam.txt."
    
    echo "Data" > ./${TEMP_DIR}/temp_012_01_result01_${STATS}
    
    FIRSTONE=`cat ./${DATA_LIST_FILE} | head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
    less ./${OUTPUT_STAR_DIR}/STAR_${FIRSTONE}/samtools.stats.Aligned.${STATS}.out.bam.txt \
	| grep ^SN \
	| cut -f2 \
	| perl -pe 's/\:$//;' \
	       >> ./${TEMP_DIR}/temp_012_01_result01_${STATS}
    
    if [ -f ./${TEMP_DIR}/temp_012_01_table_${STATS} ]
    then
	rm ./${TEMP_DIR}/temp_012_01_table_${STATS}
    fi

    if [ -f ./${TEMP_DIR}/temp_012_01_result_${STATS} ]
    then
	rm ./${TEMP_DIR}/temp_012_01_result_${STATS}
    fi
    
    while read DATANAME
    do
	echo "## ${DATANAME} "
	FILENAME=${OUTPUT_STAR_DIR}/STAR_${DATANAME}/samtools.stats.Aligned.${STATS}.out.bam.txt
	
	echo ${DATANAME} > ./${TEMP_DIR}/temp_012_01_result_${STATS}
	less ./${FILENAME} \
	   | grep ^SN \
	   | cut -f3 \
	   >> ./${TEMP_DIR}/temp_012_01_result_${STATS}
	
	paste ./${TEMP_DIR}/temp_012_01_result01_${STATS} ./${TEMP_DIR}/temp_012_01_result_${STATS} \
	   > ./${TEMP_DIR}/temp_012_01_table_${STATS}
	mv ./${TEMP_DIR}/temp_012_01_table_${STATS} ./${TEMP_DIR}/temp_012_01_result01_${STATS}
	rm ./${TEMP_DIR}/temp_012_01_result_${STATS}
	
    done < ./${DATA_LIST_FILE}
    
    mv ./${TEMP_DIR}/temp_012_01_result01_${STATS} ./${RESULT_DIR}/RESULT_SAMTOOLS_STARS_${STATS}.txt
    ls -Fal ./${RESULT_DIR}/RESULT_SAMTOOLS_STARS_${STATS}.txt
    
done

#############################

echo "## Summarize of STAR/Logfinal.out as STAR logs"

echo "Data" > ./${TEMP_DIR}/temp_012_02_result01
FIRSTOUT=`cat ./${DATA_LIST_FILE}| head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
less ./${OUTPUT_STAR_DIR}/STAR_${FIRSTOUT}/Log.final.out \
    | cut -f 1 \
    | perl -pe 's/\ +\|$//;s/^\ +//;s/\ +$//;' \
	   >> ./${TEMP_DIR}/temp_012_02_result01

if [ -f ./${TEMP_DIR}/temp_012_02_table ]
then
    rm ./${TEMP_DIR}/temp_012_02_table
fi

if [ -f ./${TEMP_DIR}/temp_012_02_result ]
then
    rm ./${TEMP_DIR}/temp_012_02_result
fi

while read SAMPLE
do
	echo "${SAMPLE}" > ./${TEMP_DIR}/temp_012_02_result
	less ./${OUTPUT_STAR_DIR}/STAR_${SAMPLE}/Log.final.out \
	   | cut -f 2 \
	   | perl -ne 'if(/\:$/){print"\n";}else{print;}' \
	   >> ./${TEMP_DIR}/temp_012_02_result
	
	paste ./${TEMP_DIR}/temp_012_02_result01 ./${TEMP_DIR}/temp_012_02_result \
	   > ./${TEMP_DIR}/temp_012_02_table
	mv ./${TEMP_DIR}/temp_012_02_table ./${TEMP_DIR}/temp_012_02_result01
	rm ./${TEMP_DIR}/temp_012_02_result
done < ./${DATA_LIST_FILE}

mv ./${TEMP_DIR}/temp_012_02_result01 ./${RESULT_DIR}/RESULT_STARS_LOG_FINAL_OUT.txt
ls -Fal ./${RESULT_DIR}/RESULT_STARS_LOG_FINAL_OUT.txt

#############################

echo -n "## DONE $0 : "
date
