#!/bin/bash

echo "=== BAŞLAT ==="

cd /app || exit

echo "=== BAŞLANGIÇ DOSYALAR ==="
ls -lh

echo "=== GIT LFS INIT ==="
git lfs install

echo "=== GIT LFS PULL ==="
git lfs pull

echo "=== LFS SONRASI DOSYALAR ==="
ls -lh

mkdir -p hls

echo "=== HTTP SERVER ==="
python3 -m http.server 10000 &

echo "=== YAYIN BAŞLADI ==="

while true
do
  while IFS= read -r FILE
  do
    [ -z "$FILE" ] && continue

    echo "Oynatılıyor: $FILE"

    if [ ! -f "$FILE" ]; then
      echo "❌ YOK: $FILE"
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
