#!/bin/zsh

################
## STAR mapping
################

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

echo "## OUTPUT_TRIMMOMATIC_DIR : ./${OUTPUT_TRIMMOMATIC_DIR}"

#REF_NAME=${GENOME}.${ENSRELEASE}
echo "## REF_NAME : $REF_NAME"

#REF_FA=${STAR_RSEM_REF_DIR}/${REF_NAME}.fasta
#REF_GTF={STAR_RSEM_REF_DIR}/${REF_NAME}.gtf
echo "## STAR_RSEM_REF_DIR : ./${STAR_RSEM_REF_DIR}"
echo "## REF_FA : ./${REF_FA}"
echo "## REF_GTF : ./${REF_GTF}"

ls -Fal ./${REF_FA} ./${REF_GTF}

DATA_LIST_FILE=${RESULT_DIR}/list_dataName.txt

echo "## THREAD : $THREAD"

if [ -d ./${OUTPUT_STAR_DIR} ]
then
    echo "## Exist: ./${OUTPUT_STAR_DIR}"
else
    mkdir ./${OUTPUT_STAR_DIR}
    echo "## Create: ./${OUTPUT_STAR_DIR}"
fi

#############################
### This example is for typically paired-end data
### Please modify if you use single-end data

while read SAMPLE
do
    
    echo -n "## Sample: ${SAMPLE} "
    date
    
    OUTPUT_EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${SAMPLE}
    if [ -d ${OUTPUT_EACH_DIR} ]
    then
	echo "## Exist: ${OUTPUT_EACH_DIR}."
    else
	mkdir ${OUTPUT_EACH_DIR}
	echo "## Create: ${OUTPUT_EACH_DIR}."
    fi
    
    echo -n "## Start STAR mapping : ${SAMPLE} ... "
    date

    if [ ${ISPAIREDREAD} -eq 2 ]; then
	echo "## This data is paired-end data (${ISPAIREDREAD})"
	INPUT_FASTQS_R1=`ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_*R1.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
	INPUT_FASTQS_R2=`ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_*R2.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
	echo "## multifile-fastq-set R1 : ${INPUT_FASTQS_R1}"
	echo "## multifile-fastq-set R2 : ${INPUT_FASTQS_R2}"
	ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_*R1.fq.gz
	ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}_*R2.fq.gz
	
	${TOOL_STAR} \
	    --runMode alignReads \
	    --genomeDir ${STAR_RSEM_REF_DIR} \
	    --readFilesCommand gunzip -c \
	    --runThreadN ${THREAD} \
	    --quantMode TranscriptomeSAM GeneCounts \
	    --readFilesIn ${INPUT_FASTQS_R1} ${INPUT_FASTQS_R2} \
	    --outSAMtype BAM SortedByCoordinate \
	    --outFileNamePrefix ${OUTPUT_EACH_DIR}/ \
	    --outSAMprimaryFlag AllBestScore \
	    --outSAMmultNmax -1 \
	    --outFilterMultimapNmax 100000
	
	### if you need, other options are OK
	### e.g. --winAnchorMultimapNmax, --bamRemoveDuplicatesType, etc.
	
    elif [${ISPAIREDREAD} -ne 2 ]; then
	echo "## This data is ${ISPAIREDREAD}, not paired-end"
	INPUT_FASTQS=`ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}.fq.gz | perl -pe 's/\n/\,/g;' | perl -pe 's/\,$//;'`
	echo "## multifile-fastq-set (single-end) : ${INPUT_FASTQ}"
	ls ${OUTPUT_TRIMMOMATIC_DIR}/trimmed_${SAMPLE}*.fq.gz
	
	${TOOL_STAR} \
	    --runMode alignReads \
	    --genomeDir ${STAR_RSEM_REF_DIR} \
	    --readFilesCommand gunzip -c \
	    --runThreadN ${THREAD} \
	    --quantMode TranscriptomeSAM GeneCounts \
	    --readFilesIn ${INPUT_FASTQS} \
	    --outSAMtype BAM SortedByCoordinate \
	    --outFileNamePrefix ${OUTPUT_EACH_DIR}/ \
	    --outSAMprimaryFlag AllBestScore \
	    --outSAMmultNmax -1 \
	    --outFilterMultimapNmax 100000
	
	### if you need, other options are OK
	### e.g. --winAnchorMultimapNmax, --bamRemoveDuplicatesType, etc.
    else
	echo "## Please set \$ISPAIREDREAD in 00000setup.zsh properly"
	exit 0
    fi
    
    echo -n "## End STAR mapping : ${SAMPLE} -> ${OUTPUT_EACH_DIR} "
    date
    
    ls -Fal ${OUTPUT_EACH_DIR}/*
    
done < ./${DATA_LIST_FILE}

#############################

echo -n "## DONE $0 : "
date
