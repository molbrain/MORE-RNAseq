#!/bin/zsh

#############################
## samtools_stats_star
#############################


echo -n "## $0 start : "
date


#############################

OUTPUT_STAR_DIR=./STAR

TOOL_SAMTOOLS=/home/nakachiy/bin/samtools/bin/samtools
echo -n "# TOOLS_SAMTOOLS : ${TOOL_SAMTOOLS} / "
${TOOL_SAMTOOLS} --version | grep samtools


#############################

NUM=___SAMPLE___

echo -n "# Sample: ${NUM}"
date


EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${NUM}
if [ -d ${EACH_DIR} ]
then
    echo "# Exist: ${EACH_DIR}."
    for DATANAME in sortedByCoord toTranscriptome
    do
	echo -n "# Start samtools stats : ${DATANAME}"
	date
	${TOOL_SAMTOOLS} stats ${EACH_DIR}/Aligned.${DATANAME}.out.bam \
	     	> ${EACH_DIR}/samtools.stats.Aligned.${DATANAME}.out.bam.txt
    done
    
    echo -n "# End : ${DATANAME} "
    date
    
else
    echo "# ${EACH_DIR} is NOT FOUND."
fi



#############################

echo -n "# $0 DONE. "
date
