#!/bin/sh

set -e

LOCATION="$1"

sed -i 's/spawnRadius=.*/spawnRadius=2000/g' "$LOCATION/config/globalgamerules.cfg"
# sed -i 's/keepInventory=.*/keepInventory=true/g' "$LOCATION/config/globalgamerules.cfg"
