#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"
echo Linking config files to $(pwd)

# Installs generic *nix stuff, then calls appropriate OS-specific scripts
echo Screen
rm -f ~/.screenrc
ln -s "$(pwd)/screenrc" ~/.screenrc

echo Bash
rm -f ~/.profile
rm -f ~/.bashrc
ln -s "$(pwd)/bash_profile" ~/.profile
ln -s "$(pwd)/bashrc" ~/.bashrc

echo i3
rm -fr ~/.i3
ln -s "$(pwd)/i3"  ~/.i3

echo VIM
rm -f ~/.vim
rm -f ~/.vimrc
rm -f ~/.gvimrc
ln -s "$(pwd)/vim" ~/.vim
ln -s "$(pwd)/vimrc" ~/.vimrc
ln -s ~/.vimrc ~/.gvimrc
vim -E -s <<-EOF
	:source ~/.vimrc
	:PlugInstall
	:PlugClean
	:qa
EOF

echo EMACS
rm -f ~/.spacemacs
rm -rf ~/.emacs.d
ln -s "$(pwd)/emacs.d" ~/.emacs.d
ln -s "$(pwd)/spacemacs" ~/.spacemacs

echo Git
rm -f ~/.gitconfig
ln -s "$(pwd)/gitconfig" ~/.gitconfig

echo Making bin directory
mkdir -p ~/bin

echo Copying SSH config and keys
mkdir -p ~/.ssh
#cp laptop.priv ~/.ssh/id_rsa
#cp laptop.pub ~/.ssh/id_rsa.pub
#chmod 600 ~/.ssh/id_rsa
#chmod 611 ~/.ssh/id_rsa.pub
rm -f ~/.ssh/config
ln -s "$(pwd)/ssh_config" ~/.ssh/config
chmod 611 ~/.ssh/config

echo Doing OS-specific configuration
if [ $(uname) == "Darwin" ]
then
	./install_osx_conf.sh
else
	./install_linux_conf.sh
fi

