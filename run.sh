#!/bin/bash

cd /app || exit

mkdir -p hls

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
-filter_complex "
[0:v]scale=1280:720,fps=25,format=yuv420p[v0];[0:a]aresample=44100[a0];
[1:v]scale=1280:720,fps=25,format=yuv420p[v1];[1:a]aresample=44100[a1];
[2:v]scale=1280:720,fps=25,format=yuv420p[v2];[2:a]aresample=44100[a2];
[3:v]scale=1280:720,fps=25,format=yuv420p[v3];[3:a]aresample=44100[a3];
[4:v]scale=1280:720,fps=25,format=yuv420p[v4];[4:a]aresample=44100[a4];
[5:v]scale=1280:720,fps=25,format=yuv420p[v5];[5:a]aresample=44100[a5];
[6:v]scale=1280:720,fps=25,format=yuv420p[v6];[6:a]aresample=44100[a6];
[7:v]scale=1280:720,fps=25,format=yuv420p[v7];[7:a]aresample=44100[a7];
[v0][a0][v1][a1][v2][a2][v3][a3][v4][a4][v5][a5][v6][a6][v7][a7]concat=n=8:v=1:a=1[outv][outa]
" \
-map "[outv]" -map "[outa]" \
-c:v libx264 -preset ultrafast -crf 28 \
-c:a aac -b:a 128k \
-f hls \
-hls_time 4 \
-hls_list_size 6 \
-hls_flags delete_segments \
hls/stream.m3u8

echo "FFMPEG yeniden baslatiliyor..."

done
