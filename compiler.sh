#! /usr/bin/env bash
apt install git curl sudo -y
ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
export DEBIAN_FRONTEND=noninteractive

git clone https://github.com/akhilnarang/scripts
dpkg-reconfigure --frontend noninteractive tzdata
bash scripts/setup/android_build_env.sh
export DIRNAME=out/t*/p*/r*
TIME=$(date +"%S-%F")
#ZIPNAME=PitchBlack-rolex-${TIME}-UNOFFICIAL.zip
#sudo apt install -y megatools
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
mkdir twrp && cd twrp
repo init --depth=1 -q -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
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
rm -rf device/xiaomi/rolex
git clone -b test-wip --depth=1 https://github.com/Thagoo/recovery_device_xiaomi_rolex device/xiaomi/rolex 
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_rolex-eng
rm kernel/xiaomi/msm8917/Android.bp
rm -rf vendor/qcom/opensource/commonsys/cryptfs_hw
make -j$(nproc --all) recoveryimage
cd out/target/product/rolex
ls
curl -F document=@recovery.img "https://api.telegram.org/bot${TOKEN}/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

#megaput --username $MEGAU --password $MEGAP $ZIPNAME

