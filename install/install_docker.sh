#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Curl, needed for installing docker
if [[ "1"`which curl` == "1" ]]; then
  echo Installing curl
  sudo apt-get install -y curl || exit 1
fi

# Docker?
if [[ "1"`which docker` == "1" ]]; then
  echo Installing docker
  #sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D || exit 1
  #sudo su -c 'echo deb https://apt.dockerproject.org/repo ubuntu-wily main >/etc/apt/sources.list.d/docker.list' || exit 1
  #sudo apt-get update || exit 1
  #sudo apt-get install -y linux-image-extra-$(uname -r) || exit 1
  #sudo apt-get install -y docker-engine || exit 1
  #sudo service docker start || exit 1
  curl -fsSL https://test.docker.com/ | sh || exit 1
  sudo usermod -aG docker ${USER} || exit 1

  echo If the steps below fail, you may need to log in and back out to have
  echo the new user group \(docker\) applied.

  docker --version || exit 1
fi

echo "Docker installed"

