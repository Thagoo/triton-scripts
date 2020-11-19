#! /usr/bin/env bash
apt install git curl sudo -y
export DIRNAME=out/t*/p*/t*
TIME=$(date +"%S-%F")
#ZIPNAME=PitchBlack-rolex-${TIME}-UNOFFICIAL.zip
#sudo apt install -y megatools
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
mkdir twrp && cd twrp
repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-10.0 -q
repo sync -c -q --force-sync --no-clone-bundle --no-tags -j$(nproc --all) 
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
rm -rf device/xiaomi/tiare
git clone -b android-9.0 --depth=1 https://github.com/Thagoo/twrp_device_xiaomi_tiare device/xiaomi/tiare
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_tiare-eng
rm kernel/xiaomi/tiare-4.9/Android.bp
#rm -rf vendor/qcom/opensource/commonsys/cryptfs_hw
make -j$(nproc --all) recoveryimage
cd out/target/product/tiare
ls
ZIP=recovery.img
curl -F document=@$ZIP "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

#megaput --username $MEGAU --password $MEGAP $ZIPNAME

