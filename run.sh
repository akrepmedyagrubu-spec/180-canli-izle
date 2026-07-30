#!/bin/bash

mkdir -p hls temp

python3 -m http.server 10000 &

KV_INDEX=1

while true
do
  echo "KV$KV_INDEX oynuyor..."

  # tek tek encode + logo bas
  ffmpeg -y -i rj1.mp4 -i yayin_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/rj1.ts
  ffmpeg -y -i reklam.mp4 -i reklam_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/reklam.ts
  ffmpeg -y -i rj2.mp4 -i yayin_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/rj2.ts
  ffmpeg -y -i jenerik.mp4 -i yayin_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/jenerik.ts
  ffmpeg -y -i akilli.mp4 -i yayin_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/akilli.ts
  ffmpeg -y -i kv${KV_INDEX}.mp4 -i yayin_logo.png -filter_complex "[1:v]scale=1280:720[logo];[0:v]scale=1280:720[v];[v][logo]overlay=0:0" -c:v libx264 -c:a aac temp/kv.ts

  # playlist
  cat > list.txt <<EOL
file 'temp/rj1.ts'
file 'temp/reklam.ts'
file 'temp/rj2.ts'
file 'temp/jenerik.ts'
file 'temp/akilli.ts'
file 'temp/kv.ts'
EOL

  ffmpeg -re -f concat -safe 0 -i list.txt \
  -c copy \
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
