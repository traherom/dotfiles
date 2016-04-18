#!/bin/bash
DIR="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..")"
cd "$DIR"

echo Linking config files to $DIR

# Installs generic *nix stuff, then calls appropriate OS-specific scripts
echo Bash
rm -f ~/.profile
rm -f ~/.bashrc
echo "export DOTFILES_BASE=$DIR" >~/.dotfiles
ln -s "$DIR/bash_profile" ~/.profile
ln -s "$DIR/bashrc" ~/.bashrc
source "$DIR/bash_profile"

echo Screen
rm -f ~/.screenrc
ln -s "$DIR/screenrc" ~/.screenrc

echo i3
rm -fr ~/.i3
ln -s "$DIR/i3"  ~/.i3

echo VIM
sudo apt-get install -y exuberant-ctags || exit 1
rm -rf ~/.vim || exit 1
rm -f ~/.vimrc || exit 1
rm -f ~/.gvimrc || exit 1
mkdir -p ~/.vimundo || exit 1
ln -s "$DIR/vim" ~/.vim || exit 1 
ln -s "$DIR/vimrc" ~/.vimrc || exit 1
ln -s ~/.vimrc ~/.gvimrc || exit 1

echo Install VIM plugins...
vim -E -s <<-EOF
	:source ~/.vimrc
	:PlugInstall
	:PlugClean
	:qa
EOF

echo tmux
rm -f ~/.tmux.conf
ln -s "$DIR/tmux.conf" ~/.tmux.conf

echo EMACS
#rm -f ~/.spacemacs
#rm -rf ~/.emacs.d
#ln -s "$DIR/emacs.d" ~/.emacs.d
#ln -s "$DIR/spacemacs" ~/.spacemacs

echo Git
rm -f ~/.gitconfig
ln -s "$DIR/gitconfig" ~/.gitconfig

echo HG
rm -f ~/.hgrc
ln -s "$DIR/hgrc" ~/.hgrc

echo Making bin directory
mkdir -p ~/bin

echo runcron script
rm -f ~/bin/runcron.sh
ln -s "$DIR/runcron.sh" ~/bin/runcron.sh

echo Copying SSH config and keys
mkdir -p ~/.ssh
#cp laptop.priv ~/.ssh/id_rsa
#cp laptop.pub ~/.ssh/id_rsa.pub
#chmod 600 ~/.ssh/id_rsa
#chmod 611 ~/.ssh/id_rsa.pub
rm -f ~/.ssh/config
ln -s "$DIR/ssh_config" ~/.ssh/config
chmod 611 ~/.ssh/config

echo Doing OS-specific configuration
if [ $(uname) == "Darwin" ]
then
	./install_osx_conf.sh
else
	./install_linux_conf.sh
fi

