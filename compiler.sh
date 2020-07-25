#! /usr/bin/env bash
export DIRNAME=out/t*/p*/r*
TIME=$(date +"%S-%F")
ZIPNAME=recovery.img
sudo apt install -y megatools
curl https://storage.googleapis.com/git-repo-downloads/repo > repo && chmod a+x repo && sudo install repo /usr/local/bin && rm repo
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
repo init
repo init -u git://github.com/PterodonRecovery/manifest.git -b master --depth=1 -q
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
git clone -b trp --depth=1 https://github.com/Thagoo/recovery_device_xiaomi_rolex device/xiaomi/rolex
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_rolex-eng
git clone https://github.com/Thagoo/platform_kernel_xiaomi_msm8917 -b twrp --single-branch --depth=1 kernel/xiaomi/msm8917
rm kernel/xiaomi/msm8917/Android.bp
rm -rf vendor/qcom/opensource/commonsys/cryptfs_hw
mka -j$(nproc --all) recoveryimage | tee log.txt
#if ! [ -a out/target/product/rolex/*U*.zip ];then
#curl -F document=@log.txt "https://api.telegram.org/bot${TOKEN}/sendDocument" \
#        -F chat_id=${CID} \
     #   -F "disable_web_page_preview=true" \
#        -F "parse_mode=html" 
    #       exit 1
#fi
cd $DIRNAME
ls
#mv Pitch*-UNOFFICIAL.zip $ZIPNAME
#megaput --username $MEGAU --password $MEGAP $ZIPNAME
curl -F document=@recovery.img "https://api.telegram.org/bot${TOKEN}/sendDocument" \
         -F chat_id=${CID} \
         -F "disable_web_page_preview=true" \
         -F "parse_mode=html" 
