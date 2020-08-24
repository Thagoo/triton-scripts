#! /usr/bin/env bash
export DIRNAME=out/t*/p*/r*
TIME=$(date +"%S-%F")
ZIPNAME=OrangeFox-R11.0-rolex-${TIME}-UNOFFICIAL.zip
sudo apt install -y megatools
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
repo init --depth=1 -u -q https://gitlab.com/OrangeFox/Manifest.git -b fox
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
rm -rf device/xiaomi/rolex
git clone -b fox_11.0 --depth=1 https://github.com/Thagoo/recovery_device_xiaomi_rolex device/xiaomi/rolex
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_rolex-eng
rm kernel/xiaomi/msm8917/Android.bp
rm -rf vendor/qcom/opensource/commonsys/cryptfs_hw
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
make -j$(nproc --all) recoveryimage | tee log.txt
if ! [ -a out/target/product/rolex/*U*.zip ];then
curl -F document=@log.txt "https://api.telegram.org/bot${tok}/sendDocument" \
        -F chat_id=${cid} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
cd $DIRNAME
mv Orange*.zip $ZIPNAME
#megaput --username $MEGAU --password $MEGAP $ZIPNAME
curl -F document=@$ZIPNAME.zip "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=$CID\
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

