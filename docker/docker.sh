#!/bin/sh

## Please change 'testdata' to your data directory name
TESTDATA=testdata

docker build -t centos7:MORE-RNAseq .

docker run -dit --name more-rnaseq centos7:MORE-RNAseq


if [ -d ./${TESTDATA} ]
then
   echo "${TESTDATA} dirctory is copying to docker image as '/root/testdata/' ..."
   docker cp ./${TESTDATA}/ more-rnaseq:/root/testdata/
else
   echo "If you want to copy your data to docker-image, do the command like this: 'docker cp ./your-data-directory/ more-rnaseq:/root/testdata/'."
fi
echo "If you want to copy your data from docker image, do the command like this: 'docker cp more-rnaseq:/root/testdata/Results/ ./CopiedResults/'."

docker exec -it more-rnaseq /bin/zsh
