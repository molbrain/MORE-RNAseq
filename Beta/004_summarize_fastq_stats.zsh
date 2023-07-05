#!/bin/zsh

##########################
## 001_fastqc.zsh
##########################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh is exist"
    source 00000setup.zsh
    
    echo "## TOOL_FASTQSTATS : ${TOOL_FASTQSTATS}"
    echo "## "`${TOOL_FASTQSTATS} --help 2>&1 | grep Version`
    echo "## OUTPUT_FASTQSTATS_DIR : ${OUTPUT_FASTQSTATS_DIR}"
    
    echo "data\nfilename" > ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joining
    cat `ls ./${OUTPUT_FASTQSTATS_DIR}/*/fastq-stats.txt | head -1` \
	| cut -f1 >> ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joining

    
    while read FASTQFILE
    do
	NAME=`echo -n $FASTQFILE | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## USING FASTQ : $NAME (${FASTQFILE})"
	ls -Fal ${FASTQFILE}
	
	OUTPUT_EACH_DIR=./${OUTPUT_FASTQSTATS_DIR}/${NAME}
	ls -Fl ${OUTPUT_EACH_DIR}
	
	RESULTNAME=${OUTPUT_EACH_DIR}/fastq-stats.txt
	echo ${NAME} > ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_each
	echo `echo -n ${FASTQFILE} | perl -pe 's/^.+\///;'` >> ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_each
	cut -f2 ${RESULTNAME} >> ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_each 
	paste ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joining ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_each \
	      > ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joined
	mv ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joined ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joining
	rm ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_each

	
	echo -n "## summarize fastq-stats ($NAME) done. "
	date
    done < ./${RESULT_DIR}/list_fastqName.txt

    mv ./${OUTPUT_FASTQSTATS_DIR}/temp_003_002_joining ./${RESULT_DIR}/RESULT_FASTQSTATS_SUMMARY_rawdata.txt
    echo -n "## summarize fastq-stats DONE. "
    date
    ls ./${RESULT_DIR}/RESULT_FASTQSTATS_SUMMARY_rawdata.txt
    
else
    ls -Fl ./00000setup.zsh
  echo "## ./00000setup.zsh is not exist..."
  echo -n "## Abort $0 : "
  date
fi

echo -e "## $0 DONE : "
date


