#!/bin/sh

LOCATION="$(dirname "$0")"

# We need to cd into location to set the working directory for Java
cd "$LOCATION" || exit 1

runForge() {
  ./run-forge.sh | tee rlcraft.log
}

while sleep 5; do
  runForge || true
done