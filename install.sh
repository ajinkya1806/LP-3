#!/bin/sh
set -eu

TMP=/tmp/lp3-cli.sh

curl -sSL "https://raw.githubusercontent.com/ajinkya1806/LP-3/main/cli.sh" -o "$TMP"
chmod +x "$TMP"
sh "$TMP"
