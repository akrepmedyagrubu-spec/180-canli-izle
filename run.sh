#!/bin/bash

cd /app || exit

mkdir -p hls

python3 -m http.server 10000 &

echo "DOSYALAR:"
ls -lh

echo "YAYIN BASLADI"

while true
do

while read VIDEO
do

echo "VIDEO: $VIDEO"

if [ ! -f "$VIDEO" ]; then
  echo "DOSYA YOK: $VIDEO"
  continue
fi

ffmpeg -re -i "$VIDEO" -i yayin_logo.png \
-filter_complex "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0" \
-map 0:a? \
-c:v libx264 -preset ultrafast -crf 28 \
-c:a aac -b:a 96k \
-f hls \
-hls_time 4 \
-hls_list_size 6 \
-hls_flags delete_segments \
hls/stream.m3u8

done < liste.txt

done
