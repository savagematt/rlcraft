#!/bin/sh

set -e

LOCATION="$1"

# Need to cd in, because eula.txt gets produced into working directory, instead of next to forge
cd "$LOCATION" || exit 1

echo "Running server for first time- we expect this to fail with 'You need to agree to the EULA in order to run the server. Go to eula.txt for more info'"
./run-forge.sh

cat eula.txt

echo "Accepting EULA"
sed -i 's/eula=false/eula=true/g' eula.txt

cat eula.txt
