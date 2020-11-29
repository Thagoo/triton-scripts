#! /usr/bin/env bash
DIRNAME=out/t*/p*/r*
TIME=$(date +"%S-%F")
ZIPNAME=OrangeFox-R11.0_N2-Stable-rolex.zip
sudo apt install -y megatools repo
git config --global color.ui false
git config --global user.name Thagoo
git config --global user.email "lohitgowda56@gmail.com"
mkdir ofrp
cd ofrp
repo init --depth=1 -u https://gitlab.com/OrangeFox/Manifest.git -b fox_9.0 -q
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
git clone -b ofrp-4.9 --depth=1 https://github.com/Thagoo/recovery_device_xiaomi_rolex device/xiaomi/rolex
export ALLOW_MISSING_DEPENDENCIES=true
export TARGET_DEVICE_ALT="rova, riva"
export LC_ALL="C"
export TW_DEFAULT_LANGUAGE="en"
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_ZIP_BINARY=1
export FOX_REPLACE_BUSYBOX_PS=1
# export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION="1"; # disabling dm-verity causes stability issues with some kernel 4.9 ROMs; but is needed for MIUI
# export OF_DISABLE_FORCED_ENCRYPTION=1
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
export OF_USE_MAGISKBOOT="1"
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI="1"
export OF_NO_MIUI_OTA_VENDOR_BACKUP="1"
export OF_NO_TREBLE_COMPATIBILITY_CHECK="1"
export OF_FLASHLIGHT_ENABLE="0"
# OTA for custom ROMs
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
# -- add settings for R11 --
export FOX_R11=1
export FOX_ADVANCED_SECURITY=1
export OF_USE_TWRP_SAR_DETECT=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
export OF_QUICK_BACKUP_LIST="/boot;/data;/system_image;/vendor_image;"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/bootdevice/by-name/cust"
# -- end R11 settings --
export FOX_VERSION=R11.0_N2
export FOX_BUILD_TYPE="Stable"
export OF_MAINTAINER="Thago"
source build/envsetup.sh
lunch omni_rolex-eng
rm kernel/xiaomi/msm8917/Android.bp
rm -rf device/qcom/common/cryptfs_hw
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
make -j$(nproc --all) recoveryimage | tee log.txt
if ! [ -a out/target/product/rolex/*O*.zip ];then
curl -F document=@log.txt "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=${CID} \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 
           exit 1
fi
cd $DIRNAME
ls
#mv Orange*.zip $ZIPNAME
megaput --username $MEGAU --password $MEGAP OrangeFox-R11.0_N2-Stable-rolex.zip
curl -F document=@OrangeFox-R11.0_N2-Stable-rolex.zip "https://api.telegram.org/bot$TOKEN/sendDocument" \
        -F chat_id=$CID\
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" 

