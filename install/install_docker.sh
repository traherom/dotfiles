#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Curl, needed for installing docker
if ! progExists curl; then
  echo Installing curl
  smartInstall curl || exit 1
fi

# Docker?
if ! progExists docker; then
  echo Installing docker
  curl -fsSL https://test.docker.com/ | sh || exit 1
  sudo usermod -aG docker ${USER} || exit 1

  echo If the steps below fail, you may need to log in and back out to have
  echo the new user group \(docker\) applied.

  docker --version || exit 1
fi

echo "Docker installed"

