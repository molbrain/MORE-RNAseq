#!/bin/zsh


echo "## START $0 with $1 by $2"
TEMPLATE=$1
DATAID_LIST=$2

QSUBQUERY=`echo -n $1 | perl -pe 's/^template_//;s/^(\d+).+\.zsh$/query_$1\.sh/;'`
echo "#!/bin/sh\n" > ${QSUBQUERY}

SCRIPT_STOCK_DIR=./scripts
QUERY_STOCK_DIR=./qsub
LOG_STOCK_DIR=./LOGS

if [[ -d ${SCRIPT_STOCK_DIR} ]]
then
    
    if [[ -d ${QUERY_STOCK_DIR} ]]
    then
	
	if [[ -d ${LOG_STOCK_DIR} ]]
	then
	    
	    if [[ -f ${DATAID_LIST} ]]
	    then
		
		if [[ -f ${TEMPLATE} ]]
		then
		    
		    SCRIPT=`echo -n $1 | perl -pe 's/^template_//;s/\.zsh$//;'`
		    echo "# ${TEMPLATE} -> ${SCRIPT} : each SAMPLE scripts"
		    
		    while read SAMPLE
		    do
			NUM=`cat ${DATAID_LIST} | perl -pe '$i++;s/^/$i\t/;' | grep "	${SAMPLE}$" | cut -f1 | perl -ne 'print sprintf("%02d",$_);'`
			echo "# ${SAMPLE} ->${SCRIPT_STOCK_DIR}/${SCRIPT}_${NUM}.zsh"
			
			perl -e '($file,$sample)=@ARGV;open(FILE,$file);while(<FILE>){s/___SAMPLE___/${sample}/g;print;}close(FILE)' ${TEMPLATE} ${SAMPLE} \
			     > ${SCRIPT_STOCK_DIR}/${SCRIPT}_${NUM}.zsh
			
			chmod 755 ${SCRIPT_STOCK_DIR}/${SCRIPT}_${NUM}.zsh
			
			echo "#!/bin/sh\n" > ${QUERY_STOCK_DIR}/qsub_${SCRIPT}_${NUM}.sh
			QUERYCOMMAND="${SCRIPT_STOCK_DIR}/${SCRIPT}_${NUM}.zsh > ${LOG_STOCK_DIR}/LOG_${SCRIPT}_${NUM}.txt 2>&1"
			echo ${QUERYCOMMAND} >> ${QUERY_STOCK_DIR}/qsub_${SCRIPT}_${NUM}.sh
			echo ${QUERYCOMMAND} >> ${QSUBQUERY}
			
		    done < ${DATAID_LIST}
		    
		    chmod 755 ${QSUBQUERY}
		    echo "# DONE."
		    
		else
		    echo "# Not template: $1"
		fi
		
	    else
		echo "# Not data ID list: $2"
	    fi
	else
	    echo "# Not exist: ${LOG_STOCK_DIR}"
	fi
    else
	echo "# Not exist: ${QUERY_STOCK_DIR}"
    fi
    
else
    echo "# Not exist: ${SCRIPT_STOCK_DIR}"
fi
