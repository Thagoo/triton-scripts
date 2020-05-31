#!/bin/bash

apt install -y unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller rename
apt install -y liblzma-dev python-pip brotli python-lz4 lz4
pip3 install -y backports.lzma protobuf pycrypto
git clone https://github.com/bkerler/oppo_ozip_decrypt ozipex
cd ozipex
pip3 install -r require*txt
wget http://downloads.oppo.com.s3.amazonaws.com/firmware/CPH1909/CPH1909EX_11_OTA_0360_all_JfNVvuqQWDjk.ozip -o firmware.ozip
python ozipdecrypt.py firmware.ozip
ls
cd out
mv firm*zip firmware.zip
git clone --recurse-submodules https://github.com/erfanoabdi/Firmware_extractor.git fe
cd ozipex/out
mv firmware.zip ../../fe
./extractor.sh firmware.zip
mv out ../
cd ../out
git init
git checkout -b CPH1909-23042020
git add . -f
git commit -m "ranchu-Oppo-A5S" -s
git remote add o https://Thagoo:${GH_TOKEN}@github.com/Thagoo/oppo-A5S-ranchu.git
git push -f o


