#!/bin/zsh

OUTPUT_RSEM_DIR=./RSEM
L1_INFO_DIR=/home/Shared/Miscellaneous/Public/GTF_with_fli_L1
GENOME=
#GENOME < e.g. human: GRCh38 , mouse: GRCm38
ENSRELEASE=
#ENSRELEASE < e.g. 102

cat ${OUTPUT_RSEM_DIR}/RSEM.genes.FPKM.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > forR_RSEM.gene.FPKM.matrix.txt

cat ${OUTPUT_RSEM_DIR}/RSEM.genes.TPM.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > forR_RSEM.gene.TPM.matrix.txt

cat ${OUTPUT_RSEM_DIR}/RSEM.genes.expected_count.matrix.tsv.txt \
    | perl -ne 'if(/^ENS|^L1fli/){s/_/\t/;print;}else{s/\t/\tSymbol\t/;s/\./\-/g;print;}' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > forR_RSEM.expected_count.matrix.txt

zcat ${L1_INFO_DIR}/mart_export.ens${ENSRELEASE}.${GENOME}.txt.gz \
    | cut -f1-6,8,10 \
    | perl -ne 'if(/^Gene/){print "\#ID\tSymbol\tChr\tStrand\tStart\tEnd\tDescription\tType\n"}else{print;}' \
    | perl -pe "s/\'/_prime_/g;" \
    | perl -pe 's/(\ +)?\[.+\](\ +)?//;' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > forR_GeneDesc.plusL1fli.txt

if [ -e ${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.bed ]
then
    echo "### GENOME : $GENOME "
    if [ $GENOME = "GRCm38" ]
    then
	echo "### > mouse"
    	cat ${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.bed \
	    | grep -v '^track' \
	    | perl -ne 'chomp;s/^chr//; @l=split(/\t/); $id="L1fli-$l[3]";$name=$id;if($l[5]eq"+"){$strand=1;}else{$strand=-1} $type=""; if($l[4]>=16){$type="F.$type";$l[4]-=16} if($l[4]>=8){$type="T.$type";$l[4]-=8} if($l[4]>=4){$type="G.$type";$l[4]-=4} if($l[4]>=2){$type="A.$type";$l[4]-=2} if($l[4]==0){$type2=$type;$type=~s/\.$//g;$type2=~s/\./\,/g;$type2=~s/\,$//;print"$id\t$name\t$l[0]\t$strand\t",$l[1] +1,"\t$l[2]\tfull-length intact L1 ($l[3]; subfamily:$type2; L1Base2)\tL1-fli-$type\n";}' \
	    | sort -u \
		   > forR_GeneDesc.plusL1fli.txt
    elif [ $GENOME = "GRCh38" ]
    then
	echo "### > human"
	cat ${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.bed \
	    | grep -v '^track' \
	    | perl -ne 'chomp;s/^chr//; @l=split(/\t/); $id="L1fli-$l[3]";$name=$id;if($l[5]eq"+"){$strand=1;}else{$strand=-1} $type="";if($l[4]>=4){$type="PA2.$type";$l[4]-=4} if($l[4]>=2){$type="HS.$type";$l[4]-=2} if($l[4]==0){$type2=$type;$type=~s/\.$//g;$type2=~s/\./\,/g;$type2=~s/\,$//;print"$id\t$name\t$l[0]\t$strand\t",$l[1] +1,"\t$l[2]\t full-length intact L1 ($l[3]; subfamily:$type2; L1Base2)\tL1-fli-$type\n";}' \
	    | sort -u \
                   > forR_GeneDesc.plusL1fli.txt
    else
	echo "### > NO SPECIFIC TREATMENT"
	cat ${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.bed \
	    | grep -v '^track' \
	    | perl -ne 'chomp;s/^chr//; @l=split(/\t/); $id="L1fli-$l[3]";$name=$id;if($l[5]eq"+"){$strand=1;}else{$strand=-1} $type=$l[4]; print"$id\t$name\t$l[0]\t$strand\t",$l[1] +1,"\t$l[2]\t full-length intact L1 ($l[3]; subfamily:$type; L1Base2)\tL1-fli-$type\n";' \
	    | sort -u \
                   > forR_GeneDesc.plusL1fli.txt
    fi
    
else
    echo "## NOT EXIST : ${L1_INFO_DIR}/L1fli_Utr5toUtr3.${GENOME}.bed "
fi

