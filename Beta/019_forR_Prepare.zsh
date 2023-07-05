#!/bin/zsh

OUTPUT_RSEM_DIR=./RSEM

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

zcat ../mart_export.ens102.mouse.txt.gz \
    | cut -f1-6,8,10 \
    | perl -ne 'if(/^Gene/){print "\#ID\tSymbol\tChr\tStrand\tStart\tEnd\tDescription\tType\n"}else{print;}' \
    | perl -pe "s/\'/_prime_/g;" \
    | perl -pe 's/(\ +)?\[.+\](\ +)?//;' \
    | sort -u \
    | perl -pe 's/\#//;' \
	   > forR_GeneDesc.102.plusL1fli.txt

cat ../L1mouse_Utr5toUtr3.bed \
    | grep -v '^track' \
    | perl -ne 'chomp;s/^chr//; @l=split(/\t/); $id="L1fli-$l[3]";$name=$id;if($l[5]eq"+"){$strand=1;}else{$strand=-1} $type=""; if($l[4]>=16){$type="F.$type";$l[4]-=16} if($l[4]>=8){$type="T.$type";$l[4]-=8} if($l[4]>=4){$type="G.$type";$l[4]-=4} if($l[4]>=2){$type="A.$type";$l[4]-=2} if($l[4]==0){$type=~s/\.$//;$type2=$type;$type2=~s/\./\,/;print"$id\t$name\t$l[0]\t$strand\t",$l[1] +1,"\t$l[2]\tfull-length intact L1 ($l[3]; subfamily:$type2; L1Base2)\tL1-fli-$type\n"}' \
    | sort -u \
	   >> forR_GeneDesc.102.plusL1fli.txt
