################################################################################
### Docerfile of tools for MORE-RNAseq v1.0.1b.230819
################################################################################

### Base Image
FROM centos:centos7.9.2009

MAINTAINER Yutaka Nakachi <nakachiy@gmail.com>


### Update and initial install of tools
RUN yum -y update
RUN yum -y install bash
RUN yum -y install zsh
RUN yum -y install wget
RUN yum -y install unzip
RUN yum -y groupinstall "Development Tools"
RUN yum -y install epel-release


### Install Java

RUN yum -y install java-1.8.0-openjdk


### Install Python3

RUN yum -y install python3


### Install Perl

RUN yum -y install perl
RUN yum -y install perl-Env



################################################################################

### Pre-process

RUN mkdir /root/src



################################################################################

### Install fastqc

RUN cd /root/src && \
    wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip && \
    unzip fastqc_v0.11.8.zip
RUN cp -rp /root/src/FastQC /usr/local/bin/FastQC-0.11.8 && \
    chmod 755 /usr/local/bin/FastQC-0.11.8/fastqc
#RUN echo "export PATH=/usr/local/bin/FastQC-0.11.8:\$PATH" >> /root/.bashrc
ENV PATH /usr/local/bin/FastQC-0.11.8:$PATH

### Install cutadapt

RUN yum -y install python3-devel
RUN cd /root
RUN python3 -m pip install cutadapt==1.18


# Install Trimmomatic

RUN cd /root/src && \
    wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip && \
    unzip Trimmomatic-0.38.zip
RUN cp -rp /root/src/Trimmomatic-0.38 /usr/local/bin/Trimmomatic-0.38


### Install STAR

RUN cd /root/src && \
    wget https://github.com/alexdobin/STAR/archive/refs/tags/2.6.0c.tar.gz && \
    mv 2.6.0c.tar.gz STAR-2.6.0c.tar.gz && \
    tar zxvf STAR-2.6.0c.tar.gz && \
    cp -rp STAR-2.6.0c/bin/Linux_x86_64_static /usr/local/bin/STAR-2.6.0c
#RUN echo "export PATH=/usr/local/bin/STAR-2.6.0c:\$PATH" >> /root/.bashrc
ENV PATH /usr/local/bin/STAR-2.6.0c:$PATH


### Install samtools
RUN yum -y install samtools

RUN yum -y install zlib
RUN yum -y install zlib-devel
RUN yum -y install ncurses
RUN yum -y install ncurses-devel
RUN yum -y install bzip2-libs
RUN yum -y install bzip2-devel
RUN yum -y install libcurl
#RUN yum -y install libcrypto
RUN yum -y install gcc
RUN yum -y install make
RUN yum -y install xz-devel


RUN cd /root/src && \
    wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
    wget https://github.com/samtools/htslib/releases/download/1.11/htslib-1.11.tar.bz2
RUN cd /root/src && \
    tar jxvf samtools-1.11.tar.bz2 && \
    tar jxvf htslib-1.11.tar.bz2
RUN cd /root/src/samtools-1.11/ && autoheader
RUN cd /root/src/samtools-1.11/ && autoconf -Wno-syntax
RUN cd /root/src/samtools-1.11/ && ./configure
RUN cd /root/src/samtools-1.11/ && make
RUN mkdir /usr/local/bin/samtools-1.11
RUN cd /root/src/samtools-1.11/ && make install DESTDIR=/usr/local/bin prefix=/samtools-1.11
#RUN echo "export PATH=/usr/local/bin/samtools-1.11/bin:\$PATH" >> /root/.bashrc
ENV PATH /usr/local/bin/samtools-1.9/bin:$PATH

### Install RSEM

RUN yum -y install zlib
RUN yum -y install zlib-devel
RUN yum -y install ncurses
RUN yum -y install bzip2-libs
RUN yum -y install libcurl
RUN yum -y install gcc
RUN yum -y install make
RUN cd /root/src && \
    wget https://github.com/deweylab/RSEM/archive/refs/tags/v1.3.3.tar.gz && \
    mv v1.3.3.tar.gz RSEM-v1.3.3.tar.gz && \
    tar zxvf RSEM-v1.3.3.tar.gz && \
    cd RSEM-1.3.3/ && \
    make && \
    mkdir /usr/local/bin/RSEM-1.3.3 && \
    make install DESTDIR=/usr/local/bin prefix=/RSEM-1.3.3
RUN echo "export PATH=/usr/local/bin/RSEM-1.3.3/bin:\$PATH" >> /root/.bashrc
ENV PATH /usr/local/bin/RSEM-1.3.3/bin:$PATH

### Install fastq-stats

RUN cd /root/src && \
    wget https://github.com/ExpressionAnalysis/ea-utils/archive/refs/heads/master.tar.gz && \
    mv master.tar.gz ea-utils-1.01.tar.gz && \
    tar zxvf ea-utils-1.01.tar.gz
RUN mkdir /usr/local/bin/ea-utils-1.01
RUN cd /root/src/ea-utils-master/clipper && \
    make fastq-stats
RUN cp /root/src/ea-utils-master/clipper/fastq-stats /usr/local/bin/ea-utils-1.01/ && \
    echo "export PATH=/usr/local/bin/ea-utils-1.01:\$PATH" >> /root/.bashrc
ENV PATH /usr/local/bin/ea-utils-1.01:$PATH

### Install R

RUN yum -y install readline 
RUN yum -y install readline-devel 
RUN yum -y install xorg-x11-server-devel
RUN yum -y install libX11-devel
RUN yum -y install libXt-devel
RUN yum -y install bzip2-devel
RUN yum -y install pcre
RUN yum -y install xz-devel
RUN yum -y install pcre2-devel
RUN yum -y install libcurl-devel
RUN yum -y install which
RUN yum -y install java-1.8.0-openjdk-devel
RUN yum -y install libpng-devel
RUN yum -y install openssl-devel
RUN yum -y install libxml2-devel

RUN localedef -f UTF-8 -i en_US en_US
RUN mkdir /usr/local/bin/R-3.5.1
RUN cd /root/src && \
    wget https://cran.r-project.org/src/base/R-3/R-3.5.1.tar.gz && \
    tar -zxvf R-3.5.1.tar.gz
RUN cd /root/src/R-3.5.1 && ./configure --prefix=/usr/local/bin/R-3.5.1
RUN cd /root/src/R-3.5.1 && make
RUN cd /root/src/R-3.5.1 && make install
ENV PATH /usr/local/bin/R-3.5.1/bin:$PATH

RUN Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/locfit/locfit_1.5-9.1.tar.gz", repos=NULL, type="source");'
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R")'
RUN Rscript -e 'BiocInstaller::biocLite(c("edgeR"));'

#RUN Rscript -e 'BiocInstaller::biocLite(c("org.Hs.eg.db"));'
#RUN Rscript -e 'BiocInstaller::biocLite(c("org.Mm.eg.db"));'
#RUN Rscript -e 'BiocInstaller::biocLite(c("GO.db"));'
#RUN Rscript -e 'BiocInstaller::biocLite(c("GOstats"));'


################################################################################

### Post-processes

RUN yum clean all
RUN rm -fr /root/src

### If you prepare your data directory (e.g. testdata, as below) using Dockerfile, please use COPY like below.
#COPY testdata/ /root/MOREtest/

WORKDIR /root
