ZIPNAME=Triton-Atmosphere-$(date +"%S-%F")

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=Thago
export CROSS_COMPILE=/tmp/gcc64/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/tmp/gcc32/bin/arm-linux-androideabi-
make mrproper
mkdir -p out
make O=out rolex_defconfig
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="build started"
make O=out -j$(nproc --all) -l$(nproc --all) | tee log.txt
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

