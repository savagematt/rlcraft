#!/bin/sh

set -e

LOCATION="$1"

ZIP=$(ls "/media/Provided/RLCraft"*.zip)

if [ ! -f "$ZIP" ]; then
    echo "RLCraft zip '$ZIP' does not exist"
    exit 1
fi

unzip "$ZIP" -d "$LOCATION"