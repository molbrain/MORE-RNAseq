#!/bin/zsh

#############################
## STAR_mapping
#############################


echo -n "## $0 start : 
date


#############################

CLEAN_FASTQ_DIR=./TRIMMOMATIC

STAR_RSEM_REF_DIR=./Ref
echo "# STAR_RSEM_REF_DIR : ${STAR_RSEM_REF_DIR}"

THREAD=4
echo "# THREAD : $THREAD"

#############################


TOOL_STAR=/home/nakachiy/bin/STAR-2.7.6a/bin/Linux_x86_64_static/STAR
echo -n "TOOL_STAR : ${TOOL_STAR} "
${TOOL_STAR} | grep version

OUTPUT_STAR_DIR=./STAR
if [ -d ${OUTPUT_STAR_DIR} ]
then
    echo "# Exist: ${OUTPUT_STAR_DIR}."
else
    mkdir ${OUTPUT_STAR_DIR}
    echo "# Create: ${OUTPUT_STAR_DIR}."
fi


#############################

for NUM in ___SAMPLE___
do
    
    echo -n "# Sample: ${NUM} "
    date
    
    INPUT_FASTQ_R1=`ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*_R1.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
    INPUT_FASTQ_R2=`ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*_R2.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
    echo "# multifile-fastq-set R1 : ${INPUT_FASTQ_R1}"
    echo "# multifile-fastq-set R2 : ${INPUT_FASTQ_R2}"
    ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*_R1.fq.gz
    ls ${CLEAN_FASTQ_DIR}/trimmed_${NUM}*_R2.fq.gz
    
    OUTPUT_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${NUM}
    if [ -d ${OUTPUT_EACH_DIR} ]
    then
	echo "# Exist: ${OUTPUT_EACH_DIR}."
    else
	mkdir ${OUTPUT_EACH_DIR}
	echo "# Create: ${OUTPUT_EACH_DIR}."
    fi
    
    echo -n "# Start STAR mapping : ${NUM} ... "
    date
    
    ${TOOL_STAR} \
	--runMode alignReads \
	--genomeDir ${STAR_RSEM_REF_DIR} \
	--readFilesCommand gunzip -c \
	--runThreadN ${THREAD} \
	--quantMode TranscriptomeSAM GeneCounts \
	--readFilesIn ${INPUT_FASTQ_R1} ${INPUT_FASTQ_R2} \
	--outSAMtype BAM SortedByCoordinate \
	--outFileNamePrefix ${OUTPUT_EACH_DIR}/ \
	
	
	### MORE RNA-seq settings
	### NEED TO ADD THE THREE OPTIONS TO STAR COMMAND ABOVE
	#--outSAMprimaryFlag AllBestScore \
	#--outSAMmultNmax -1 \
	#--outFilterMultimapNmax 3000 \
	### 
    
    
    echo -n "# End STAR mapping : ${NUM} -> ${OUTPUT_EACH_DIR} "
    date
    
    ls -Fal ${OUTPUT_EACH_DIR}/*
    
done

#############################


echo -n "## DONE $0 "
date
