#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra -y

megadl "https://mega.nz/#!Yj4hyZ4D!QJoo7UreDctJbDup1DIiGRLEl9CFUr4RJs2QTYXPP4U"
ffmpeg -i triangle.mp4 -vf scale=640:360 triangle480.mp4
#mkdir triangle
#mv triangle480.mp4 triangle
#7z a triangle.7z triangle
megaput --username $MEGAU --password $MEGAP triangle480.mp4
