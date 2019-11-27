#! /usr/bin/env bash
git clone https://github.com/Thagoo/Triton_kernel_xiaomi_msm8917 -b tr-10-caf triton
git clone https://github.com/Thagoo/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 -b lineage-17.0 tc
cd triton
git clone https://github.com/Thagoo/AnyKernel3 
echo cloning done
GCC="$(pwd)/tc/bin/aarch64-linux-android
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=Thago
export KBUILD_BUILD_HOST=heroku
export CROSS_COMPILE="${GCC}"
make mrproper
mkdir -p out
make O=out rolex_defconfig
time make O=out -j9 -l9