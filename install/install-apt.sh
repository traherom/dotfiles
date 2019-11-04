#!/bin/bash

# Ctags
if ! progExists ctags; then
  echo Installing exuberant-ctags
  smartInstall exuberant-ctags || exit 1
fi

# Fish
if ! progExists fish; then
  echo Install fish
  smartInstall fish || exit 1
fi

# Docker
"$DIR/install/install_docker.sh" || exit 1
