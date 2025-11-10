#!/bin/sh
set -eu

BASE_RAW="https://raw.githubusercontent.com/ajinkya1806/LP-3/main"
BASE_API="https://api.github.com/repos/ajinkya1806/LP-3/contents"

echo "Select Category:"
echo "1) DAA CPP"
echo "2) DAA Python"
echo "3) ML"
read category

case "$category" in
  1) FOLDER="DAA CPP" ;;
  2) FOLDER="DAA Python" ;;
  3) FOLDER="ML" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Encode spaces for API URL
ENC_FOLDER=$(echo "$FOLDER" | sed 's/ /%20/g')

API_URL="$BASE_API/$ENC_FOLDER"

# Fetch items and filter only files
FILES=$(curl -s "$API_URL" | grep '"type": "file"' -B1 | grep '"name"' | awk -F '"' '{print $4}')

if [ -z "$FILES" ]; then
  echo "No files found in this folder."
  exit 1
fi

echo "Files in $FOLDER:"
i=1
for f in $FILES; do
  echo "$i) $f"
  i=$((i+1))
done

echo "Enter the number of the file you want to download:"
read num

choice=$(echo "$FILES" | sed -n "${num}p")

# RAW download URL
RAW_URL="$BASE_RAW/$FOLDER/$choice"

# Replace spaces for raw URL
RAW_URL=$(echo "$RAW_URL" | sed 's/ /%20/g')

curl -s -O "$RAW_URL"

echo "Downloaded '$choice' successfully."
