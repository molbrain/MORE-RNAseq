#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

##########################################

THREAD=6
OUTPUT_STAR_DIR=./STAR
OUTPUT_RSEM_DIR=./RSEM
TOOL_RSEM_CALC_EXPR=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-calculate-expression
echo -n "# TOOL_RSEM_CALC_EXPR : "
${TOOL_RSEM_CALC_EXPR} --version

RSEM_REF_DIR=Ref_GRCm38
REF_NAME=GRCm38.102
echo "# ${RSEM_REF_DIR} / ${REF_NAME}"

if [ -d ${OUTPUT_RSEM_DIR} ]
then
    echo "# Exist: ${OUTPUT_RSEM_DIR}."
else
    mkdir ${OUTPUT_RSEM_DIR}
    echo "# Made: ${OUTPUT_RSEM_DIR}."
fi

for NUM in ___SAMPLE___
do
    
    
    INPUT_BAM_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${NUM}
    if [ -d ${INPUT_BAM_EACH_DIR} ]
    then
	echo "# Exist: ${INPUT_BAM_EACH_DIR}."
    else
	mkdir ${INPUT_BAM_EACH_DIR}
	echo "# Made: ${INPUT_BAM_EACH_DIR}."
    fi
    
    INPUT_BAM=${INPUT_BAM_EACH_DIR}/Aligned.toTranscriptome.out.bam
    ls -Fal ${INPUT_BAM}
    echo -n "# START RSEM calculate-expression : ${INPUT_BAM} "
    date
    
    OUTPUT_EACH_DIR=${OUTPUT_RSEM_DIR}/RSEM_${NUM}
    if [ -d ${OUTPUT_EACH_DIR} ]
    then
	echo "# Exist: ${OUTPUT_EACH_DIR}."
    else
	mkdir ${OUTPUT_EACH_DIR}
	echo "# Made: ${OUTPUT_EACH_DIR}."
    fi
    
    #TOOL_RSEM_PREP_REF=${DEF_DIR}/bin/RSEM-1.3.3/bin/rsem-prepare-reference
    #TOOL_RSEM_GEN_DATA_MTX=${DEF_DIR}/bin/RSEM-1.3.3/bin/rsem-generate-data-matrix
    #TOOL_RSEM_CALC_EXPR=${DEF_DIR}/bin/RSEM-1.3.3/bin/rsem-calculate-expression

    STRANDNESS=reverse
    # Illumina stranded TruSeq: reverse / nonstranded: none
    # --strandness reverse \
    echo "# Strandness: ${STRANDNESS}"
    
    ${TOOL_RSEM_CALC_EXPR} \
	--alignments \
	--paired-end \
	--num-threads ${THREAD} \
	--strandedness ${STRANDNESS} \
	--append-names \
	${INPUT_BAM} \
	${RSEM_REF_DIR}/${REF_NAME} \
	${OUTPUT_EACH_DIR}/${NUM}
    
	#--estimate-rspd \
	
    ls -Fal ${OUTPUT_EACH_DIR}/*
    
    echo -n "# END RSEM calculate-expression ${SAMPLE} (pair end) -> ${OUTPUT_EACH_DIR} "
    date
    
done

echo "## $0 DONE. "
date
