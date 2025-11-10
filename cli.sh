#!/bin/sh

set -eu

BASE="https://raw.githubusercontent.com/ajinkya1806/LP-3/main"

echo "Select Category:"
echo "1) DAA CPP"
echo "2) DAA Python"
echo "3) ML"
read category

case $category in
  1) SUBJECT="DAA CPP" ;;
  2) SUBJECT="DAA Python" ;;
  3) SUBJECT="ML" ;;
  *) echo "Invalid option"; exit 1 ;;
esac

# Fetch file list from GitHub API
FILES=$(curl -s "https://api.github.com/repos/ajinkya1806/LP-3/contents/$SUBJECT" \
        | grep '"name"' | awk -F '"' '{print $4}')

echo "Files in $SUBJECT:"
i=1
for f in $FILES
do
    echo "$i) $f"
    i=$((i+1))
done

echo "Enter the number of the file you want to download:"
read num

choice=$(echo "$FILES" | sed -n "${num}p")

curl -s -O "$BASE/$SUBJECT/$choice"

echo "Downloaded '$choice' successfully."
