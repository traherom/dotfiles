#!/bin/bash
DIR="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..")"
cd "$DIR"

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
if [[ "1"`which ctags` == "1" ]]; then
  echo Installing exuberant-ctags
  sudo apt-get install -y exuberant-ctags || exit 1
fi

"$DIR/install/install_docker.sh" || exit 1


echo Making bin directory
mkdir -p "$HOME/bin"

# Config files
echo Bash
echo "export DOTFILES_BASE=$DIR" >~/.dotfiles
smartLink bash_profile .profile
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

