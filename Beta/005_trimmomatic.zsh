#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

READ_LENGTH=100
MIN_LENGTH=40
MIN_QUAL=10
ADAPTER_FILE=/home/Shared/Miscellaneous/Public/Adapter_seqs_fasta/210331_adapters.fa
TEMP_TRIM_DIR=./CUTADAPT
CLEAN_FASTQ_DIR=./TRIMMOMATIC
THREAD=3

NUM=___SAMPLE___
#SAMPLE=`ls ${TEMP_TRIM_DIR}/*fq.gz | grep ${NUM}_ | perl -pe 's/^.+\///;s/^temp_//;s/_R[12]\.fq\.gz$//;' | sort -u)`
SAMPLE=${NUM}

FILENAME1=${TEMP_TRIM_DIR}/temp_${SAMPLE}_R1.fastq.gz
FILENAME2=${TEMP_TRIM_DIR}/temp_${SAMPLE}_R2.fastq.gz

TRIMMED1=${CLEAN_FASTQ_DIR}/trimmed_${SAMPLE}_R1.fq.gz
TRIMMED2=${CLEAN_FASTQ_DIR}/trimmed_${SAMPLE}_R2.fq.gz

UNPAIRED1=${CLEAN_FASTQ_DIR}/unpaired_${SAMPLE}_R1.fq.gz
UNPAIRED2=${CLEAN_FASTQ_DIR}/unpaired_${SAMPLE}_R2.fq.gz

JAR_TRIMMOMATIC=/usr/local/Trimmomatic-0.38/trimmomatic-0.38.jar
JAVA=/bin/java

echo "# JAVA : $JAVA"
java -version
echo -n "# JAR_TRIMMOMATIC : ${JAR_TRIMMOMATIC} / "
java -jar /usr/local/Trimmomatic-0.38/trimmomatic-0.38.jar -version


echo "trimmomatic>>${JAR_TRIMMOMATIC}<<"
ls ${JAR_TRIMMOMATIC}
echo "adapter>>${ADAPTER_FILE}<<"
ls ${ADAPTER_FILE}
echo "R1>>${FILENAME1}<<"
ls ${FILENAME1}
echo "R2>>${FILENAME2}<<"
ls ${FILENAME2}
echo "TRIMMED1  : ${TRIMMED1}"
echo "TRIMMED2  : ${TRIMMED2}"
echo "UNPAIRED1  : ${UNPAIRED1}"
echo "UNPAIRED2  : ${UNPAIRED2}"
echo "MIN_LENGTH : ${MIN_LENGTH}"
echo "MIN_QUAL   : ${MIN_QUAL}"

echo -n "trimmomatic ${SAMPLE} ..."
${JAVA} \
    -jar ${JAR_TRIMMOMATIC} \
    PE \
    -phred33 \
    -threads ${THREAD} \
    ${FILENAME1} \
    ${FILENAME2} \
    ${TRIMMED1} ${UNPAIRED1} \
    ${TRIMMED2} ${UNPAIRED2} \
    ILLUMINACLIP:${ADAPTER_FILE}:2:40:15 \
    LEADING:10 \
    TRAILING:10 \
    SLIDINGWINDOW:4:${MIN_QUAL} \
    MINLEN:${MIN_LENGTH}

    
echo -n "#FINISH ${SAMPLE} : "
date

ls -Fal ${TRIMMED1} ${TRIMMED2}
ls -Fal ${UNPAIRED1} ${UNPAIRED2}

echo -n "## $0 DONE : "
date
