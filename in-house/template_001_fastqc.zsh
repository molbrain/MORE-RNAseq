#!/bin/zsh

##########################
## template_001_fastqc.zsh
##########################

echo -n "## START : $0 "
date

NUM=___SAMPLE___
echo "## NUM : ${NUM}"

if [ -f ./00000setup.zsh ]
then
  echo "## ./00000setup.zsh is exist !!!!!"
  source 00000setup.zsh
else
  echo "## ./00000setup.zsh is not exist !!!!!"

  RAWDATA_DIR=./Rawdata
  echo "## RAWDATA_DIR : ${RAWDATA_DIR}"

  TOOL_FASTQC=/usr/local/fastqc/bin/fastqc
  echo "## TOOL_FASTQC : ${TOOL_FASTQC}"
  echo "## ",`${TOOL_FASTQC} -v | perl -pe 'chomp;'`

  OUTPUT_FASTQC_DIR=./FASTQC
  echo "## OUTPUT_FASTQC_DIR : ${OUTPUT_FASTQC_DIR}"
  
  RAWDATA_PREFIX_PAIR=_R
  echo "## RAWDATA_PREFIX_PAIR : ${RAWDATA_PREFIX_PAIR}"

  RAWDATA_SUFFIX_FASTQ=fastq.gz
  echo "## RAWDATA_SUFFIX_FASTQ : ${RAWDATA_SUFFIX_FASTQ}"
fi


if [ -d ${RAWDATA_DIR} ]
then

  echo "## ${RAWDATA_DIR} is using..."
  ls -Fl ${RAWDATA_DIR}/* | grep ${NUM}
  
  for PAIR in 1 2
  do
	FILENAME=${RAWDATA_DIR}/${NUM}${RAWDATA_PREFIX_PAIR}${PAIR}.${RAWDATA_SUFFIX_FASTQ}
	echo -n "## FastQC : ${FILENAME} "
	date
	
	EACH_DIR=./${OUTPUT_FASTQC_DIR}/${NUM}_R${PAIR}
	if [ -d ${EACH_DIR} ]
	then
	    echo "## Exist : ${EACH_DIR}"
	else
	    mkdir ${EACH_DIR}
	echo "## Create : ${EACH_DIR}"
	fi

	${TOOL_FASTQC} \
	    --nogroup \
	    -o ${EACH_DIR} \
	    ${FILENAME}
	
	
	ls -Fl ${EACH_DIR}
	
	echo -n "## FastQC ($NUM, $PAIR) done. "
	date
  done
  echo -n "## FastQC ($NUM) DONE. "
  date
  
else
  ls -Fl ${RAWDATA_DIR}
  echo "## ${RAWDATA_DIR} is not exist..."
  echo -n "## Abort $0 : "
  date

fi
