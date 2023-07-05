#!/bin/zsh

#################################
## 00000setup.zsh
#################################

echo -n "## source $0 START : "
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

# PAIRREAD (Is the RNA-seq data pair-end reads, or single-end reads? For STAR/RSEM)
PAIRREAD=PE

# THREAD (If available, use the number of thread setting)
THREAD=3

### PATH (NEED TO MODIFY) ######

JAVA=java
PERL=perl
R=R

TOOL_FASTQC=fastqc
TOOL_FASTQSTATS=fastq-stats
TOOL_CUTADAPT=cutadapt
JAR_TRIMMOMATIC=/usr/local/Trimmomatic-0.38/trimmomatic-0.38.jar
TOOL_STAR=STAR
TOOL_RSEM_PREP_REF=rsem-prepare-reference
TOOL_RSEM_CALC_EXPR=rsem-calculate-expression
TOOL_RSEM_GEN_DATA_MTX=rsem-generate-data-matrix
TOOL_SAMTOOLS=samtools



#### NO NEED TO MODIFY THE BELOW LINES ##########

# Reference name
L1_GTF=./MORE/MORE-reference/L1fli_Utr5toUtr3.${GENOME}.gtf
REF_NAME=${GENOME}.${ENSRELEASE}


# Directories

RAWDATA_DIR=Rawdata
RESULT_DIR=Results

STAR_RSEM_REF_DIR=Reference
ORIGINAL_REF_DIR=${STAR_RSEM_REF_DIR}/Original

TEMP_DIR=TEMP
OUTPUT_FASTQC_DIR=${TEMP_DIR}/FASTQC
OUTPUT_FASTQSTATS_DIR=${TEMP_DIR}/FASTQSTATS
OUTPUT_CUTADAPT_DIR=${TEMP_DIR}/CUTADAPT
OUTPUT_TRIMMOMATIC_DIR=${TEMP_DIR}/TRIMMOMATIC
OUTPUT_STAR_DIR=${TEMP_DIR}/STAR
OUTPUT_RSEM_DIR=${TEMP_DIR}/RSEM
OUTPUT_EDGER_DIR=${TEMP_DIR}/EDGER


# Confrim tools and those versions

if [ -e `which ${TOOL_FASTQC}` ]
then
    echo "## FastQC is exist:" `which ${TOOL_FASTQC}`
    ${TOOL_FASTQC} -version
else
    echo "## NO exist : ${TOOL_FASTQC}"
fi

if [ -e `which ${TOOL_FASTQSTATS}` ]
then
    echo "## fastq-stats is exist:" `which ${TOOL_FASTQSTATS}`
    ${TOOL_FASTQSTATS} -help 2>&1 | grep Version
else
    echo "## NO exist : ${TOOL_FASTQSTATS}"
fi

if [ -e `which ${JAVA}` ]
then
    echo "## java is exist:" `which ${JAVA}`
    ${JAVA} -version
else
    echo "## NO exist : ${JAVA}"
fi

if [ -e ${JAR_TRIMMOMATIC} ]
then
    echo "## JAR_TRIMMOMATIC is exist:" ${JAR_TRIMMOMATIC}
    echo "Trimmomatic" `${JAVA} -jar ${JAR_TRIMMOMATIC} -version`
else
    echo "## NO exist : ${JAR_TRIMMOMATIC}"
fi

if [ -e `which ${TOOL_STAR}` ]
then
    echo "## STAR is exist:" `which ${TOOL_STAR}`
    echo "STAR" `${TOOL_STAR} --version`
else
    echo "## NO exist : ${TOOL_STAR}"
fi

if [ -e `which ${PERL}` ]
then
    echo "## Perl is exist:" `which ${PERL}`
    ${PERL} -version 2>&1 | grep version
else
    echo "## NO exist : ${PERL}"
fi

if [ -e `which ${TOOL_RSEM_PREP_REF}` ]
then
    echo "RSEM is exist:" `which ${TOOL_RSEM_PREP_REF}`
else
    echo "## NO exist : ${TOOL_RSEM_PREP_REF}"
fi

if [ -e `which ${TOOL_RSEM_CALC_EXPR}` ]
then
    echo "RSEM is exist:" `which ${TOOL_RSEM_CALC_EXPR}`
else
    echo "## NO exist : ${TOOL_RSEM_CALC_EXPR} `which ${TOOL_RSEM_CALC_EXPR}`"
fi

if [ -e `which ${TOOL_RSEM_GEN_DATA_MTX}` ]
then
    echo "RSEM is exist:" `which ${TOOL_RSEM_GEN_DATA_MTX}`
else
    echo "## NO exist : ${TOOL_RSEM_GEN_DATA_MTX}"
fi

if [ -e `which ${TOOL_SAMTOOLS}` ]
then
    echo "samtools is exist:" `which ${TOOL_SAMTOOLS}`
    echo "samtools" `${TOOL_SAMTOOLS} --version`
else
    echo "## NO exist : ${TOOL_SAMTOOLS}"
fi

if [ -e `which ${R}` ]
then
    echo "R is exist:" `which ${R}`
    ${R} --version | grep "R version"
    ${R} --slave < <(echo "library(edgeR);sessionInfo();") 2>&1 | grep edgeR | perl -e 'while(<>){chomp;$l .=$_;} if($l=~/edgeR/){print "$l\n";}else{print "## NOT installed : edgeR\n";}'
else
    echo "## NO exist : ${R} (and no edgeR, too)"
fi


#############################

echo -n "## source $0 DONE : "
date
