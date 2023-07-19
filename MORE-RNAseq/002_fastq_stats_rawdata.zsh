#!/bin/zsh

##########################
## fastq-stats (option)
##########################

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

echo "## TOOL_FASTQSTATS : ${TOOL_FASTQSTATS}"
echo "## OUTPUT_FASTQSTATS_DIR : ./${OUTPUT_FASTQSTATS_DIR}"

FASTQ_LIST_FILE=${RESULT_DIR}/list_fastqName.txt

if [ -s ./${FASTQ_LIST_FILE} ]
then
    echo "## ../${FASTQ_LIST_FILE}"
    cat ./${FASTQ_LIST_FILE}
else
    echo "## NO EXISTS : ./${FASTQ_LIST_FILE}"
    echo -n "## Abort $0 : "
    date
    exit 0
fi

#############################

while read FASTQFILE
do
    NAME=`echo -n ${FASTQFILE} | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
    echo -n "## fastq-stats using $NAME (${FASTQFILE})"
    date
    ls -Fal ${FASTQFILE}
    
    OUTPUT_EACH_DIR=${OUTPUT_FASTQSTATS_DIR}/${NAME}
    if [ -d ./${OUTPUT_EACH_DIR} ]
    then
	   echo "## Exist : ./${OUTPUT_EACH_DIR}"
    else
	   mkdir ./${OUTPUT_EACH_DIR}
	   echo "## Create : ./${OUTPUT_EACH_DIR}"
    fi
    
    ${TOOL_FASTQSTATS} \
	   -s 5  \
	   ${FASTQFILE} \
	   | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
	   > ./${OUTPUT_EACH_DIR}/fastq-stats.txt
    
    ls -Fl ./${OUTPUT_EACH_DIR}
    
    echo -n "## fastq-stats ($NAME) done. "
    date
done < ./${FASTQ_LIST_FILE}

echo -e "## DONE $0 : "
date
