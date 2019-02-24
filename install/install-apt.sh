#!/bin/bash
# Python 3
if ! progExists python3; then
  echo "Install installing Python 3"
  sudo apt-get install -y python3 python3-pip || exit 1
fi

# Ctags
if ! progExists ctags; then
  echo Installing exuberant-ctags
  sudo apt-get install -y exuberant-ctags || exit 1
fi

# Fish
if ! progExists fish; then
  echo Install fish
  sudo apt install -y fish || exit 1
fi

# Docker
"$DIR/install/install_docker.sh" || exit 1
