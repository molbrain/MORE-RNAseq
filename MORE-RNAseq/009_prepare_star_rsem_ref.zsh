#!/bin/zsh

######################
## Prepare references
######################

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

##
## e.g. READ_LENGTH=150 <- set up in 00000setup.zsh
if [ -z "${READ_LENGTH}" ]
then
    echo "## READ_LENGTH : $READ_LENGTH <--- not defined"
    exit 0
elif [ ${READ_LENGTH} -eq 0 ]
then
    echo "## READ_LENGTH : $READ_LENGTH <--- not defined?"
    exit 0
else
    echo "## READ_LENGTH : $READ_LENGTH"
fi

echo "## THREAD : $THREAD"


if [ -z ${GENOME} ] || [ -z ${SPECIES} ] || [ -z ${CAP_SPECIES} ]
then
    echo "## GENOME : ${GENOME}, SPECIES : ${CAP_SPECIES} (${SPECIES}) <--- not defined"
    exit 0
else
    echo "## GENOME : ${GENOME}, SPECIES : ${CAP_SPECIES} (${SPECIES})"
fi

## L1_GTF=./MORE-RNAseq/MORE-reference/L1fli_Utr5toUtr3.${GENOME}.gtf
ls -Fal ${L1_GTF}

#############################

#ORIGINAL_REF_FA=./${STAR_RSEM_REF_DIR}/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz
#ORIGINAL_REF_GTF=./${STAR_RSEM_REF_DIR}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz

#ORIGINAL_REF_FTPSITE=ftp.ensembl.org/pub/release-${ENSRELEASE}
#ORIGINAL_REF_FA_URL=${ORIGINAL_REF_FTPSITE}/fasta/${SPECIES}/dna/${ORIGINAL_REF_FA}
#ORIGINAL_REF_GTF_URL=${ORIGINAL_REF_FTPSITE}/gtf/${SPECIES}/${ORIGINAL_REF_GTF}
## If not FA/GTF, do the command "wget ${ORIGINAL_REF_FTPSITE}/fasta/${SPECIES}/dna/${ORIGINAL_REF_FA_URL}"


# STAR_RSEM_REF_DIR=./Referene, as defined in 00000setup.zsh
if [ -d ${STAR_RSEM_REF_DIR} ]
then
    echo "## ${STAR_RSEM_REF_DIR} is exist."
else
    echo "## ${STAR_RSEM_REF_DIR} was not found. Please create it and prepare the referneces."
    exit 0
fi

# ORIGINAL_REF_DIR=./Reference/Original, as defined in 00000setup.zsh
if [ -d ${ORIGINAL_REF_DIR} ]
then
    echo "## ${ORIGINAL_REF_DIR} is exist."
else
    echo "## ORIGINAL_REF_DIR ${ORIGINAL_REF_DIR} was not found. Please create it and prepare/downlaod the referneces from the proper source (maybe Ensembl ${ORIGINAL_REF_FTPSITE})."
    exit 0
fi

if [ -e ${ORIGINAL_REF_FA} ]
then
    echo "## ${ORIGINAL_REF_FA} is exist."
else
    echo "## ORIGINAL_REF_FA ${ORIGINAL_REF_FA} was not found. Please download :${ORIGINAL_REF_FA} from ${ORIGINAL_REF_FA_URL} to ${ORIGINAL_REF_DIR}"
    exit 0
fi

if [ -e ${ORIGINAL_REF_GTF} ]
then
    echo "## ${ORIGINAL_REF_GTF} is exist."
else
    echo "## ORIGINAL_REF_GTF ${ORIGINAL_REF_GTF} was not found. Please download: ${ORIGINAL_REF_GTF} from ${ORIGINAL_REF_GTF_URL} to ${ORIGINAL_REF_DIR}"
    exit 0
fi

#############################

# REF_NAME=${GENOME}.${ENSRELEASE}
echo "# REF_NAME : $REF_NAME"

REF_FA=${STAR_RSEM_REF_DIR}/${REF_NAME}.fasta
REF_GTF=${STAR_RSEM_REF_DIR}/${REF_NAME}.gtf

echo -n "# make $REF_FA "
date
zcat ./${ORIGINAL_REF_FA} > ./${REF_FA}
ls -Fal ./${REF_FA}

echo -n "# make $REF_GTF "
date
zcat ./${ORIGINAL_REF_GTF} > ./${REF_GTF}
ls -Fal ./${REF_GTF}

echo "# L1_GTF ${L1_GTF} included."
cat ./${L1_GTF} >> ./${REF_GTF}
ls -Fal ./${REF_GTF}

####### Future plan
### Ensembl GTF has two GTFs.
### For example, In the case of GRCm38/ens102, Mus_musculus.GRCm38.102.gtf.gz, and Mus_musculus.GRCm38.102.abinitio.gtf.gz
### If ab initio gene annotation is also needed for analysis, you can merge it as same as L1_GTF.

#echo -n "# make knownIsoforms.txt for STAR/RSEM"
#date
#less ${REF_GTF} \
#    | perl -ne '/gene_id\ \"(ENSMUSG\d+)\"/;$geneid=$1;/transcript_id\ \"(ENSMUST\d+)\"/;$txid=$1;print "$geneid\t$txid\n";' \
#    | grep ENSMUSG \
#    | grep ENSMUST \
#    | sort -u \
#	   > ${REF_NAME}.knownIsoforms.txt
#
#ls -Fal ${REF_FA} ${REF_GTF} ${REF_NAME}.knownIsoforms.txt

STAR_WHICH=`which ${TOOL_STAR}`
STAR_PATH=`echo -n ${STAR_WHICH} | perl -pe 's/\/STAR$//;'`
echo "## STAR_PATH : ${STAR_PATH}"

MAX_LENGTH=${READ_LENGTH}
echo "## MAX_LENGTH : $MAX_LENGTH"

SJDB=`echo -n ${MAX_LENGTH} | perl -ne 'chomp;print ($_ - 1);'`
echo "## SJDB (star-sjdboverhang) : $SJDB"

echo -n "## Start creating INDEX by RSEM (w/STAR) ... "
date

${TOOL_RSEM_PREP_REF} \
    -p ${THREAD} \
    --star --star-path ${STAR_PATH} \
    --gtf ./${REF_GTF} \
    --star-sjdboverhang ${SJDB} \
    ./${REF_FA} ./${STAR_RSEM_REF_DIR}/${REF_NAME}

echo "## End creating INDEX by RSEM (w/STAR)"
ls -Fal ./${STAR_RSEM_REF_DIR}/*

#############################

echo -n "## DONE $0 : "
date
