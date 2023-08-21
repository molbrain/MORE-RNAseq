#!/bin/zsh

##########################################
## Preparetion data for R-readable format
##########################################
## v.1.0.1

echo -n "## START : $0 "
date

if [ -f ./00000setup.zsh ]
then
    echo "## ./00000setup.zsh : exist"
    source ./00000setup.zsh
else
    echo "## not ./00000setup.zsh"
    echo -n "## Abort $0 : "
    date
    exit 0
fi

#############################

cat ./${RESULT_DIR}/RSEM.genes.FPKM.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | perl -pe 'if(/^\#/){s/\tRSEM_/\t/g;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > ./${RESULT_DIR}/forR_RSEM.gene.FPKM.matrix.txt

cat ./${RESULT_DIR}/RSEM.genes.TPM.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | perl -pe 'if(/^\#/){s/\tRSEM_/\t/g;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > ./${RESULT_DIR}/forR_RSEM.gene.TPM.matrix.txt

cat ./${RESULT_DIR}/RSEM.genes.expected_count.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | perl -pe 'if(/^\#/){s/\tRSEM_/\t/g;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > ./${RESULT_DIR}/forR_RSEM.gene.expected_count.matrix.txt

if [ -e ./${RESULT_DIR}/STAR_ReadsPerGene.tsv.txt ]
then
	cat ./${RESULT_DIR}/STAR_ReadsPerGene.tsv.txt \
	    | perl -ne 'if(/^ENS|^L1fli/){print;}else{s/\./\-/g;print;}' \
	    | perl -pe 'if(/^\#/){s/\tSTAR_/\t/g;}' \
	    | sort -u \
	    | perl -pe 's/\#//;' \
		   > ./${RESULT_DIR}/forR_STAR_ReadsPerGene.txt
fi

zcat ./MORE-RNAseq/mart_export.${REF_NAME}.txt.gz \
    | perl -ne 'if(/^Gene/){print "\#IDs\tSymbol\tChr\tStrand\tStart\tEnd\tDescription\tType\n"}else{print;}' \
    | perl -pe "s/\'/_prime_/g;" \
    | perl -pe 's/(\ +)?\[.+\](\ +)?//;' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > ./${RESULT_DIR}/forR_GeneDesc.${REF_NAME}.plusL1fli.txt

cat ./MORE-RNAseq/MORE-reference/L1fli_Utr5toUtr3.${GENOME}.bed \
    | grep -v '^track' \
    | perl -ne 'chomp;s/^chr//; @l=split(/\t/); $id="L1fli-$l[3]";$name=$id;if($l[5]eq"+"){$strand=1;}else{$strand=-1} $type=""; if($l[4]>=16){$type="F.$type";$l[4]-=16} if($l[4]>=8){$type="T.$type";$l[4]-=8} if($l[4]>=4){$type="G.$type";$l[4]-=4} if($l[4]>=2){$type="A.$type";$l[4]-=2} if($l[4]==0){$type=~s/\.$//;$type2=$type;$type2=~s/\./\,/;print"$id\t$name\t$l[0]\t$strand\t",$l[1] +1,"\t$l[2]\tfull-length intact L1 ($l[3]; subfamily:$type2; L1Base2)\tL1-fli-$type\n"}' \
    | sort -u \
	   >> ./${RESULT_DIR}/forR_GeneDesc.${REF_NAME}.plusL1fli.txt

ls -Fal ./${RESULT_DIR}/forR_*txt

#############################

echo -n "## DONE $0 : "
date
