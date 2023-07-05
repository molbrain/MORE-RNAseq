#!/bin/zsh

##########################
## 001_fastqc.zsh
##########################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh is exist"
    source 00000setup.zsh
    
    echo "## TOOL_FASTQSTATS : ${TOOL_FASTQSTATS}"
    echo "## "`${TOOL_FASTQSTATS} --help 2>&1 | grep Version`
    echo "## OUTPUT_FASTQSTATS_DIR : ${OUTPUT_FASTQSTATS_DIR}"
    
    while read FASTQFILE
    do
	NAME=`echo -n $FASTQFILE | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## USING FASTQ : $NAME (${FASTQFILE})"
	ls -Fal ${FASTQFILE}
	
	OUTPUT_EACH_DIR=./${OUTPUT_FASTQSTATS_DIR}/${NAME}
	if [ -d ${OUTPUT_EACH_DIR} ]
	then
	    echo "## Exist : ${OUTPUT_EACH_DIR}"
	else
	    mkdir ${OUTPUT_EACH_DIR}
	    echo "## Create : ${OUTPUT_EACH_DIR}"
	fi
	
	${TOOL_FASTQSTATS} \
	    -s 5  \
	    ${FASTQFILE} \
	    | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
		   > ${OUTPUT_EACH_DIR}/fastq-stats.txt
		       
	ls -Fl ${OUTPUT_EACH_DIR}
	
	echo -n "## fastq-stats ($NAME) done. "
	date
    done < ./${RESULT_DIR}/list_fastqName.txt
    
    echo -n "## fastq-stats DONE. "
    date
    
else
    ls -Fl ./00000setup.zsh
  echo "## ./00000setup.zsh is not exist..."
  echo -n "## Abort $0 : "
  date
fi

echo -e "## $0 DONE : "
date


