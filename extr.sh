#!/bin/bash

git clone https://github.com/bkerler/oppo_ozip_decrypt ozipex
cd ozipex
wget http://downloads.oppo.com.s3.amazonaws.com/firmware/CPH1909/CPH1909EX_11_OTA_0360_all_JfNVvuqQWDjk.ozip
python ozipdecrypt.py *ozip
ls
rm -rf .git
cd out
git init
git add . -f
git commit -m "ranchu-Oppo-A5S" -s -q
git checkout -b CPH1909-23042020
git config --global http.postBuffer 15728640000
git config --global https.postBuffer 15728640000
git push -f --set-upstream https://Thagoo:${GH_TOKEN}@github.com/Thagoo/dump_oppo_A5S_ranchu CPH1909-23042020

