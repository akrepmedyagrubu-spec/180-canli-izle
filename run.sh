#!/bin/bash

mkdir -p hls

python3 -m http.server 10000 &

while true
do
  while read FILE
  do
    if [[ "$FILE" == *"reklam"* ]]; then
      LOGO="reklam_logo.png"
    else
      LOGO="yayin_logo.png"
    fi

    ffmpeg -re -i "$FILE" -i "$LOGO" \
    -filter_complex "[0:v]scale=960:540,pad=960:540:(ow-iw)/2:(oh-ih)/2[v0];[1:v][v0]overlay=0:0" \
    -c:v libx264 -preset ultrafast \
    -f hls -hls_time 4 -hls_list_size 6 \
    hls/stream.m3u8

  done < playlist.txt
done
