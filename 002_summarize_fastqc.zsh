#!/bin/zsh

##############################
## 002_summarize_fastqc.zsh
#############################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh is exist"
    source 00000setup.zsh
    
    echo "## TOOL_FASTQC : ${TOOL_FASTQC}"
    echo "## "`${TOOL_FASTQC} -v | perl -pe 'chomp;'`
    echo "## OUTPUT_FASTQC_DIR : ${OUTPUT_FASTQC_DIR}"

    echo -n "" > ./${OUTPUT_FASTQC_DIR}/temp_003_01_result01
    
    while read FASTQFILE
    do
	NAME=`echo -n $FASTQFILE | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## USING FASTQ : $NAME (${FASTQFILE})"
	OUTPUT_EACH_DIR=./${OUTPUT_FASTQC_DIR}/${NAME}
	ls -Fal ${OUTPUT_EACH_DIR}
	
	ZIPNAME=./${OUTPUT_EACH_DIR}/${NAME}_fastqc.zip
	OUTTXTNAME=${NAME}_fastqc/fastqc_data.txt
	OUTPNGNAME=${NAME}_fastqc/Images/per_base_quality.png
	OUTSUMNAME=${NAME}_fastqc/summary.txt
	
	unzip -p ${ZIPNAME} ${OUTTXTNAME} > ./${OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt
	unzip -p ${ZIPNAME} ${OUTPNGNAME} > ./${OUTPUT_EACH_DIR}/${NAME}_per_base_quality.png
	unzip -p ${ZIPNAME} ${OUTSUMNAME} > ./${OUTPUT_EACH_DIR}/${NAME}_summary.txt

	echo "Data	${NAME}" > ./${OUTPUT_FASTQC_DIR}/temp_003_01_result
	cat ./${OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt \
	    | grep "^Filename\|File\ type\|Total\ Sequences\|Sequences\ flagged\ as\ poor\ quality\|Sequence\ length\|\%GC"\
		   >> ./${OUTPUT_FASTQC_DIR}/temp_003_01_result
	
	cat ./${OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt \
	    | grep "^>>" \
	    | grep -v ">>END_MODULE" \
	    | perl -pe 's/^\>\>//;' \
	    | cut -f1,2 \
		  >> ./${OUTPUT_FASTQC_DIR}/temp_003_01_result
	
	paste ./${OUTPUT_FASTQC_DIR}/temp_003_01_result01 ./${OUTPUT_FASTQC_DIR}/temp_003_01_result \
	      > ./${OUTPUT_FASTQC_DIR}/temp_003_01_table
	mv ./${OUTPUT_FASTQC_DIR}/temp_003_01_table ./${OUTPUT_FASTQC_DIR}/temp_003_01_result01
	rm ./${OUTPUT_FASTQC_DIR}/temp_003_01_result
	
	echo -n "## summarize ($NAME) done. "
	date
	
    done < ./${RESULT_DIR}/list_fastqName.txt
    
    less ./${OUTPUT_FASTQC_DIR}/temp_003_01_result01 \
	| perl -ne '@l=split(/\t/);for($i=0;$i<=$#l;$i++){if($i==1){print "$l[$i]";}elsif($i % 2 ==0){print "\t$l[$i]"}}' \
	| cut -f2- \
	      > ./${RESULT_DIR}/RESULT_FASTQC_SUMMARY_rawdata.txt
    rm ./${OUTPUT_FASTQC_DIR}/temp_003_01_result01
    
    
else
    ls -Fl ./00000setup.zsh
    echo "## ./00000setup.zsh is not exist..."
    echo -n "## Abort $0 : "
    date
fi

echo -e "## $0 DONE : "
date
