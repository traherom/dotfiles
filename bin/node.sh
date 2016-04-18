#!/bin/bash
DIR="$(pwd)"
docker run -it \
  -v "$DIR:/workingdir" \
  --workdir="/workingdir" \
  node:5 \
  node "$@" \
  || exit 1

