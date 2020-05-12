#!/bin/sh

LOCATION="$(dirname "$0")"

# systemd does not exist in ubuntu docker images, so we need to start services ourselves
# see https://stackoverflow.com/a/61726595/1892116
service rsyslog start
service cron start

"$LOCATION"/refresh-player-whitelist.sh

# We need to cd into location to set the working directory because not everything in Java stdlib respects -Duser.dir
cd "$LOCATION" || exit 1

runForge() {
  ./run-forge.sh | tee rlcraft.log
}

runForge || true
while sleep 5; do
  runForge || true
done