#!/bin/bash

mkdir -p hls

python3 -m http.server 10000 &

echo "Yayın başladı..."

while true
do
  while read FILE
  do
    echo "Oynatılıyor: $FILE"

    BASENAME=$(basename "$FILE")

    # LOGO SEÇİMİ
    if [[ "$BASENAME" == "reklam.mp4" ]]; then
      LOGO="reklam_logo.png"
    else
      LOGO="yayin_logo.png"
    fi

    echo "Logo: $LOGO"

    ffmpeg -re -i "$FILE" -i "$LOGO" \
    -filter_complex "[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fps=25[v];[1:v]scale=1280:720[l];[v][l]overlay=0:0" \
    -map 0:a? \
    -c:v libx264 -preset ultrafast -crf 28 \
    -c:a aac -b:a 96k \
    -f hls \
    -hls_time 6 \
    -hls_list_size 6 \
    -hls_flags delete_segments+append_list \
    hls/stream.m3u8

  done < playlist.txt

done
