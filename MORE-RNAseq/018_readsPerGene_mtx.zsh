#!/bin/zsh

##################################
## Generate readPerGene matrix
##################################
## v.1.0.1

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

echo "## OUTPUT_STAR_DIR : ./${OUTPUT_STAR_DIR}"

#DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

echo "## readPerGene data in ./${OUTPUT_STAR_DIR} -> matrix "

if [ -e ./${TEMP_DIR}/temp_018_each ]
then
    rm ./${TEMP_DIR}/temp_018_each
fi
if [ -e ./${TEMP_DIR}/temp_018_joined ]
then
    rm ./${TEMP_DIR}/temp_018_joined
fi
if [ -e ./${TEMP_DIR}/temp_018_table ]
then
    rm ./${TEMP_DIR}/temp_018_table
fi

ls ./${OUTPUT_STAR_DIR}/STAR_*/ReadsPerGene.out.tab > ./${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt

echo "#IDs" > ./${TEMP_DIR}/temp_018_table
cut -f1 `head -1 ./${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt` | grep "ENS\|L1fli" | sort -u >> ./${TEMP_DIR}/temp_018_table

while read FILENAME
do
    echo "## filename $FILENAME "
    echo -n "#IDs	" > ./${TEMP_DIR}/temp_018_each
    echo $FILENAME | perl -pe 's/\/ReadsPerGene\.out\.tab//;s/^.+STAR_//;' >> ./${TEMP_DIR}/temp_018_each
    cut -f1,2 $FILENAME | grep "ENS\|L1fli" | sort -u >> ./${TEMP_DIR}/temp_018_each
    diff --report <(cut -f1 ./${TEMP_DIR}/temp_018_table) <(cut -f1 ./${TEMP_DIR}/temp_018_each)
    join -t "	" ./${TEMP_DIR}/temp_018_table ./${TEMP_DIR}/temp_018_each > ./${TEMP_DIR}/temp_018_joined
    mv ./${TEMP_DIR}/temp_018_joined ./${TEMP_DIR}/temp_018_table
    rm ./${TEMP_DIR}/temp_018_each
done < ./${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt

mv ./${TEMP_DIR}/temp_018_table ./${RESULT_DIR}/STAR_ReadsPerGene.tsv.txt
ls -Fal ./${RESULT_DIR}/STAR_ReadsPerGene.tsv.txt

#############################

echo -n "## DONE $0 : "
date
