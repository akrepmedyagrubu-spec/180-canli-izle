#!/bin/bash

cd /app || exit

mkdir -p hls

# web server
python3 -m http.server 10000 &

echo "YAYIN BASLADI"

while true
do

ffmpeg -re \
-i rj1.mp4 \
-i reklam.mp4 \
-i rj2.mp4 \
-i jenerik.mp4 \
-i akilli.mp4 \
-i panasonicsunar.mp4 \
-i kv1.mp4 \
-i panasonicsundu.mp4 \
-filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a][4:v][4:a][5:v][5:a][6:v][6:a][7:v][7:a]concat=n=8:v=1:a=1[outv][outa]" \
-map "[outv]" -map "[outa]" \
-c:v libx264 -preset ultrafast -crf 28 \
-vf "scale=1280:720,fps=25" \
-c:a aac -b:a 128k -ar 44100 -ac 2 \
-f hls \
-hls_time 4 \
-hls_list_size 6 \
-hls_flags delete_segments+append_list \
hls/stream.m3u8

echo "FFMPEG yeniden baslatiliyor..."

done
