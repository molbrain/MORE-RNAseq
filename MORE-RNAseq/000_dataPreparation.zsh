#!/bin/zsh

####################
## Data Preparation
####################

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

for DIRECTORIES in ${RAWDATA_DIR} \
		       ${RESULT_DIR} \
		       ${TEMP_DIR} \
		       ${STAR_RSEM_REF_DIR} \
		       ${ORIGINAL_REF_DIR} \
		       ${OUTPUT_FASTQC_DIR} \
		       ${OUTPUT_FASTQSTATS_DIR} \
		       ${OUTPUT_CUTADAPT_DIR} \
		       ${OUTPUT_TRIMMOMATIC_DIR} \
		       ${OUTPUT_STAR_DIR} \
		       ${OUTPUT_RSEM_DIR} \
		       ${OUTPUT_EDGER_DIR}
do
    if [ -d ./${DIRECTORIES} ]
    then
	echo " Exist ./${DIRECTORIES}"
    else
	echo "## Create ./${DIRECTORIES}"
	mkdir ./${DIRECTORIES}
    fi
done

#############################


if [ -d ./${RAWDATA_DIR} ]
then
    ls ./${RAWDATA_DIR}/* \
	| grep '.fastq.gz\|.fq.gz'$ \
	| sort -u \
	       > ./${RESULT_DIR}/list_fastqName.txt
    
    cat ./${RESULT_DIR}/list_fastqName.txt \
	| perl -pe 's/^.+\///;' \
	| perl -pe 's/\.gz$//;' \
	| perl -pe 's/\.f(ast)?q$//;' \
	| perl -pe 's/_R?\d$//;' \
	| sort -u \
	       > ./${RESULT_DIR}/list_dataName.txt
    
    ls -Fal \
       ./${RESULT_DIR}/list_fastqName.txt \
       ./${RESULT_DIR}/list_dataName.txt
else
    echo "## no rawdata?"
    ls ./${RAWDATA_DIR}
    exit 0
fi
######################
echo -n "## DONE : $0 "
date
