#!/bin/zsh

####################################
## template_000_dataPreparation.zsh
###################################

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
  echo "## ./00000setup.zsh is exist"
  source 00000setup.zsh

  if [ -d ./${RAWDATA_DIR} ]
  then
      echo "## Files in ./Rawdata"
      ls -Fal ./${RAWDATA_DIR}/*

      if [ -d ${RESULT_DIR} ]
      then
      else
	  mkdir ./${RESULT_DIR}
      fi
      
      ls ./${RAWDATA_DIR}/* | grep -v ".pdf$\|.md5$\|.txt$\|.zsh$" | grep ".fastq.gz\|.fq.gz$\|.fastq$\|.fq$" \
          | sort -u \
		 > ./${RESULT_DIR}/list_fastqName.txt
      cat ./${RESULT_DIR}/list_fastqName.txt \
          | perl -pe 's/^.+\///;' | perl -pe 's/\.gz$//;' | perl -pe 's/\.f(ast)?q$//;' | perl -pe 's/_R?\d$//;' \
          | sort -u \
		 > ./${RESULT_DIR}/list_dataName.txt
      
      ls -Fal ./${RESULT_DIR}/list_fastqName.txt ./${RESULT_DIR}/list_dataName.txt
      cat ./${RESULT_DIR}/list_fastqName.txt
      
      if [ -e `head -1 ./${RESULT_DIR}/list_fastqName.txt` ]
      then
	  for DIR in \
		  $TEMP_DIR \
		  $STAR_RSEM_REF_DIR \
		  $ORIGINAL_REF_DIR \
		  $OUTPUT_FASTQC_DIR \
		  $OUTPUT_FASTQSTATS_DIR \
		  $OUTPUT_CUTADAPT_DIR \
		  $OUTPUT_TRIMMOMATIC_DIR \
		  $OUTPUT_STAR_DIR \
		  $OUTPUT_RSEM_DIR \
		  $OUTPUT_EDGER_DIR
	  do
              mkdir ./${DIR}
	  done
      else
	  ls -Fal ./`head -1 ./${RESULT_DIR}/list_fastqName.txt`
	  echo "## PLEASE PUT YOUR FASTQ DATA IN $RAWDATA_DIR"
      fi
  else
      ls -Fal ./${RAWDATA_DIR}
      echo "## PLEASE CREATE $RAWDATA_DIR AS RAWDATA directory (\$RAWDATA_DIR)"
  fi
  
fi

echo -n "## DONE : $0 "
date



