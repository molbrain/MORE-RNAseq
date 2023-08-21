#!/bin/sh

## your data directory name
#TESTDATA=230809_Docker_forMORE-RNAseq



docker build -t centos7:MORE-RNAseq .



docker run -dit --name more-rnaseq centos7:MORE-RNAseq



#docker cp ./${TESTDATA}/ more-rnaseq:/root/testdata/



docker exec -it more-rnaseq /bin/bash



# docker cp more-rnaseq:/root/testdata/Results/ ./CopiedResults/
