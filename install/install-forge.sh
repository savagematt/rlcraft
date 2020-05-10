#!/bin/sh

set -e

LOCATION="$1"

JAR=$(ls "/media/Provided/forge"*-installer.jar)

if [ ! -f "$JAR" ]; then
    echo "Forge installer jar '$JAR' does not exist"
    exit 1
fi

java -jar "$JAR" --installServer "$LOCATION"

