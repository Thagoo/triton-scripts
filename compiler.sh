#! /usr/bin/env bash

wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
mkdir mat
mv The* matr
mv matr mat
sudo apt install p7zip-full megatools -y
7z a matrix.7z mat
ZIPNAME=matrix.7z
megaput --username $MEGAU --password $MEGAP $ZIPNAME
