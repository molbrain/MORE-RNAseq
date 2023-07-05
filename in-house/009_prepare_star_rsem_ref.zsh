#!/bin/zsh

#############################
## preoare_star_rsem_ref
#############################


echo -n "## $0 start : "
date


#############################

##
READ_LENGTH=
## e.g. READ_LENGTH=150
echo "# READ_LENGTH : $READ_LENGTH"

THREAD=10
echo "# THREAD : $THREAD"

GENOME=
## e.g. GENOME=GRCm38
## human -> GRCh38, mouse -> GRCm38, chimp -> ??, marmoset -> ??

ENSRELEASE=
## e.g. ENSRELEASE=102

SPECIES=
## e.g. SPECIES=mus_musculus
## human -> =homo_sapiens, mouse -> mus_musculus, chimp -> ??, marmoset -> ??

CAP_SPECIES=
## e.g. CAP_SPECIES=Mus_musculus
## human -> =Homo_sapiens, mouse -> Mus_musculus, chimp -> ??, marmoset -> ??


echo "# GENOME : ${GENOME}, SPECIES : ${CAP_SPECIES} (${SPECIES})"

L1_INFO_DIR=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1
L1_GTF=${L1_INFO_DIR}/GTF_with_fli_L1/L1fli_Utr5toUtr3.${GENOME}.gtf
ls -Fal ${L1_GTF}

#############################


TOOL_STAR=/home/nakachiy/bin/STAR-2.7.6a/bin/Linux_x86_64_static/STAR
echo -n "# TOOL_STAR : "
${TOOL_STAR} | grep version

TOOL_RSEM_PREP_REF=/home/nakachiy/bin/RSEM-1.3.3/bin/rsem-prepare-reference
echo -n "# TOOL_RSEM_PREP_REF : "
${RSEM_PATH}/rsem-calculate-expression --version

#############################

ORIGINAL_REF_FTPSITE=ftp.ensembl.org/pub/release-${ENSRELEASE}
ORIGINAL_REF_FA=${ORIGINAL_REF_FTPSITE}/fasta/${SPECIES}/dna/${CAP_SPECIES}.${GENOME}.dna.primary_assembly.fa.gz
ORIGINAL_REF_GTF=${ORIGINAL_REF_FTPSITE}/gtf/${SPECIES}/${CAP_SPECIES}.${GENOME}.${ENSRELEASE}.gtf.gz
## or do "wget ${ORIGINAL_REF_FTPSITE}/fasta/${SPECIES}/dna/${ORIGINAL_REF_FA}"

ORIGINAL_REF_DIR=/home/Shared/References

if [ -e ${ORIGINAL_REF_DIR}/${ORIGINAL_REF_FA} ]
then
    echo "# ${ORIGINAL_REF_FA} is exist."
else
    echo "# ORIGINAL_REF_FA was not found. Please download :${ORIGINAL_REF_FA} to ${ORIGINAL_REF_DIR}"
fi

if [ -e ${ORIGINAL_REF_DIR}/${ORIGINAL_REF_GTF} ]
then
    echo "# ${ORIGINAL_REF_GTF} is exist."
else
    echo "# ORIGINAL_REF_GTF was not found. Please download: ${ORIGINAL_REF_GTF} to ${ORIGINAL_REF_DIR}"
fi

#############################


STAR_RSEM_REF_DIR=Ref
if [ -d ${STAR_RSEM_REF_DIR} ]
then
    echo "# ${STAR_RSEM_REF_DIR} is exist."
else
    echo "# ${STAR_RSEM_REF_DIR} was not found. Please create it and prepare the referneces."
fi


REF_NAME=${GENOME}.${ENSRELEASE}
echo "# REF_NAME : $REF_NAME"


REF_FA=${REF_NAME}.fasta
REF_GTF=${REF_NAME}.gtf

echo -n "# make $REF_FA "
date
zcat ${ORIGINAL_REF_DIR}/${ORIGINAL_REF_FA} > ${REF_FA}
ls -Fal ${REF_FA}

echo -n "# make $REF_GTF "
date
zcat ${ORIGINAL_REF_DIR}/${ORIGINAL_REF_GTF} > ${REF_GTF}
ls -Fal ${REF_GTF}

####### If you want to include the L1-fli information with the GTF, do as follows:
#L1_INFO_DIR=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1
#L1_GTF=${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.gtf
#echo "# L1_GTF ${L1_GTF} included."
#cat ${L1_GTF} >> ${REF_GTF}

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


STAR_PATH=`echo -n ${TOOL_STAR} | perl -pe 's/\/STAR$//;'`
echo "# STAR_PATH : ${STAR_PATH}"

MAX_LENGTH=${READ_LENGTH}
echo "# MAX_LENGTH : $MAX_LENGTH"

SJDB=`echo -n ${MAX_LENGTH} | perl -ne 'chomp;print ($_ - 1);'`
echo "# SJDB (star-sjdboverhang) : $SJDB"

echo -n "# Start creating INDEX by RSEM (w/STAR) ... "
date

${TOOL_RSEM_PREP_REF} -p 20 --star --star-path ${STAR_PATH} --gtf ${REF_GTF} --star-sjdboverhang ${SJDB} ${REF_FA} ${STAR_RSEM_REF_DIR}/${REF_NAME}

echo "# End creating INDEX by RSEM (w/STAR)"
ls -Fal ${STAR_RSEM_REF_DIR}/*

#############################


echo -n "## DONE $0 "
date
