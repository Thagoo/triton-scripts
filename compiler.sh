#! /usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Kolkata
export TIME=$(date +"%S-%F")
export ZIPNAME=Triton-Ebella-${TIME}
ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
	autoconf \
	autogen \
	automake \
	autotools-dev \
	bc \
	binutils \
	binutils-aarch64-linux-gnu \
	binutils-arm-linux-gnueabi \
	bison \
	bzip2 \
	ca-certificates \
	coreutils \
	cmake \
	curl \
	expect \
	flex \
	g++ \
	gawk \
	gcc \
	git \
	gnupg \
	gperf \
	help2man \
	lftp \
	libc6-dev \
	libelf-dev \
	libgomp1-* \
	liblz4-tool \
	libncurses5-dev \
	libssl-dev \
	libstdc++6 \
	libtool \
	libtool-bin \
	m4 \
	make \
	nano \
	openjdk-8-jdk \
	openssh-client \
	openssl \
	ovmf \
	patch \
	pigz \
	python3 \
	python \
	rsync \
	shtool \
	subversion \
	tar \
	texinfo \
	tzdata \
	u-boot-tools \
	unzip \
	wget \
	xz-utils \
	zip \
	zlib1g-dev \
	zstd

git clone --depth=1 -j$(nproc --all) -b tr-10-EAS https://github.com/Thagoo/Triton_kernel_xiaomi_msm8917 --single-branch triton && cd triton
git clone https://github.com/Thagoo/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 -b lineage-17.0 tc
git clone https://github.com/Thagoo/AnyKernel3
echo cloning done
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=Thago
export CROSS_COMPILE=$(pwd)/tc/bin/aarch64-linux-android-
make mrproper
mkdir -p out
make O=out rolex_defconfig
make O=out -j$(nproc --all) -l$(nproc --all) | tee log.txt
if ! [ -a "out/arch/arm64/boot/Image.gz-dtb" ]; then    
   curl -F document=@log.txt "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
cd AnyKernel3
zip -r ${ZIPNAME}.zip *

curl -F document=@$ZIPNAME.zip "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=$CID\
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 



