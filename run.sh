#!/bin/bash

mkdir -p hls

pkill -9 ffmpeg 2>/dev/null

python3 -m http.server 10000 &

echo "YAYIN BASLADI"

while true
do
  while read FILE
  do
    echo "Oynatiliyor: $FILE"

    if [[ "$FILE" == *"reklam"* ]]; then
      LOGO="reklam_logo.png"
    else
      LOGO="yayin_logo.png"
    fi

    ffmpeg -re -i "$FILE" -i "$LOGO" \
    -filter_complex "[0:v]scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2[v0];[1:v]scale=960:540[v1];[v0][v1]overlay=0:0[outv]" \
    -map "[outv]" -map 0:a? \
    -c:v libx264 -preset ultrafast -crf 28 \
    -c:a aac -b:a 96k \
    -f hls \
    -hls_time 4 \
    -hls_list_size 6 \
    -hls_flags delete_segments+append_list \
    -hls_segment_filename hls/segment_%03d.ts \
    hls/stream.m3u8

  done < playlist.txt
done
