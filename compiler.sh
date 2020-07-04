#! /usr/bin/env bash

#wget -c  "http://s1.dlserver.info/Movie/The.Matrix.Reloaded.2003/The.Matrix.2.2003.Bluray%20720p.mkv"
#unzip *.zip
sudo apt install p7zip-full megatools ffmpeg libavcodec-extra -y

megadl "https://mega.nz/#!5yh2wCCI!9QhXF2Y2mwgPYtznIQALWUXXL_-wXr7PgBSjr958Z-0"
mv Cap* capcivilwar.mp4
ffmpeg -i capcivilwar.mp4 -vf scale=-1:360 triangle360.mp4
#mkdir capcivilwar
#mv capcivilwar480.mp4 triangle
#7z a capcivilwar.7z triangle
megaput --username $MEGAU --password $MEGAP capcivilwar360.mp4
