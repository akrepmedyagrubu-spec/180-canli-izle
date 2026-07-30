#!/bin/bash

mkdir -p hls

python3 -m http.server 10000 &

KV_INDEX=1

while true
do
  echo "KV$KV_INDEX oynuyor..."

  for FILE in rj1.mp4 reklam.mp4 rj2.mp4 jenerik.mp4 akilli.mp4 kv${KV_INDEX}.mp4
  do
    echo "Oynatılıyor: $FILE"

    ffmpeg -re -i "$FILE" \
    -vf "scale=1280:720,format=yuv420p" \
    -c:v libx264 -preset veryfast -crf 23 \
    -c:a aac -b:a 128k \
    -f hls \
    -hls_time 6 \
    -hls_list_size 10 \
    -hls_flags delete_segments+append_list \
    hls/stream.m3u8
  done

  ((KV_INDEX++))

  if [ ! -f "kv${KV_INDEX}.mp4" ]; then
    KV_INDEX=1
  fi

done
