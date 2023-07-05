#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

OUTPUT_STAR_DIR=./RSEM
TOOL_SAMTOOLS=~/bin/samtools/bin/samtools
echo -n "# TOOLS_SAMTOOLS : ${TOOL_SAMTOOLS} / "
~/bin/samtools/bin/samtools --version | grep samtools

NUM=___SAMPLE___

echo "# Sample: ${NUM}"

EACH_DIR=${OUTPUT_STAR_DIR}/RSEM_${NUM}

echo -n "# start : ${DATANAME}"
date
${TOOL_SAMTOOLS} stats ${EACH_DIR}/${NUM}.transcript.bam \
		     > ${EACH_DIR}/samtools.stats.${NUM}.transcript.bam.txt

echo "# SAMTOOLS stats : END."

echo -n "# $0 DONE. "
date
