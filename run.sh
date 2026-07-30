#!/bin/bash

mkdir -p hls

python3 -m http.server 10000 &

ffmpeg -re -stream_loop -1 -i rj1.mp4 \
-vf "scale=1280:720,format=yuv420p" \
-c:v libx264 -preset veryfast -crf 23 \
-c:a aac -b:a 128k \
-f hls \
-hls_time 6 \
-hls_list_size 10 \
-hls_flags delete_segments \
hls/stream.m3u8
