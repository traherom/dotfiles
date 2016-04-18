#!/bin/bash
DIR="$(pwd)"

echo Docker npm
docker run -it \
  -v "$DIR:/workingdir" \
  --workdir="/workingdir" \
  node:5 \
  npm "$@" \
  || exit 1

