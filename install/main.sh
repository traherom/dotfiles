#!/bin/bash
DIR="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..")"
cd "$DIR"

progExists() {
  command -v "$1" >/dev/null 2>&1
}

smartLink() {
  src="$DIR/$1"
  dest="$HOME/$2"

  if [ ! -e "$src" ]; then
    echo "$src does not exist but a link to it was requested"
    exit 2
  fi

  parent="$(dirname "$dest")"
  if [ ! -e "$parent" ]; then
    echo Creating "$parent"
    mkdir -p "$parent" || exit 1
  fi

  echo "Linking $dest"
  rm -rf "$dest" || exit 1
  ln -s "$src" "$dest" || exit 1
}

# Installation of programs
# Gnome-shell and native extension
if ! progExists gnome-tweak-tool; then
  echo "Install gnome-shell"
  sudo add-apt-repository ppa:ne0sight/chrome-gnome-shell || exit 1
  sudo apt-get update || exit 1
  sudo apt-get install -y chrome-gnome-shell gnome-tweak-tool || exit 1
fi

# Python 3
#if ! command -v python3 >/dev/null 2>&1; then
if ! progExists python3; then
  echo "Install installing Python 3"
  sudo apt-get install -y python3 python3-pip || exit 1
fi

if ! progExists virtualenvwrapper.sh; then
  echo "Installing virtualenvwrapper"
  pip3 install virtualenvwrapper
fi

# Ctags
if ! progExists ctags; then
  echo Installing exuberant-ctags
  sudo apt-get install -y exuberant-ctags || exit 1
fi

# Docker
"$DIR/install/install_docker.sh" || exit 1

# Basic home directory structure
echo Making bin directory
mkdir -p "$HOME/bin"

# Config files
echo Bash
echo "export DOTFILES_BASE=$DIR" >~/.dotfiles
smartLink bash_profile .profile
smartLink bash_profile .bash_profile
smartLink bashrc .bashrc
source "$DIR/bash_profile"

echo Screen
smartLink screenrc .screenrc

echo i3
smartLink i3 i3

echo Ratpoison
smartLink ratpoisonrc .ratpoisonrc

echo Openbox
smartLink openbox .config/openbox

echo VIM
mkdir -p ~/.vimundo || exit 1
smartLink vim .vim
smartLink vimrc .vimrc
smartLink vimrc .gvimrc

echo Install VIM plugins...
vim -E -s <<-EOF
	:source ~/.vimrc
	:PlugInstall
	:PlugClean
  :PlugUpgrade
	:qa
EOF

echo tmux
smartLink tmux.conf .tmux.conf

echo Git
smartLink gitconfig .gitconfig

echo HG
smartLink hgrc .hgrc

echo SSH
smartLink ssh_config .ssh/config
chmod 611 "$HOME/.ssh/config"


# Ensure we can find anything we just installed
sudo updatedb
