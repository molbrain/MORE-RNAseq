#!/bin/zsh

############################################
## summarize FastQC & fastq-stats (rawdata)
############################################

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

echo "## OUTPUT_FASTQC_DIR : ./${OUTPUT_FASTQC_DIR}"
echo "## OUTPUT_FASTQSTATS_DIR : ./${OUTPUT_FASTQSTATS_DIR}"

FASTQ_LIST_FILE=${RESULT_DIR}/list_fastqName.txt

#############################

echo "## Summarize of FastQC results by $0."

echo -n "" > ./${TEMP_DIR}/temp_003_01_result01
while read FASTQFILE
do
	echo "## ${FASTQFILE}"
	NAME=`echo -n ${FASTQFILE} | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## ${NAME}"
	FASTQC_OUTPUT_EACH_DIR=${OUTPUT_FASTQC_DIR}/${NAME}
	FASTQC_FILENAME=${FASTQC_OUTPUT_EACH_DIR}/${NAME}_fastqc.zip
	
	OUTTXTNAME=${NAME}_fastqc/fastqc_data.txt
	OUTPNGNAME=${NAME}_fastqc/Images/per_base_quality.png
	OUTSUMNAME=${NAME}_fastqc/summary.txt
	
	unzip -p ./${FASTQC_FILENAME} ${OUTTXTNAME} > ./${FASTQC_OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt
	unzip -p ./${FASTQC_FILENAME} ${OUTPNGNAME} > ./${FASTQC_OUTPUT_EACH_DIR}/${NAME}_per_base_quality.png
	unzip -p ./${FASTQC_FILENAME} ${OUTPNGNAME} > ./${FASTQC_OUTPUT_EACH_DIR}/${NAME}_summary.txt
	
	echo "Data	${NAME}" > ./${TEMP_DIR}/temp_003_01_result
	
	less ./${FASTQC_OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt \
	    | grep "^Filename\|File\ type\|Total\ Sequences\|Sequences\ flagged\ as\ poor\ quality\|Sequence\ length\|\%GC"\
		   >> ./${TEMP_DIR}/temp_003_01_result
	
	less ./${FASTQC_OUTPUT_EACH_DIR}/${NAME}_fastqc_data.txt \
	    | grep "^>>" \
	    | grep -v ">>END_MODULE" \
	    | perl -pe 's/^\>\>//;' \
	    | cut -f1,2 \
		   >> ./${TEMP_DIR}/temp_003_01_result
	
	paste ./${TEMP_DIR}/temp_003_01_result01 ./${TEMP_DIR}/temp_003_01_result > ./${TEMP_DIR}/temp_003_01_table
	mv ./${TEMP_DIR}/temp_003_01_table ./${TEMP_DIR}/temp_003_01_result01
	rm ./${TEMP_DIR}/temp_003_01_result
done < ./${FASTQ_LIST_FILE}

less ./${TEMP_DIR}/temp_003_01_result01 \
    | perl -ne '@l=split(/\t/);for($i=0;$i<=$#l;$i++){if($i==1){print "$l[$i]";}elsif($i % 2 ==0){print "\t$l[$i]"}}' \
    | cut -f2- \
    > ./${RESULT_DIR}/RESULT_FASTQC_SUMMARY_rawdata.txt

ls -Fal ./${RESULT_DIR}/RESULT_FASTQC_SUMMARY_rawdata.txt
rm ./${TEMP_DIR}/temp_003_01_result01

#############################

echo "## Summarize of Fastq-stats results by $0."

echo "data\nfilename" \
    > ./${TEMP_DIR}/temp_003_002_joining
cat `ls ${OUTPUT_FASTQSTATS_DIR}/*/fastq-stats.txt | head -1` \
    | cut -f1 \
    >> ./${TEMP_DIR}/temp_003_002_joining

while read FASTQFILE
do
	echo "## ${FASTQFILE}"
	NAME=`echo -n ${FASTQFILE} | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## ${NAME}"
	FASTQSTATS_FILENAME=${OUTPUT_FASTQSTATS_DIR}/${NAME}/fastq-stats.txt
	
	echo "${NAME}\n${FASTQFILE}" > ./${TEMP_DIR}/temp_003_002_each
	
	cut -f2 ./${FASTQSTATS_FILENAME} \
		   >> ./${TEMP_DIR}/temp_003_002_each 
	
	paste ./${TEMP_DIR}/temp_003_002_joining ./${TEMP_DIR}/temp_003_002_each \
	    > ./${TEMP_DIR}/temp_003_002_joined
	mv ./${TEMP_DIR}/temp_003_002_joined ./${TEMP_DIR}/temp_003_002_joining
	rm ./${TEMP_DIR}/temp_003_002_each
done < ./${FASTQ_LIST_FILE}

mv ./${TEMP_DIR}/temp_003_002_joining ./${RESULT_DIR}/RESULT_FASTQSTATS_SUMMARY_rawdata.txt
ls -Fal ./${RESULT_DIR}/RESULT_FASTQSTATS_SUMMARY_rawdata.txt

#############################

echo -n "## DONE $0 : "
date
