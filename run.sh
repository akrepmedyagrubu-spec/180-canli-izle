#!/bin/bash

echo "Dizin ayarlanıyor..."
cd /app

echo "Dosyalar:"
ls -lh

echo "LFS çekiliyor..."
git lfs pull

echo "Tekrar liste:"
ls -lh

mkdir -p hls

python3 -m http.server 10000 &

echo "Yayın başladı..."

while true
do
  while read FILE
  do
    echo "Oynatılıyor: $FILE"

    if [ ! -f "$FILE" ]; then
      echo "HATA: $FILE bulunamadı!"
      continue
    fi

    ffmpeg -re -i "$FILE" -i "yayin_logo.png" \
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
