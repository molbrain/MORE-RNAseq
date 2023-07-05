#!/bin/zsh

################################
## 008_summarize_qc_cleaned.zsh
################################


echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

########################################################

echo "# Summarize of FastQC results by $0."

echo -n "" > temp_008_01_result01

while read DATANAME
do
    for PAIR in 1 2
    do
	
	echo "## ${DATANAME} ${PAIR}"
	FILENAME=./FASTQC/trimmed_${DATANAME}_R${PAIR}/trimmed_${DATANAME}_R${PAIR}_fastqc.zip
	
	OUTTXTNAME=trimmed_${DATANAME}_R${PAIR}_fastqc/fastqc_data.txt
	OUTPNGNAME=trimmed_${DATANAME}_R${PAIR}_fastqc/Images/per_base_quality.png
	OUTSUMNAME=trimmed_${DATANAME}_R${PAIR}_fastqc/summary.txt
	
	unzip -p ${FILENAME} ${OUTTXTNAME} > ./FASTQC/trimmed_${DATANAME}_R${PAIR}_fastqc_data.txt
	unzip -p ${FILENAME} ${OUTPNGNAME} > ./FASTQC/trimmed_${DATANAME}_R${PAIR}_per_base_quality.png
	unzip -p ${FILENAME} ${OUTPNGNAME} > ./FASTQC/trimmed_${DATANAME}_R${PAIR}_summary.txt
	
	echo "Data	${DATANAME}" > temp_008_01_result
	
	less ./FASTQC/trimmed_${DATANAME}_R${PAIR}_fastqc_data.txt \
	    | grep "^Filename\|File\ type\|Total\ Sequences\|Sequences\ flagged\ as\ poor\ quality\|Sequence\ length\|\%GC"\
		   >> temp_008_01_result
	
	less ./FASTQC/trimmed_${DATANAME}_R${PAIR}_fastqc_data.txt \
	    | grep "^>>" \
	    | grep -v ">>END_MODULE" \
	    | perl -pe 's/^\>\>//;' \
	    | cut -f1,2 \
		  >> temp_008_01_result
	
	paste temp_008_01_result01 temp_008_01_result > temp_008_01_table
	mv temp_008_01_table temp_008_01_result01
	rm temp_008_01_result

    done
done < list_fileName.txt

less temp_008_01_result01 \
    | perl -ne '@l=split(/\t/);for($i=0;$i<=$#l;$i++){if($i==1){print "$l[$i]";}elsif($i % 2 ==0){print "\t$l[$i]"}}' \
    | cut -f2- > RESULT_FASTQC_SUMMARY_cleanted.txt
rm temp_008_01_result01


echo "# Summarize of Fastq-stats results by $0."

echo "data\nfilename" > temp_008_002_joining
cat `ls FASTQSTATS/*/fastq-stats.txt | head -1` | cut -f1 >> temp_008_002_joining

while read RESULTS
do
    for PAIRS in 1 2
    do
	echo "# ${RESULTS} ${PAIRS}"
    
	FASTQNAME=trimmed_${RESULTS}_${PAIRS}.fq.gz
	RESULTNAME=./FASTQSTATS/trimmed_${RESULTS}_R${PAIRS}/fastq-stats.txt
	
	echo "${RESULTS}" > temp_008_002_each
	echo "${FASTQNAME}" >> temp_008_002_each
	cut -f2 ${RESULTNAME} >> temp_008_002_each 
	paste temp_008_002_joining temp_008_002_each > temp_008_002_joined
	mv temp_008_002_joined temp_008_002_joining
	rm temp_008_002_each
    done	
done < list_fileName.txt

mv temp_008_002_joining RESULT_FASTQSTATS_SUMMARY_cleaned.txt

echo -n "# DONE $0 : "
date
