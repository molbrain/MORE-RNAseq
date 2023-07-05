#!/bin/zsh

##############################
## template_002_fastqstats.zsh
##############################

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

  TOOL_FASTQSTATS=/home/Shared/Miscellaneous/Tools/ea-utils/fastq-stats
  echo -n "## TOOL_FASTQSTATS : ${TOOL_FASTQSTATS}"
  echo "## ",`${TOOL_FASTQSTATS} --help 2>&1 | grep Version`

  OUTPUT_FASTQSTATS_DIR=./FASTQSTATS
  echo "## OUTPUT_FASTQSTATS_DIR : ${OUTPUT_FASTQSTATS_DIR}"

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
	echo -n "# fastq-stats : ${FILENAME} "
	date
	
	EACH_DIR=./FASTQSTATS/${NUM}_R${PAIR}
	if [ -d ${EACH_DIR} ]
	then
	    echo "# Exist : ${EACH_DIR}"
	else
	    mkdir ${EACH_DIR}
	    echo "# Create : ${EACH_DIR}"
	fi

	${TOOL_FASTQSTATS} \
	    -s 5 \
	    ${FILENAME} \
	    | perl -pe "if(/^dup\ seq/){s/^dup\ seq\s/dup seq/;s/\t/ no/;s/(\d+)\t(\d+)\t/\1\t\2\,/;}" \
		   > ${EACH_DIR}/fastq-stats.txt
	
	ls -Fl ${EACH_DIR}
	
	echo -n "# fastq-stats ($NUM, $PAIR) done. "
	date
  done
  echo -n "# DONE $0 ($NUM) : "
  date
  
else
  
  ls -Fl ${RAWDATA_DIR}
  echo "## ${RAWDATA_DIR} is not exist..."
  echo -n "## Abort $0 : "
  date
  
fi
