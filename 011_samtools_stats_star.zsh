#!/bin/zsh

echo "#######################"
echo "# exe: $0."
echo "#######################"

echo -n "# START: "
date

OUTPUT_STAR_DIR=./STAR
TOOL_SAMTOOLS=~/bin/samtools/bin/samtools
echo -n "# TOOLS_SAMTOOLS : ${TOOL_SAMTOOLS} / "
~/bin/samtools/bin/samtools --version | grep samtools

NUM=___SAMPLE___

echo "# Sample: ${NUM}"

EACH_DIR=${OUTPUT_STAR_DIR}/STAR_${NUM}

for DATANAME in sortedByCoord toTranscriptome
do
    echo -n "# start : ${DATANAME}"
    date
    ${TOOL_SAMTOOLS} stats ${EACH_DIR}/Aligned.${DATANAME}.out.bam \
		     > ${EACH_DIR}/samtools.stats.Aligned.${DATANAME}.out.bam.txt
done

echo "# SAMTOOLS stats : END."

echo -n "# $0 DONE. "
date
