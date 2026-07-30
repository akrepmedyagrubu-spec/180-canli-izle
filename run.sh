#!/bin/bash

mkdir -p hls

KV_INDEX=1

# HTTP server başlat (PUBLIC erişim)
python3 -m http.server 10000 &

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

  [0:v][6:v]scale2ref[logo0][v0];[v0][logo0]overlay=0:0[out0];
  [1:v][7:v]scale2ref[logo1][v1];[v1][logo1]overlay=0:0[out1];
  [2:v][6:v]scale2ref[logo2][v2];[v2][logo2]overlay=0:0[out2];
  [3:v][6:v]scale2ref[logo3][v3];[v3][logo3]overlay=0:0[out3];
  [4:v][6:v]scale2ref[logo4][v4];[v4][logo4]overlay=0:0[out4];
  [5:v][6:v]scale2ref[logo5][v5];[v5][logo5]overlay=0:0[out5];

  [out0][0:a]
  [out1][1:a]
  [out2][2:a]
  [out3][3:a]
  [out4][4:a]
  [out5][5:a]
  concat=n=6:v=1:a=1[v][a]
  " \
  -map "[v]" -map "[a]" \
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
