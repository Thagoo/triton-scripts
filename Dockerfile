FROM ubuntu:focal

LABEL maintainer="Thagoo <lohitgowda56@gmail.com>"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    JAVA_OPTS=" -Xmx3840m " \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk-amd64 \
    PATH=~/bin:/usr/local/bin:/home/builder/bin:$PATH

RUN sed 's/main$/main universe/' /etc/apt/sources.list 1>/dev/null

RUN apt-get update               \
 && apt-get -y -q upgrade        \
 && apt-get -y -q install        \
    bc                           \
    binutils-arm-linux-gnueabihf \
    build-essential              \
    ccache                       \
    git                          \
    libncurses-dev               \
    libssl-dev                   \
    u-boot-tools                 \
    wget                         \
    xz-utils                     \
    python \
    python3 \
    curl \
    zip \
    flex \
    bison \
    bc

RUN git config --global user.name "Thagoo"
RUN git config --global user.email "lohitgowda56@gmail.com"
RUN git config --global http.sslVerify false
RUN git clone https://github.com/kdrag0n/proton-clang -b master --depth 1 --single-branch -q /tmp/proton
RUN rm -rf /tmp/proton/.git
RUN git clone https://github.com/Thagoo/AnyKernel3 -b ts-proton-rova --depth 1 /tmp/AnyKernel3
