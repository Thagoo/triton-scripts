#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra -y

megadl "https://mega.nz/#!drhh0aBC!ukoDkQx76xU1CzL2AHh6Lu-8PHQjS98fE87SmHU_9OQ"
ffmpeg -i gg.mp4 -vf scale=-2:480 gg480.mp4
mkdir gone
mv gg480.mp4 gone
7z a gonegirl.7z gone
megaput --username $MEGAU --password $MEGAP gonegirl.7z
