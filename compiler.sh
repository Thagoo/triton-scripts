#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools -y
#ffmpeg libavcodec-extra -y
wget http://s5.rexdl.com/android/game/GTA-San-Andreas-v2.00-www.ReXdl.com.zip -nv
mv GTA* gtasa
7z a gtasa.7z gtasa
#megadl "https://mega.nz/#!gygWgCLD!VAVpKscp5dZiadC9Plvj_hcRIvk7UChw3T3G4VGEdeI"
#mv *Cap* captfa.mkv
#ffmpeg -i captfa.mkv -vf scale=640:360 captfa360.mkv
#mkdir capcivilwar
#mv capcivilwar480.mp4 capcivilwar
#7z a capcivilwar.7z capcivilwar
megaput --username $MEGAU --password $MEGAP gtasa.7z
