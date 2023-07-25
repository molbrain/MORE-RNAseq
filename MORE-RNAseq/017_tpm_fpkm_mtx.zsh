#!/bin/zsh

##################################
## Generate TPM and FPKM matrix
##################################

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

#OUTPUT_STAR_DIR=./TEMP/STAR
#OUTPUT_RSEM_DIR=./TEMP/RSEM
#TOOL_RSEM_PREP_REF=rsem-prepare-reference
#TOOL_RSEM_GEN_DATA_MTX=rsem-generate-data-matrix
#TOOL_RSEM_CALC_EXPR=rsem-calculate-expression
#STAR_RSEM_REF_DIR=Reference
#REF_NAME=GRCm38.102

echo "## OUTPUT_RSEM_DIR : ./${OUTPUT_RSEM_DIR}"

#DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

#for CATEGORY in genes isoforms
for CATEGORY in genes
do
    for DATA in 6 7
    do
	DATA_LIST_FILE=${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt
	if [ -e ${DATA_LIST_FILE} ]
	then
	   ls -Fal ./${DATA_LIST_FILE}
	else
	   echo "## NO FILE : ./${DATA_LIST_FILE} "
	   exit 0
	fi
	
	echo "## ${CATEGORY} column ${DATA} (6:TPM, 7:FPKM) -> each matrix "
	
	if [ -e ./${TEMP_DIR}/temp_017_each ]
	then
	    rm ./${TEMP_DIR}/temp_017_each
	fi
	if [ -e ./${TEMP_DIR}/temp_017_joined ]
	then
	    rm ./${TEMP_DIR}/temp_017_joined
	fi
	if [ -e ./${TEMP_DIR}/temp_017_table ]
	then
	    rm ./${TEMP_DIR}/temp_017_table
	fi
	
	echo "#IDs" >  ./${TEMP_DIR}/temp_017_table
	cut -f1 `head -1 ./${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt` \
	    | grep "ENS\|L1fli" \
	    | sort -u \
		   >> ./${TEMP_DIR}/temp_017_table
	while read FILENAME
	do
	    echo "# filename ${FILENAME} "
	    echo -n "#IDs	" \
		 > ./${TEMP_DIR}/temp_017_each
	    echo ${FILENAME} \
		| perl -pe 's/^.+\///;s/\..+$//;' \
		       >> ./${TEMP_DIR}/temp_017_each
	    cut -f1,${DATA} ${FILENAME} \
		| grep "ENS\|L1fli" \
		| sort -u \
		       >> ./${TEMP_DIR}/temp_017_each
	    diff --report \
		 <(cut -f1 ./${TEMP_DIR}/temp_017_table) \
		 <(cut -f1 ./${TEMP_DIR}/temp_017_each)
	    
	    join -t "	" \
		 ./${TEMP_DIR}/temp_017_table \
		 ./${TEMP_DIR}/temp_017_each \
		 > ./${TEMP_DIR}/temp_017_joined
	    
	    mv ./${TEMP_DIR}/temp_017_joined \
	       ./${TEMP_DIR}/temp_017_table
	    rm ./${TEMP_DIR}/temp_017_each
	    
	done < ./${DATA_LIST_FILE}
	mv ./${TEMP_DIR}/temp_017_table \
	   ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.${DATA}.matrix.tsv.txt
    done
    
    mv ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.6.matrix.tsv.txt \
       ./${RESULT_DIR}/RSEM.${CATEGORY}.TPM.matrix.tsv.txt
    
    mv ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.7.matrix.tsv.txt \
       ./${RESULT_DIR}/RSEM.${CATEGORY}.FPKM.matrix.tsv.txt
    
    ls -Fal ./${RESULT_DIR}/RSEM.${CATEGORY}.*M.matrix.tsv.txt
done

#############################

echo -n "## DONE $0 : "
date
