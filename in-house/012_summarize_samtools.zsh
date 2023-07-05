#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

########################################################

for STATS in toTranscriptome sortedByCoord
do
    
    echo "# Summarize of ${STATS}.bams by samtools stats results by $0."
    
    echo "Data" > temp_012_01_result01_${STATS}
    
    FIRSTONE=`cat list_dataName.txt | head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
    less ./STAR/STAR_${FIRSTONE}/samtools.stats.Aligned.${STATS}.out.bam.txt \
	| grep ^SN \
	| cut -f2 \
	| perl -pe 's/\:$//;' \
	       >> temp_012_01_result01_${STATS}
    
    if [ -f temp_012_01_table_${STATS} ]
    then
	rm temp_012_01_table_${STATS}
    fi

    if [ -f temp_012_01_result_${STATS} ]
    then
	rm temp_012_01_result_${STATS}
    fi
    
    while read DATANAME
    do
	echo "## ${DATANAME} "
	FILENAME=./STAR/STAR_${DATANAME}/samtools.stats.Aligned.${STATS}.out.bam.txt
	
	echo ${DATANAME} > temp_012_01_result_${STATS}
	less ${FILENAME} \
	    | grep ^SN \
	    | cut -f3 \
		  >> temp_012_01_result_${STATS}
	
	paste temp_012_01_result01_${STATS} temp_012_01_result_${STATS} > temp_012_01_table_${STATS}
	mv temp_012_01_table_${STATS} temp_012_01_result01_${STATS}
	rm temp_012_01_result_${STATS}
	
    done < list_dataName.txt
    
    mv temp_012_01_result01_${STATS} RESULT_SAMTOOLS_STARS_${STATS}.txt
    
done


echo "# Summarize of STAR/Logfinal.out as STAR logs"

echo "Data" > temp_012_02_result01
FIRSTOUT=`cat list_dataName.txt | head -1 | perl -pe 'chomp;s/[\n\r]//g;s/$/\n/;'`
less ./STAR/STAR_${FIRSTOUT}/Log.final.out \
    | cut -f 1 \
    | perl -pe 's/\ +\|$//;s/^\ +//;s/\ +$//;' \
	   >> temp_012_02_result01

if [ -f temp_012_02_table ]
then
    rm temp_012_02_table
fi

if [ -f temp_012_02_result ]
then
    rm temp_012_02_result
fi


while read SAMPLE
do

    echo "${SAMPLE}" > temp_012_02_result
    less ./STAR/STAR_${SAMPLE}/Log.final.out \
	| cut -f 2 \
	| perl -ne 'if(/\:$/){print"\n";}else{print;}' \
	       >> temp_012_02_result

        paste temp_012_02_result01 temp_012_02_result > temp_012_02_table
        mv temp_012_02_table temp_012_02_result01
        rm temp_012_02_result
    
done < list_dataName.txt

mv temp_012_02_result01 RESULT_STARS_LOG_FINAL_OUT.txt


echo -n "# DONE $0 : "
date
