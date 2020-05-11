#!/bin/sh

LOCATION="$(dirname "$0")"

# Hack until https://stackoverflow.com/questions/61721828/etc-rc-not-running-on-ubuntu-18-04-in-docker-cannot-start-cron-on-boot
service rsyslog start
service cron start

# We need to cd into location to set the working directory because not everything in Java stdlib respects -Duser.dir
cd "$LOCATION" || exit 1

runForge() {
  ./run-forge.sh | tee rlcraft.log
}

runForge || true
while sleep 5; do
  runForge || true
done