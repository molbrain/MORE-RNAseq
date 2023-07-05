#!/bin/zsh

#############################
## RSEM_calc_expr
#############################


echo -n "## $0 start : "
date


#############################

OUTPUT_STAR_DIR=./STAR

STAR_RSEM_REF_DIR=./Ref
echo "# STAR_RSEM_REF_DIR : ${STAR_RSEM_REF_DIR}"

THREAD=6
echo "# THREAD : ${THREAD}"

STRANDNESS=reverse
# Illumina stranded TruSeq: reverse / nonstranded: none
echo "# Strandness: ${STRANDNESS} <- llumina stranded TruSeq: reverse / nonstranded: none"

GENOME=GRCm38
ENSRELEASE=102
# human -> GRCh38, mouse -> GRCm38, chimp -> ??, marmoset -> ??
REF_NAME=${GENOME}.${ENSRELEASE}
echo "# REF_NAME : $REF_NAME"


#############################

TOOL_RSEM_CALC_EXPR=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-calculate-expression
#TOOL_RSEM_PREP_REF=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-prepare-reference
#TOOL_RSEM_GEN_DATA_MTX=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-generate-data-matrix

echo -n "# TOOL_RSEM_CALC_EXPR : "
${TOOL_RSEM_CALC_EXPR} --version

OUTPUT_RSEM_DIR=./RSEM
if [ -d ${OUTPUT_RSEM_DIR} ]
then
    echo "# Exist: ${OUTPUT_RSEM_DIR}."
else
    mkdir ${OUTPUT_RSEM_DIR}
    echo "# Create: ${OUTPUT_RSEM_DIR}."
fi


#############################

for NUM in ___SAMPLE___
do
    
    echo -n "# Sample: $NUM "
    date
    
    INPUT_BAM_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${NUM}
    if [ -d ${INPUT_BAM_EACH_DIR} ]
    then
	echo "# Exist: ${INPUT_BAM_EACH_DIR}."
    else
	mkdir ${INPUT_BAM_EACH_DIR}
	echo "# Create: ${INPUT_BAM_EACH_DIR}."
    fi
    
    INPUT_BAM=${INPUT_BAM_EACH_DIR}/Aligned.toTranscriptome.out.bam
    ls -Fal ${INPUT_BAM}
    echo -n "# STAR mapped BAM files : ${INPUT_BAM} "
    date
    
    OUTPUT_EACH_DIR=${OUTPUT_RSEM_DIR}/RSEM_${NUM}
    if [ -d ${OUTPUT_EACH_DIR} ]
    then
	echo "# Exist: ${OUTPUT_EACH_DIR}."
    else
	mkdir ${OUTPUT_EACH_DIR}
	echo "# Create: ${OUTPUT_EACH_DIR}."
    fi
    
    
    # STRANDNESS=reverse
    # Illumina stranded TruSeq: reverse / nonstranded: none
    # --strandness reverse \
    echo "# Strandness: ${STRANDNESS} <- llumina stranded TruSeq: reverse / nonstranded: none"
    
    echo -n "# Start RSEM calculate-expression : ${NUM} ..."
    date
    
    ${TOOL_RSEM_CALC_EXPR} \
	--alignments \
	--paired-end \
	--num-threads ${THREAD} \
	--strandedness ${STRANDNESS} \
	--append-names \
	${INPUT_BAM} \
	${RSEM_REF_DIR}/${REF_NAME} \
	${OUTPUT_EACH_DIR}/${NUM}
	
	
	### Other settings
	#--estimate-rspd \
	### 
    
    
    echo -n "# End RSEM calculate-expression ${NUM} -> ${OUTPUT_EACH_DIR} "
    date
    
    ls -Fal ${OUTPUT_EACH_DIR}/*
    
done

#############################


echo "## $0 DONE. "
date
