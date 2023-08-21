#!/bin/zsh

#############################
## RSEM calculate expression
#############################
## v.1.0.1

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh : exist"
    source 00000setup.zsh
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

echo "## ${RSEM_REF_DIR} / ${REF_NAME}"

if [ -d ${OUTPUT_RSEM_DIR} ]
then
    echo "## Exist: ${OUTPUT_RSEM_DIR}."
else
    mkdir ${OUTPUT_RSEM_DIR}
    echo "## Made: ${OUTPUT_RSEM_DIR}."
fi

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

#############################

while read SAMPLE
do
	INPUT_BAM_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${SAMPLE}
	ls -Fal ./${INPUT_BAM_EACH_DIR}
	INPUT_BAM=${INPUT_BAM_EACH_DIR}/Aligned.toTranscriptome.out.bam
	ls -Fal ./${INPUT_BAM}
	
	echo -n "## START RSEM calculate-expression : ./${INPUT_BAM} "
	date
	
	OUTPUT_EACH_DIR=${OUTPUT_RSEM_DIR}/RSEM_${SAMPLE}
	if [ -d ./${OUTPUT_EACH_DIR} ]
	then
	   echo "## Exist: ./${OUTPUT_EACH_DIR}."
	else
	   mkdir ${OUTPUT_EACH_DIR}
	   echo "## Made: ./${OUTPUT_EACH_DIR}."
	fi
	
	# STRANDNESS=reverse <---- set up in 00000setup.zsh
	# Illumina kit --> nonstranded: none
	# Illumina kit --> stranded TruSeq: reverse
	# or set manually like as "--strandness reverse"
	echo "## Strandness: ${STRANDEDNESS}"
	
	if [ ${ISPAIREDREAD} -eq 2 ]
	then
	   
	   ${TOOL_RSEM_CALC_EXPR} \
		--alignments \
		--paired-end \
		--num-threads ${THREAD} \
		--strandedness ${STRANDEDNESS} \
		--append-names \
		./${INPUT_BAM} \
		./${STAR_RSEM_REF_DIR}/${REF_NAME} \
		./${OUTPUT_EACH_DIR}/${SAMPLE}
		
		# If you need, another options are OK
		# e.g. --estimate-rspd, etc
	
	   echo -n "# END RSEM calculate-expression ${SAMPLE} (paired-end) -> ./${OUTPUT_EACH_DIR} "
	   date
	   
	elif [ ${ISPAIREDREAD} -eq 1 ]
	then
	   
	   ${TOOL_RSEM_CALC_EXPR} \
		--alignments \
		--num-threads ${THREAD} \
		--strandedness ${STRANDNESS} \
		--append-names \
		./${INPUT_BAM} \
		./${STAR_RSEM_REF_DIR}/${REF_NAME} \
		./${OUTPUT_EACH_DIR}/${SAMPLE}
		
	   # If you need, another options are OK
	   # e.g. --estimate-rspd, etc
	   
	   echo -n "# END RSEM calculate-expression ${SAMPLE} (single-end) -> ./${OUTPUT_EACH_DIR} "
	   date
	   
	else
	    echo "## please set ${ISPAIREDREAD}"
	    exit 0
	fi
	
	ls -Fal ./${OUTPUT_EACH_DIR}/*
	
done < ./${DATA_LIST_FILE}

#############################

echo -n "## DONE $0 : "
date
