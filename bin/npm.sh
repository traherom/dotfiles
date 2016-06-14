#!/bin/bash
DIR="$(pwd)"
docker run -it \
  -v "$DIR:/workingdir" \
  --workdir="/workingdir" \
  node:5 \
  npm "$@" \
  || exit 1

