#!/bin/bash

mkdir -p hls

python3 -m http.server 10000 &

KV_INDEX=1

while true
do
  echo "KV$KV_INDEX oynuyor..."

  ffmpeg -re \
  -i rj1.mp4 \
  -i reklam.mp4 \
  -i rj2.mp4 \
  -i jenerik.mp4 \
  -i akilli.mp4 \
  -i kv${KV_INDEX}.mp4 \
  -i yayin_logo.png \
  -i reklam_logo.png \
  -filter_complex "

  [0:v][6:v]overlay=0:0[v0];
  [1:v][7:v]overlay=0:0[v1];
  [2:v][6:v]overlay=0:0[v2];
  [3:v][6:v]overlay=0:0[v3];
  [4:v][6:v]overlay=0:0[v4];
  [5:v][6:v]overlay=0:0[v5];

  [v0][0:a]
  [v1][1:a]
  [v2][2:a]
  [v3][3:a]
  [v4][4:a]
  [v5][5:a]
  concat=n=6:v=1:a=1[v][a]
  " \
  -map "[v]" -map "[a]" \
  -vf "scale=1280:720,format=yuv420p" \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac -b:a 128k \
  -f hls \
  -hls_time 6 \
  -hls_list_size 10 \
  -hls_flags delete_segments \
  hls/stream.m3u8

  ((KV_INDEX++))

  if [ ! -f "kv${KV_INDEX}.mp4" ]; then
    KV_INDEX=1
  fi

done
