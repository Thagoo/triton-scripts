#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra -y

megadl "https://mega.nz/#!0mx2SYQT!Q6V8LPW4bh1_yoSFfqQbgmSr8MZaqgXS51j8zKJRjvs"
ffmpeg -i primer.mp4 -vf scale=640:360 primer480.mp4
mkdir primer
mv primer480.mp4 primer
7z a primer.7z primer
megaput --username $MEGAU --password $MEGAP primer.7z
