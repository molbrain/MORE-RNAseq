#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

##########################################

OUTPUT_STAR_DIR=./STAR

if [ -d ${OUTPUT_STAR_DIR} ]
then
    echo "# Exist: ${OUTPUT_STAR_DIR}."
else
    echo "# NOT FOUND: ${OUTPUT_STAR_DIR}."
fi

if [ -e temp_018_each ]
then
    rm temp_018_each
fi
if [ -e temp_018_joined ]
then
    rm temp_018_joined
fi
if [ -e temp_018_table ]
then
    rm temp_018_table
fi


ls ${OUTPUT_STAR_DIR}/STAR_*/ReadsPerGene.out.tab > ${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt

echo "#IDs" >  temp_018_table
cut -f1 `head -1 ${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt` | grep "ENS\|L1fli" | sort -u >> temp_018_table
while read FILENAME
do
    echo "# filename $FILENAME "
    echo -n "#IDs	" > temp_018_each
    echo $FILENAME | perl -pe 's/\/ReadsPerGene\.out\.tab//;s/^.+STAR_//;' >> temp_018_each
    cut -f1,2 $FILENAME | grep "ENS\|L1fli" | sort -u >> temp_018_each
    diff --report <(cut -f1 temp_018_table) <(cut -f1 temp_018_each)
    join -t "	" temp_018_table temp_018_each > temp_018_joined
    mv temp_018_joined temp_018_table
    rm temp_018_each
done < ${OUTPUT_STAR_DIR}/list_STAR_ReadsPerGene_files.txt

mv temp_018_table ${OUTPUT_STAR_DIR}/STAR_ReadsPerGene.tsv.txt
ls -Falh ${OUTPUT_STAR_DIR}/STAR_ReadsPerGene.tsv.txt
    
    
echo "## $0 DONE. "
date
