#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

##########################################

OUTPUT_RSEM_DIR=./RSEM
TOOL_RSEM_GEN_DATA_MTX=~/bin/RSEM-1.3.3/bin/rsem-generate-data-matrix

if [ -d ${OUTPUT_RSEM_DIR} ]
then
    echo "# Exist: ${OUTPUT_RSEM_DIR}."
else
    mkdir ${OUTPUT_RSEM_DIR}
    echo "# Made: ${OUTPUT_RSEM_DIR}."
fi

for CATEGORY in genes isoforms
do
    
    echo -n "# Start RSEM gen-data-matrix with ${CATEGORY}.results "
    date
    
    ls ${OUTPUT_RSEM_DIR}/RSEM_*/*${CATEGORY}.results > ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt
    
    
    ${TOOL_RSEM_GEN_DATA_MTX} \
	`cat ${OUTPUT_RSEM_DIR}/list_RSEM_${CATEGORY}_results_files.txt | perl -pe 's/\n/\ /g;'` \
	> ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.gen_data_mtx.output.txt
    
    cat ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.gen_data_mtx.output.txt \
	| perl -ne 'if(/ENS|L1fli/){s/\"//g; print;}else{chomp;s/^\t//;@l=split(/\t/);@r=("#IDs");foreach $t(@l){$t=~s/^.+\///;$t=~s/\..+$//;@r=(@r,$t);} print join("\t",@r)."\n";}' \
	| sort \
	      > ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.expected_count.matrix.tsv.txt
    
    ls -Falh ${OUTPUT_RSEM_DIR}/RSEM.${CATEGORY}.expected_count.matrix.tsv.txt
    
done

echo "## $0 DONE. "
date
