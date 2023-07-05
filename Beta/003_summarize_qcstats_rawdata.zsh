#!/bin/zsh

##################################
## 003_summarize_fastq_rawdata.zsh
##################################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
  echo "## ./00000setup.zsh is exist !!!!!"
  source 00000setup.zsh
else
  echo "## ./00000setup.zsh is not exist !!!!!"
  
  OUTPUT_FASTQC_DIR=./FASTQC
  echo "## OUTPUT_FASTQC_DIR : ${OUTPUT_FASTQC_DIR}"
  
  OUTPUT_FASTQSTATS_DIR=./FASTQSTATS
echo "## OUTPUT_FASTQSTATS_DIR : ${OUTPUT_FASTQSTATS_DIR}"
  fi


echo "## Summarize of FastQC results by $0."

echo -n "" > temp_003_01_result01

while read DATANAME
do
    for PAIR in 1 2
    do
	
	echo "## ${DATANAME} ${PAIR}"
	FILENAME=${OUTPUT_FASTQC_DIR}/${DATANAME}_R${PAIR}/${DATANAME}_${PAIR}_fastqc.zip
	
	OUTTXTNAME=${DATANAME}_${PAIR}_fastqc/fastqc_data.txt
	OUTPNGNAME=${DATANAME}_${PAIR}_fastqc/Images/per_base_quality.png
	OUTSUMNAME=${DATANAME}_${PAIR}_fastqc/summary.txt
	
	unzip -p ${FILENAME} ${OUTTXTNAME} > FASTQC/${DATANAME}_R${PAIR}_fastqc_data.txt
	unzip -p ${FILENAME} ${OUTPNGNAME} > FASTQC/${DATANAME}_R${PAIR}_per_base_quality.png
	unzip -p ${FILENAME} ${OUTPNGNAME} > FASTQC/${DATANAME}_R${PAIR}_summary.txt
	
	echo "Data	${DATANAME}" > temp_003_01_result
	
	less ${OUTPUT_FASTQC_DIR}/${DATANAME}_R${PAIR}_fastqc_data.txt \
	    | grep "^Filename\|File\ type\|Total\ Sequences\|Sequences\ flagged\ as\ poor\ quality\|Sequence\ length\|\%GC"\
		   >> temp_003_01_result
	
	less ${OUTPUT_FASTQC_DIR}/${DATANAME}_R${PAIR}_fastqc_data.txt \
	    | grep "^>>" \
	    | grep -v ">>END_MODULE" \
	    | perl -pe 's/^\>\>//;' \
	    | cut -f1,2 \
		  >> temp_003_01_result
	
	paste temp_003_01_result01 temp_003_01_result > temp_003_01_table
	mv temp_003_01_table temp_003_01_result01
	rm temp_003_01_result

    done
done < list_fileName.txt

less temp_003_01_result01 \
    | perl -ne '@l=split(/\t/);for($i=0;$i<=$#l;$i++){if($i==1){print "$l[$i]";}elsif($i % 2 ==0){print "\t$l[$i]"}}' \
    | cut -f2- > RESULT_FASTQC_SUMMARY_rawdata.txt
rm temp_003_01_result01


echo "## Summarize of Fastq-stats results by $0."

echo "data\nfilename" > temp_003_002_joining
cat `ls ${OUTPUT_FASTQSTATS_DIR}/*/fastq-stats.txt | head -1` | cut -f1 >> temp_003_002_joining

while read RESULTS
do
    for PAIRS in 1 2
    do
	echo "## ${RESULTS} ${PAIRS}"
    
	FASTQNAME=${RESULTS}_${PAIRS}.fq.gz
	RESULTNAME=${OUTPUT_FASTQSTATS_DIR}/${RESULTS}_R${PAIRS}/fastq-stats.txt
	
	echo "${RESULTS}" > temp_003_002_each
	echo "${FASTQNAME}" >> temp_003_002_each
	cut -f2 ${RESULTNAME} >> temp_003_002_each 
	paste temp_003_002_joining temp_003_002_each > temp_003_002_joined
	mv temp_003_002_joined temp_003_002_joining
	rm temp_003_002_each
    done	
done < list_fileName.txt

mv temp_003_002_joining RESULT_FASTQSTATS_SUMMARY_rawdata.txt

echo -n "## DONE $0 : "
date
