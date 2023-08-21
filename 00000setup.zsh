#!/bin/zsh

#################################
## 00000setup.zsh
#################################

echo -n "## source $0 start : "
date


### NEED TO CONFIRM/MODIFIY #####

# GENOME: human -> GRCh38, mouse -> GRCm38
# SPECIES: human -> =homo_sapiens, mouse -> mus_musculus
GENOME=GRCm38
SPECIES=mus_musculus

#CAP_SPECIES=Mus_musculus (or the below Perl oneliner do replace the first character to capital automatically)
#GENOME=
#SPECIES=
CAP_SPECIES=`echo -n $SPECIES | perl -pe 's/^(.)/\U$1/;'`

# ENSRELEASE is the release number of Ensembl as the FASTA/GTC sources
# Example workflow, used the data of release 102 as the original references
ENSRELEASE=102

# READ_LENGTH (read length for Cutadapt)
# For example, "151" length frequently includes the additional one base for quality guarantee.
# So when the read length of raw data fastq is 151 bp, READ_LENGTH is recommended as 150.
READ_LENGTH=150

# MIN_LENGTH (minimun read length for Trimmomatic)
MIN_LENGTH=40

# MIN_QUAL (minimum base quality for STAR)
MIN_QUAL=10

# NEXTSEQ_TRIM (nextseq-trim option for Cutadapt)
NEXTSEQ_TRIM=5

# ISPAIREDREAD (Is the RNA-seq data pair-end reads, or single-end reads? For STAR/RSEM)
# ISPAIREDREAD=1: single-end  ---> will input fastq as single-end in STAR, not paired-end
# ISPAIREDREAD=2: paired-end  --> will use --paired-end option in RSEM, not as single-end
ISPAIREDREAD=2

# STRANDEDNESS (strandedness for RSEM) 
# --strandedness <none|forward|reverse>
# For Illumina TruSeq Stranded protocols, should use 'reverse'. (RSEM default is none)
STRANDEDNESS=none

# The number of threads
THREAD=4

# If you need, you can modified these directory name
RAWDATA_DIR=Rawdata
RESULT_DIR=Results

### PATH (NEED TO MODIFY) ######

#JAVA=/bin/java
#PERL=/usr/bin/perl
#R=/usr/local/R/bin/R
JAVA=java
PERL=perl
R=R

TOOL_FASTQC=fastqc
TOOL_FASTQSTATS=fastq-stats
TOOL_CUTADAPT=cutadapt
TOOL_TRIMMOMATIC=trimmomatic
# If you don't use an executable Trimmomatic but a jar file, please set the below
#JAR_TRIMMOMATIC=Trimmomatic.jar
JAR_TRIMMOMATIC=/usr/local/bin/Trimmomatic-0.38/trimmomatic-0.38.jar
TOOL_STAR=STAR
TOOL_RSEM_PREP_REF=rsem-prepare-reference
TOOL_RSEM_CALC_EXPR=rsem-calculate-expression
TOOL_RSEM_GEN_DATA_MTX=rsem-generate-data-matrix
TOOL_SAMTOOLS=samtools





#### NO NEED TO MODIFY THE BELOW LINES ##########

# References and directories
L1_GTF=./MORE-RNAseq/MORE-reference/L1fli_Utr5toUtr3.${GENOME}.gtf
REF_NAME=${GENOME}.${ENSRELEASE}

STAR_RSEM_REF_DIR=Reference
ORIGINAL_REF_DIR=${STAR_RSEM_REF_DIR}/Original

REF_FA=${STAR_RSEM_REF_DIR}/${REF_NAME}.fasta
REF_GTF=${STAR_RSEM_REF_DIR}/${REF_NAME}.gtf

ORIGINAL_REF_FA=${ORIGINAL_REF_DIR}/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz
ORIGINAL_REF_GTF=${ORIGINAL_REF_DIR}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz

ORIGINAL_REF_FTPSITE=ftp.ensembl.org/pub/release-${ENSRELEASE}
ORIGINAL_REF_FA_URL=${ORIGINAL_REF_FTPSITE}/fasta/${SPECIES}/dna/${ORIGINAL_REF_FA}
ORIGINAL_REF_GTF_URL=${ORIGINAL_REF_FTPSITE}/gtf/${SPECIES}/${ORIGINAL_REF_GTF}

