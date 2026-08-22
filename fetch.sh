#!/bin/bash

TOKEN="8854368089:AAGuSqO3TaPNTo1Ya6ojSf4YlNGQ71oiXM0"

FILE_ID=$1

FILE_PATH=$(curl -s "https://api.telegram.org/bot$TOKEN/getFile?file_id=$FILE_ID" \
| grep -o '"file_path":"[^"]*' | cut -d'"' -f4)

URL="https://api.telegram.org/file/bot$TOKEN/$FILE_PATH"

echo $URL

wget -O videos/video.mp4 "$URL"
