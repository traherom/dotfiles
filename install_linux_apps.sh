#!/usr/bin/env bash
# UPDATE
echo Updating...
sudo apt-get update
sudo apt-get dist-upgrade

# GNOME SHELL
sudo apt-get install gnome-shell gnome-themes-standard gnome-tweak-tool

# VIM
sudo apt-get install vim vim-gtk

# CHROME
echo Opening Chrome download...
sensible-browser http://www.google.com/chrome/intl/en/eula_dev.html?dl=unstable_amd64_deb >/dev/null 2>/dev/null &

echo Installing Chrome dependencies...
sudo apt-get install libnss3-1d libxss1 libcurl3

# Netbeans
echo Installing JRE...
sudo apt-get install default-jre 
echo Downloading Netbeans...
sensible-browser "http://netbeans.org/downloads/start.html?platform=linux&lang=en&option=cpp" >/dev/null 2>/dev/null &

# CONFIG FILES
echo Installing configuration files...
echo Screen
rm -f ~/.screenrc
ln -s ~/Dropbox/conf/.screenrc ~

echo Bash
rm -f ~/.bashrc
ln -s ~/Dropbox/conf/.bashrc ~

echo Ratpoison
rm -f ~/.ratpoisonrc
ln -s ~/Dropbox/conf/.ratpoisonrc ~

echo VIM
rm -f ~/.vimrc
ln -s ~/Dropbox/conf/.vimrc ~

echo Openbox
mkdir ~/.config >/dev/null 2>/dev/null
mkdir ~/.config/openbox >/dev/null 2>/dev/null
rm -f ~/.config/openbox/lubuntu-rc.xml
rm -f ~/.config/openbox/rc.xml
rm -f ~/.config/openbox/menu.xml
ln -s ~/Dropbox/conf/openboxrc.xml ~/.config/openbox/lubuntu-rc.xml
ln -s ~/Dropbox/conf/openboxrc.xml ~/.config/openbox/rc.xml
ln -s ~/Dropbox/conf/openboxmenu.xml ~/.config/openbox/menu.xml
openbox --restart

read -p "Install X profile? (y/N) " INSTALL_XPROFILE
if [ "$INSTALL_XPROFILE" == "y" ]; then
	rm ~/.xprofile
	ln -s ~/Dropbox/conf/.xprofile ~
	bash ~/.xprofile
fi