TEMP_DIR=TEMP
OUTPUT_FASTQC_DIR=${TEMP_DIR}/FASTQC
OUTPUT_FASTQSTATS_DIR=${TEMP_DIR}/FASTQSTATS
OUTPUT_CUTADAPT_DIR=${TEMP_DIR}/CUTADAPT
OUTPUT_TRIMMOMATIC_DIR=${TEMP_DIR}/TRIMMOMATIC
OUTPUT_STAR_DIR=${TEMP_DIR}/STAR
OUTPUT_RSEM_DIR=${TEMP_DIR}/RSEM
OUTPUT_EDGER_DIR=${TEMP_DIR}/EDGER

# Confrim tools and those versions
if [ -e `which ${JAVA}` ]
then
    echo -n "## java :" `which ${JAVA}`
    ${JAVA} -version
else
    echo "## NO exist : ${JAVA}"
fi

if [ -e `which ${PERL}` ]
then
    echo "## Perl : " `which ${PERL}`
    ${PERL} -version 2>&1 | grep version
else
    echo "## NO exist : ${PERL}"
fi

if [ -e `which ${TOOL_FASTQC}` ]
then
    echo "## FastQC :" `which ${TOOL_FASTQC}`
    ${TOOL_FASTQC} -version
else
    echo "## NO exist : ${TOOL_FASTQC}"
fi

if [ -e `which ${TOOL_FASTQSTATS}` ]
then
    echo "## fastq-stats :" `which ${TOOL_FASTQSTATS}`
    ${TOOL_FASTQSTATS} -help 2>&1 | grep Version
else
    echo "## NO exist : ${TOOL_FASTQSTATS}"
fi

PATH_TRI=`which ${TOOL_TRIMMOMATIC}`
if [ -e $PATH_TRI ]
then
    echo "## Trimmomatic : " `echo ${TOOL_TRIMMOMATIC}`
    ${TOOL_TRIMMOMATIC} -version
elif [ -f ${JAR_TRIMMOMATIC} ]
    echo "## Trimmomatic : ${JAR_TRIMMOMATIC}" 
    ${JAVA} -jar ${JAR_TRIMMOMATIC} -version
then
else
    echo "## NO exist : ${JAR_TRIMMOMATIC} ${TOOL_TRIMMOMATIC}"
fi

if [ -e `which ${TOOL_STAR}` ]
then
    echo "## STAR :" `which ${TOOL_STAR}`
    ${TOOL_STAR} --version
else
    echo "## NO exist : ${TOOL_STAR}"
fi

if [ -e `which ${TOOL_RSEM_PREP_REF}` ]
then
    echo "## RSEM (rsem-prepare-reference) :" `which ${TOOL_RSEM_PREP_REF}`
else
    echo "## NO exist : ${TOOL_RSEM_PREP_REF}"
fi

if [ -e `which ${TOOL_RSEM_CALC_EXPR}` ]
then
    echo "## RSEM (rsem-calculate-expression) : " `which ${TOOL_RSEM_CALC_EXPR}`
else
    echo "## NO exist : ${TOOL_RSEM_CALC_EXPR}"
fi

if [ -e `which ${TOOL_RSEM_GEN_DATA_MTX}` ]
then
    echo "## RSEM (rsem-generate-data-matrix) : " `which ${TOOL_RSEM_GEN_DATA_MTX}`
else
    echo "## NO exist : ${TOOL_RSEM_GEN_DATA_MTX}"
fi

if [ -e `which ${TOOL_SAMTOOLS}` ]
then
    echo "## samtools : " `which ${TOOL_SAMTOOLS}`
    ${TOOL_SAMTOOLS} --version
else
    echo "## NO exist : ${TOOL_SAMTOOLS}"
fi

if [ -e `which ${R}` ]
then
    echo -n "## R :" `which ${R}` " "
    ${R} --version | grep "R version"
    echo -n "## edgeR :"
    ${R} --slave < <(echo "library(edgeR);sessionInfo();") 2>&1 | grep edgeR
else
    echo "## NO exist : ${R} (and no edgeR, too)"
fi


#############################

echo -n "## source $0 finished : "
date
