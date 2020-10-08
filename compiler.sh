#! /usr/bin/env bash
export DIRNAME=out/t*/p*/r*
#FILE=camera.msm8937.so
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
mkdir ofrp
cd ofrp
repo init -u git://github.com/LineageOS/android.git -b lineage-17.1 --depth=1
repo sync -c -q --force-sync --no-clone-bundle --no-tags -j$(nproc --all) | tee sync.txt
if ! [ -a build/env* ];then
curl -F document=@sync.txt "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="synced sources successfully"
rm -rf device/xiaomi/riva
git clone https://github.com/Thagoo/recovery_device_xiaomi_rolex -b lineage-17.1 device/xiaomi/riva --depth=1 -q
git clone https://github.com/SunnyRaj84348/android_vendor_xiaomi -b lineage-17.1 vendor/xiaomi --depth=1 -q
git clone https://github.com/Thagoo/platform_kernel_xiaomi_msm8917 -b tr-4.9 --depth=1 kernel/xiaomi/msm8917 -q
rm kernel/xiaomi/msm8917/Android.bp
source build/envsetup.sh
lunch lineage_riva-userdebug
make -j$(nproc --all) camera.msm8937 | tee log.txt
if ! [ -a $DIRNAME/vendor/lib/hw/$FILE ];then
curl -F document=@log.txt "https://api.telegram.org/bot${tok}/sendDocument" \
        -F chat_id=${cid} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
cd $DIRNAME
zip -r cam.zip vendor/
#megaput --username $MEGAU --password $MEGAP $ZIPNAME
curl -F document=@cam.zip "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=$CID\
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

