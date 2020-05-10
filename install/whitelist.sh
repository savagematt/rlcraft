#!/bin/sh

set -e

LOCATION="$(dirname "$0")"

cd "$LOCATION" || exit 1
SHEET_ID="$(cat /media/Config/whitelist.txt)"

if [ -z "$SHEET_ID" ]
then
  echo "No sheet id found in /media/Config/whitelist.txt"
  exit 1
fi

curl -f "https://docs.google.com/spreadsheets/d/$SHEET_ID/gviz/tq?tqx=out:csv&sheet={players}" > whitelist.csv

echo "[" > whitelist.json
awk -F',' '{printf "{\"name\":%s, \"uuid\":%s},\r\n",$1,$2;}' whitelist.csv | sed '$ s/\(.*\),/\1/' >> whitelist.json
echo "]" >> whitelist.json