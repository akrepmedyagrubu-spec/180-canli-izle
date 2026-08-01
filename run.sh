#!/bin/bash

cd /app || exit

mkdir -p hls

python3 -m http.server 10000 &

echo "KESİNTİSİZ YAYIN BAŞLADI"

while true
do

ffmpeg -re -f concat -safe 0 -i liste.txt -i yayin_logo.png \
-filter_complex "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fps=25[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0" \
-map 0:a? \
-c:v libx264 -preset ultrafast -crf 28 \
-c:a aac -b:a 96k \
-f hls \
-hls_time 6 \
-hls_list_size 6 \
-hls_flags delete_segments+append_list \
hls/stream.m3u8

done
