#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra -y

megadl "https://mega.nz/#!F7JzAYQA!1_-3JgyqqIcoCpDPUxeNsRe34umdDBOp7n4XrkzRJ6w"
mv Ave* aendgame.mkv
ffmpeg -i aendgame.mkv -vf scale=640:360 aendgame360.mkv
#mkdir capcivilwar
#mv capcivilwar480.mp4 capcivilwar
#7z a capcivilwar.7z capcivilwar
megaput --username $MEGAU --password $MEGAP aendgame360.mkv
