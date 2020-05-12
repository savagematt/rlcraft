#!/bin/sh

set -e

LOCATION="$(dirname "$0")"

# We need to cd into location to set the working directory for Java
cd "$LOCATION" || exit 1

JAR=$(ls forge*.jar)

if [ ! -f "$JAR" ]; then
    echo "Forge jar '$JAR' does not exist"
    exit 1
fi

echo "Running forge from $JAR"

# Use 80% of free RAM (this could probably be higher?)

FREE_RAM=$(free|awk '/^Mem:/{print $4}')
SERVER_RAM=$(( FREE_RAM * 80/100 ))

./refresh-player-whitelist.sh

# JVM args from https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
#   The JVM arg example is for paperclip (speed-optimised MC server), so some of the options probably don't work
#   in Forge- this is just a lazy copy pasta
java "-Xms${SERVER_RAM}k" "-Xmx${SERVER_RAM}k" -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar "$JAR" nogui
