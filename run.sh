#!/bin/bash

cd /app || exit

mkdir -p hls

python3 -m http.server 10000 &

echo "OTOMATİK YAYIN BAŞLADI"

while true
do

ffmpeg -re -stream_loop -1 -fflags +genpts -f concat -safe 0 -i liste.txt -i yayin_logo.png \
-filter_complex "[0:v]scale=1280:720,fps=25,format=yuv420p[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0" \
-map 0:a? \
-c:v libx264 -preset ultrafast -crf 28 -pix_fmt yuv420p \
-c:a aac -ar 44100 -ac 2 -b:a 96k \
-af "aresample=async=1" \
-f hls \
-hls_time 4 \
-hls_list_size 6 \
-hls_flags delete_segments+append_list+split_by_time \
hls/stream.m3u8

done
