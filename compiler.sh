#! /usr/bin/bash

ZIPNAME=Triton-Atmosphere-$(date +"%S-%F")

make O=out ARCH=arm64 rolex_defconfig

export CC=/tmp/clang/bin/clang
#export KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
export CROSS_COMPILE=/tmp/gcc64/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/tmp/gcc32/bin/arm-linux-androideabi-
export CLANG_TRIPLE=aarch64-linux-gnu-
export ARCH=arm64
export SUBARCH=arm64

PATH="/tmp/clang/bin:/tmp/gcc64/bin:/tmp/gcc32/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
		      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="build started"
if ! [ -a "out/arch/arm64/boot/Image.gz-dtb" ]; then    
   curl -F document=@log.txt "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
cp out/arch/arm64/boot/Image.gz-dtb /tmp/AnyKernel3
cd /tmp/AnyKernel3
zip -r ${ZIPNAME}.zip *

curl -F document=@$ZIPNAME.zip "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=$CID\
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html"  \
	-F caption="#triton #atmosphere follow @tboxxx for more updates"

