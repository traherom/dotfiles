#!/bin/bash
DIR="$(pwd)"
docker run -it \
  -v "$DIR:/workingdir" \
  --workdir="/workingdir" \
  node:latest \
  npm "$@" \
  || exit 1

