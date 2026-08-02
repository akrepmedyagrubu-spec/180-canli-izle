#!/bin/bash

cd /app || exit

mkdir -p hls

# eski ffmpeg kalmışsa öldür
pkill -9 ffmpeg 2>/dev/null

# web server
python3 -m http.server 10000 &

echo "YAYIN BASLADI"

KV_INDEX=1

while true
do
  for FILE in rj1.mp4 reklam.mp4 rj2.mp4 jenerik.mp4 akilli.mp4 kv${KV_INDEX}.mp4
  do
    echo "Oynatiliyor: $FILE"

    # logo seçimi
    if [[ "$FILE" == "reklam.mp4" ]]; then
      LOGO="reklam_logo.png"
    else
      LOGO="yayin_logo.png"
    fi

    ffmpeg -re -i "$FILE" -i "$LOGO" \
    -filter_complex "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fps=25,format=yuv420p[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0[outv]" \
    -map "[outv]" -map 0:a? \
    -c:v libx264 -preset ultrafast -crf 28 \
    -c:a aac -b:a 96k -ar 44100 -ac 2 \
    -f hls \
    -hls_time 4 \
    -hls_list_size 6 \
    -hls_flags delete_segments+append_list \
    hls/stream.m3u8

  done

  # KV sıradaki bölüm
  ((KV_INDEX++))

  if [ ! -f "kv${KV_INDEX}.mp4" ]; then
    KV_INDEX=1
  fi

done
