#! /usr/bin/env bash

wget http://s8.rexdl.com/android/game/PUBG-Mobile-0.18.0-www.ReXdl.com.zip
unzip *.zip
sudo apt install p7zip-full megatools -y
7z a pubg.7z com*
ZIPNAME=pubg.7z
megaput --username $MEGAU --password $MEGAP $ZIPNAME
