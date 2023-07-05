#!/bin/zsh

# ORIGINAL_DATA_DIR=/home/nakachiy/Rawdata/MolBrain/NGS15/original_fastq
# ln -s ${ORIGINAL_DATA_DIR} ./Rawdata

#md5sum already done

#ls ./Rawdata \
#    | grep -v ".pdf$\|.md5$\|.txt$\|.zsh$" \
#    | grep ".fastq.gz\|.fq.gz$\|.fastq$\|.fq$" \
#    | perl -pe 's/^.+\///;' \
#	   > list_fastqName.txt
#
#ls -Fal list_fastqName.txt
#
#cat list_fastqName.txt \
#    | perl -pe 's/\.gz$//;' \
#    | perl -pe 's/\.f(ast)?q$//;' \
#    | perl -pe 's/_R?[12]$//;' \
#    | sort -u \
#	   > list_dataName.txt
#
#ls -Fal list_dataName.txt

ls ./Rawdata \
    | grep -v ".pdf$\|.md5$\|.txt$\|.zsh$" \
    | grep ".fastq.gz\|.fq.gz$\|.fastq$\|.fq$" \
    | perl -pe 's/^.+\///;' \
    | perl -pe 's/\.gz$//;' \
    | perl -pe 's/\.f(ast)?q$//;' \
    | perl -pe 's/_R?\d$//;' \
    | sort -u \
	   > list_fileName.txt

ls -Fal list_fileName.txt

cat list_fileName.txt \
    | perl -pe 's/\.gz$//;' \
    | perl -pe 's/\.f(ast)?q$//;' \
    | perl -pe 's/_\d$//;' \
    | sort -u \
	   > list_dataName.txt

ls -Fal list_dataName.txt

mkdir scripts
mkdir qsub
mkdir LOGS
mkdir FASTQC
mkdir FASTQSTATS
mkdir CUTADAPT
mkdir TRIMMOMATIC
mkdir STAR
mkdir RSEM
mkdir EDGER
