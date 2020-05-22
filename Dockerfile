FROM ubuntu:bionic

LABEL maintainer="Thagoo <lohitgowda56@gmail.com>"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    JAVA_OPTS=" -Xmx3840m " \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk-amd64 \
    PATH=~/bin:/usr/local/bin:/home/builder/bin:$PATH \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
    CCACHE_COMPRESSLEVEL=8 \
    CCACHE_DIR=/srv/ccache
RUN git config --global user.name "Thagoo"
RUN git config --global user.email "lohitgowda56@gmail.com"
RUN sed 's/main$/main universe/' /etc/apt/sources.list 1>/dev/null
RUN set -xe\
    && apt -q -y \
            git \
            bc \
            ccache \
            ncurses5-libs \
            bash \
            moreutils \
            automake \
            autoconf \
            gawk \
            libtool \
            zip \
            curl \
            wget \
            gnupg \
            python3 \
            python3-dev \
            unzip \
            openjdk8 \
            pigz \
            tar \
            build-base --no-cache
RUN cd ~/
    && git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 -b lineage-17.1 --depth 1 --single-branch gcc
    && git clone https://github.com/Thagoo/AnyKernel3 -b ta --depth 1 
