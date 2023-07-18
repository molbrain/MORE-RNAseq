#!/bin/zsh

#############################
## STAR_mapping
#############################

echo -n "## $0 start : 
date

#############################

CLEAN_FASTQ_DIR=./TRIMMOMATIC

#STAR_RSEM_REF_DIR=./Ref
ls -Fal ./${STAR_RSEM_REF_DIR}
echo "# STAR_RSEM_REF_DIR : ./${STAR_RSEM_REF_DIR}"

THREAD=4
echo "# THREAD : $THREAD"

#############################


TOOL_STAR=STAR
echo -n "TOOL_STAR : ${TOOL_STAR} "
${TOOL_STAR} | grep version

#OUTPUT_STAR_DIR=./Result/STAR
if [ -d ./${OUTPUT_STAR_DIR} ]
then
    echo "# Exist: ./${OUTPUT_STAR_DIR}."
else
    mkdir ./${OUTPUT_STAR_DIR}
    echo "# Create: ./${OUTPUT_STAR_DIR}."
fi


#############################

echo -n "# Sample: ${SAMPLE} "
date

### This example is for typically paired-end data
### Please modify if you use single-end data

INPUT_FASTQ_R1=`ls ${CLEAN_FASTQ_DIR}/trimmed_${SAMPLE}*R1.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
INPUT_FASTQ_R2=`ls ${CLEAN_FASTQ_DIR}/trimmed_${SAMPLE}*R2.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
echo "# multifile-fastq-set R1 : ${INPUT_FASTQ_R1}"
echo "# multifile-fastq-set R2 : ${INPUT_FASTQ_R2}"
ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*R1.fq.gz
ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*R2.fq.gz

OUTPUT_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${SAMPLE}
if [ -d ./${OUTPUT_EACH_DIR} ]
then
	echo "# Exist: ./${OUTPUT_EACH_DIR}."
else
	mkdir ./${OUTPUT_EACH_DIR}
	echo "# Create: ./${OUTPUT_EACH_DIR}."
fi
    
echo -n "# Start STAR mapping : ${SAMPLE} ... "
date
    
${TOOL_STAR} \
	--runMode alignReads \
	--genomeDir ./${STAR_RSEM_REF_DIR} \
	--readFilesCommand gunzip -c \
	--runThreadN ${THREAD} \
	--quantMode TranscriptomeSAM GeneCounts \
	--readFilesIn ${INPUT_FASTQ_R1} ${INPUT_FASTQ_R2} \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ${OUTPUT_EACH_DIR}/ \
	--outSAMprimaryFlag AllBestScore \
	--outSAMmultNmax -1 \
	--outFilterMultimapNmax 10000
    
echo -n "# End STAR mapping : ${SAMPLE} -> ./${OUTPUT_EACH_DIR} "
date
ls -Fal ./${OUTPUT_EACH_DIR}/*

#############################

echo -n "## DONE $0 "
date
