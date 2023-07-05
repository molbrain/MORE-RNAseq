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
    
    echo "## TOOL_FASTQC : ${TOOL_FASTQC}"
    echo "## "`${TOOL_FASTQC} -v | perl -pe 'chomp;'`
    echo "## OUTPUT_FASTQC_DIR : ${OUTPUT_FASTQC_DIR}"
    
    while read FASTQFILE
    do
	NAME=`echo -n $FASTQFILE | perl -pe 's/^.+\///; s/\.f(ast)?q(.gz)?$//;'`
	echo "## USING FASTQ : $NAME (${FASTQFILE})"
	ls -Fal ${FASTQFILE}
	
	OUTPUT_EACH_DIR=./${OUTPUT_FASTQC_DIR}/${NAME}
	if [ -d ${OUTPUT_EACH_DIR} ]
	then
	    echo "## Exist : ${OUTPUT_EACH_DIR}"
	else
	    mkdir ${OUTPUT_EACH_DIR}
	    echo "## Create : ${OUTPUT_EACH_DIR}"
	fi
	
	${TOOL_FASTQC} --nogroup \
	    -o ${OUTPUT_EACH_DIR} \
	    ${FASTQFILE}
	
	
	ls -Fl ${OUTPUT_EACH_DIR}
	
	echo -n "## FastQC ($NAME) done. "
	date
    done < ./${RESULT_DIR}/list_fastqName.txt
    
    echo -n "## FastQC DONE. "
    date
    
else
    ls -Fl ./00000setup.zsh
  echo "## ./00000setup.zsh is not exist..."
  echo -n "## Abort $0 : "
  date
fi

echo -e "## $0 DONE : "
date


