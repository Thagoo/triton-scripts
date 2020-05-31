#!/bin/bash
PROJECT_DIR=dump
UNZIP_DIR=out
PARTITIONS="system vendor cust odm oem factory product modem xrom systemex"
mkdir -p $PROJECT_DIR/working
cd $PROJECT_DIR
git clone https://github.com/bkerler/oppo_ozip_decrypt ozipex
git clone -q https://github.com/PabloCastellano/extract-dtb extract-dtb
git clone -q https://github.com/carlitros900/mkbootimg_tools mkbootimg_tools
cd ozipex
wget http://downloads.oppo.com.s3.amazonaws.com/firmware/CPH1909/CPH1909EX_11_OTA_0360_all_JfNVvuqQWDjk.ozip -nv
python ozipdecrypt.py *ozip > /dev/null
ls
rm -rf .git
cd out && ls && cd ../
mv out ../working
cd ../../
if [[ -f "$PROJECT_DIR"/working/"${UNZIP_DIR}"/boot.img ]]; then
    python3 "$PROJECT_DIR"/extract-dtb/extract-dtb.py "$PROJECT_DIR"/working/"${UNZIP_DIR}"/boot.img -o "$PROJECT_DIR"/working/"${UNZIP_DIR}"/bootimg > /dev/null # Extract boot
    bash "$PROJECT_DIR"/mkbootimg_tools/mkboot "$PROJECT_DIR"/working/"${UNZIP_DIR}"/boot.img "$PROJECT_DIR"/working/"${UNZIP_DIR}"/boot > /dev/null 2>&1
    echo 'boot extracted'
    # extract-ikconfig
    [[ ! -e ${PROJECT_DIR}/extract-ikconfig ]] && curl https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-ikconfig > ${PROJECT_DIR}/extract-ikconfig
    bash ${PROJECT_DIR}/extract-ikconfig "$PROJECT_DIR"/working/"${UNZIP_DIR}"/boot.img > "$PROJECT_DIR"/working/"${UNZIP_DIR}"/ikconfig
fi

if [[ -f "$PROJECT_DIR"/working/"${UNZIP_DIR}"/dtbo.img ]]; then
    python3 "$PROJECT_DIR"/extract-dtb/extract-dtb.py "$PROJECT_DIR"/working/"${UNZIP_DIR}"/dtbo.img -o "$PROJECT_DIR"/working/"${UNZIP_DIR}"/dtbo > /dev/null # Extract dtbo
    echo 'dtbo extracted'
fi

# Extract dts
mkdir -p "$PROJECT_DIR"/working/"${UNZIP_DIR}"/bootdts
dtb_list=$(find "$PROJECT_DIR"/working/"${UNZIP_DIR}"/bootimg -name '*.dtb' -type f -printf '%P\n' | sort)
for dtb_file in $dtb_list; do
    dtc -I dtb -O dts -o "$(echo "$PROJECT_DIR"/working/"${UNZIP_DIR}"/bootdts/"$dtb_file" | sed -r 's|.dtb|.dts|g')" "$PROJECT_DIR"/working/"${UNZIP_DIR}"/bootimg/"$dtb_file" > /dev/null 2>&1
done

cd dump/working/out
# board-info.txt
chown "$(whoami)" ./* -R
chmod -R u+rwX ./* #ensure final permissions
export GIT_CURL_VERBOSE=1 git push
git init
git config --global http.postBuffer 1572864000
git config --global https.postBuffer 1572864000
git checkout -b CPH1909-23042020
find . -size +97M -printf '%P\n' -o -name "*sensetime*" -printf '%P\n' -o -name "*.lic" -printf '%P\n' >| .gitignore
git add --all > /dev/null
git commit -asm "ranchu-Oppo-A5S" -s -q > /dev/null
git config --global http.postBuffer 1572864000
git config --global https.postBuffer 1572864000
ORG=Thagoo
repo=dump_oppo_A5S_ranchu
branch=CPH1909-23042020
git push -f --set-upstream http://Thagoo:${GH_TOKEN}@github.com/Thagoo/dump_oppo_A5S_ranchu CPH1909-23042020
     (
            git update-ref -d HEAD
            git reset system/ vendor/
            git checkout -b "$branch"
            git commit -asm "Add extras "
            git push https://"$GH_TOKENg"@github.com/$ORG/"${repo,,}".git "$branch"
            git add vendor/
            git commit -asm "Add vendor "
            git push https://"$GH_TOKEN"@github.com/$ORG/"${repo,,}".git "$branch"
            git add system/system/app/ system/system/priv-app/ || git add system/app/ system/priv-app/
            git commit -asm "Add apps"
            git push https://"$GH_TOKENg"@github.com/$ORG/"${repo,,}".git "$branch"
            git add system/
            git commit -asm "Add system "
            git push https://"$GH_TOKENg"@github.com/$ORG/"${repo,,}".git "$branch"
        )

