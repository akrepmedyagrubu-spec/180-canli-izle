#!/bin/bash

TOKEN="8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0"

mkdir -p videos

cat db.json | jq -c '.[]' | while read item
do
  FILE_ID=$(echo $item | jq -r '.file_id')
  CAPTION=$(echo $item | jq -r '.caption')

  FILE_PATH=$(curl -s "https://api.telegram.org/bot$TOKEN/getFile?file_id=$FILE_ID" \
  | grep -o '"file_path":"[^"]*' | cut -d'"' -f4)

  URL="https://api.telegram.org/file/bot$TOKEN/$FILE_PATH"

  NAME="videos/${FILE_ID}.mp4"

  echo "indiriliyor: $NAME"
  wget -q -O "$NAME" "$URL"
done
