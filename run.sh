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

  [0:v]scale=1280:720,fps=25[v0];
  [1:v]scale=1280:720,fps=25[v1];
  [2:v]scale=1280:720,fps=25[v2];
  [3:v]scale=1280:720,fps=25[v3];
  [4:v]scale=1280:720,fps=25[v4];
  [5:v]scale=1280:720,fps=25[v5];

  [6:v]scale=1280:720[logo_main];
  [7:v]scale=1280:720[logo_reklam];

  [v0][logo_main]overlay=0:0[o0];
  [v1][logo_reklam]overlay=0:0[o1];
  [v2][logo_main]overlay=0:0[o2];
  [v3][logo_main]overlay=0:0[o3];
  [v4][logo_main]overlay=0:0[o4];
  [v5][logo_main]overlay=0:0[o5];

  [o0][o1][o2][o3][o4][o5]
  concat=n=6:v=1:a=0[v]
  " \
  -map "[v]" \
  -c:v libx264 -preset ultrafast -crf 28 \
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
