#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

##########################################

OUTPUT_RSEM_DIR=./RSEM

if [ -d ${OUTPUT_RSEM_DIR} ]
then
    echo "# Exist: ${OUTPUT_RSEM_DIR}."
else
    mkdir ${OUTPUT_RSEM_DIR}
    echo "# Made: ${OUTPUT_RSEM_DIR}."
fi

for CATEGORY in genes isoforms
do
    
    if [ -e temp_017_each ]
    then
	rm temp_017_each
    fi
    if [ -e temp_017_joined ]
    then
	rm temp_017_joined
    fi
    if [ -e temp_017_table ]
    then
	rm temp_017_table
    fi

    echo "#IDs" >  temp_017_table
    cut -f1 `head -1 ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt` | grep "ENS\|L1fli" | sort -u >> temp_017_table
    while read FILENAME
    do
	echo "# filenamme ${FILENAME} "
	echo -n "#IDs	" > temp_017_each
	echo ${FILENAME} | perl -pe 's/^.+\///;s/\..+$//;' >> temp_017_each
	cut -f1,6 ${FILENAME} | grep "ENS\|L1fli" | sort -u >> temp_017_each
	diff --report <(cut -f1 temp_017_table) <(cut -f1 temp_017_each)
	join -t "	" temp_017_table temp_017_each > temp_017_joined
	mv temp_017_joined temp_017_table
	rm temp_017_each
    done < ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt
    mv temp_017_table ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.TPM.matrix.tsv.txt
    

    echo "#id" >  temp_017_table
    cut -f1 `head -1 ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt` | grep "ENS\|L1fli" | sort -u >> temp_017_table
    while read FILENAME
    do
	echo "# filename ${FILENAME} "
	echo -n "#id	" > temp_017_each
	echo ${FILENAME} | perl -pe 's/^.+\///;s/\..+$//;' >> temp_017_each
	cut -f1,7 ${FILENAME} | grep "ENS\|L1fli" | sort -u >> temp_017_each
	diff --report <(cut -f1 temp_017_table) <(cut -f1 temp_017_each)
	join -t "	" temp_017_table temp_017_each > temp_017_joined
	mv temp_017_joined temp_017_table
	rm temp_017_each
    done < ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt
    mv temp_017_table ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.FPKM.matrix.tsv.txt


    
    ls -Falh ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.*M.matrix.tsv.txt
    

done

echo -n "# END RSEM gen-data-matrix (tsv) "
date
    
echo "## $0 DONE. "
date
