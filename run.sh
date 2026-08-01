#!/bin/bash

cd /app || exit

mkdir -p hls

python3 -m http.server 10000 &

echo "YAYIN BAŞLADI"

while true
do

ffmpeg -re -fflags +genpts -f concat -safe 0 -i liste.txt -i yayin_logo.png \
-filter_complex "[0:v]fps=25,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0" \
-map 0:a? \
-vsync 1 \
-c:v libx264 -preset ultrafast -tune zerolatency -crf 28 \
-c:a aac -b:a 96k \
-f hls \
-hls_time 4 \
-hls_list_size 6 \
-hls_flags delete_segments+append_list+split_by_time \
hls/stream.m3u8

done
