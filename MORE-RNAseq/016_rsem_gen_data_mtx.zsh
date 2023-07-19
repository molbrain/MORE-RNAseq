#!/bin/zsh

###################################
## RSEM generate data matrix
###################################

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
    echo -n "# Start RSEM gen-data-matrix with ${CATEGORY}.results "
    date
    
    ls ./${OUTPUT_RSEM_DIR}/RSEM_*.${CATEGORY}.results \
       > ./${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt
    
    ${TOOL_RSEM_GEN_DATA_MTX} \
	`cat ./${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt | perl -pe 's/\n/\ /g;'` \
	> ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.gen_data_mtx.output.txt
    
    cat ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.gen_data_mtx.output.txt \
	| perl -ne 'if(/ENS|L1fli/){s/\"//g; print;}else{chomp;s/^\t//;@l=split(/\t/);@r=("#IDs");foreach $t(@l){$t=~s/^.+\///;$t=~s/\..+$//;@r=(@r,$t);} print join("\t",@r)."\n";}' \
	| sort \
	      > ./${RESULT_DIR}/RSEM.${CATEGORY}.expected_count.matrix.tsv.txt
    
    ls -Fal \
       ./${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.gen_data_mtx.output.txt \
       ./${RESULT_DIR}/RSEM.${CATEGORY}.expected_count.matrix.tsv.txt
done

#############################

echo -n "## DONE $0 : "
date
