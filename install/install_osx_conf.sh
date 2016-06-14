#!/bin/bash
echo Disabling boot sound
sudo ln -s ~/Dropbox/conf/osx_scripts/mute.sh /Library/Scripts
sudo ln -s ~/Dropbox/conf/osx_scripts/unmute.sh /Library/Scripts
sudo defaults write com.apple.loginwindow LogoutHook /Library/Scripts/mute.sh
sudo defaults write com.apple.loginwindow LoginHook /Library/Scripts/unmute.sh

echo Making default save location local
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo Disabling Dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES
killall Dock

echo Disabling safe sleep
sudo pmset hibernatemode 0
sudo rm -f /var/vm/sleepimage

echo Disabling accent popup menu
sudo defaults write -g ApplePressAndHoldEnabled -bool false

echo Creating locate database
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

echo Installing and configuring homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew doctor
brew update

echo Install brew-specific python
brew install python
brew link --overwrite python

echo Installing python3
brew install python3

echo Installing MacVim
brew install macvim

echo Linking brew apps
brew linkapps
