ZIPNAME=Triton-Storm-$(date +"%S-%F")

mkdir -p out

make O=out ARCH=arm64 rolex_defconfig

PATH="/tmp/proton/bin:$PATH" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      AR=llvm-ar \
                      NM=llvm-nm \
	              LD=ld.lld \
	              STRIP=llvm-strip \
	              OBJCOPY=llvm-objcopy \
	              OBJDUMP=llvm-objdump \
	              OBJSIZE=llvm-size \
	              READELF=llvm-readelf \
	              HOSTCC=clang \
	              HOSTCXX=clang++ \
	              HOSTAR=llvm-ar \
	              HOSTLD=ld.lld 

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
	-F caption="#triton #storm #4.9 #ALPHA compiled from Proton-Clang-v12 follow @tboxxx for more updates"
