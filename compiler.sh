#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra unzip -y
#wget http://s5.rexdl.com/android/game/GTA-San-Andreas-v2.00-www.ReXdl.com.zip -nv
#mv GTA* gtasa
#7z a gtasa.7z gtasa
megadl "https://mega.nz/#!x6wACSSK!FytxLrBBenr1tH7NNNUnNQix5J-lHedyvV6j0P2iNEg"
unzip dark*.zip
ffmpeg -i s2e1.mkv -vf scale=640:360 s2e1.360.mkv >> /dev/null
ffmpeg -i s2e2.mkv -vf scale=640:360 s2e2.360.mkv >> /dev/null
ffmpeg -i s2e3.mkv -vf scale=640:360 s2e3.360.mkv >> /dev/null
ffmpeg -i s2e4.mkv -vf scale=640:360 s2e4.360.mkv >> /dev/null
#mkdir capcivilwar
#mv capcivilwar480.mp4 capcivilwar
7z a darks11to4.7z *360.mkv
megaput --username $MEGAU --password $MEGAP darks11to4.7z
