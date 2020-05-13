#!/bin/bash

set -e

LOCATION="$1"

sed -i 's/spawnRadius=.*/spawnRadius=5000/g' "$LOCATION/config/globalgamerules.cfg"
# sed -i 's/keepInventory=.*/keepInventory=true/g' "$LOCATION/config/globalgamerules.cfg"
