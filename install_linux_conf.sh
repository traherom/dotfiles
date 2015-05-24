#!/usr/bin/env bash
echo Ratpoison
rm -f ~/.ratpoisonrc
ln -s "$(pwd)/ratpoisonrc" ~/.ratpoisonrc

echo Openbox
mkdir ~/.config >/dev/null 2>/dev/null
mkdir ~/.config/openbox >/dev/null 2>/dev/null
rm -f ~/.config/openbox/lubuntu-rc.xml
rm -f ~/.config/openbox/rc.xml
rm -f ~/.config/openbox/menu.xml
ln -s "$(pwd)/openboxrc.xml" ~/.config/openbox/rc.xml
ln -s ~/.config/openbox/rc.xml ~/.config/openbox/lubuntu-rc.xml
ln -s "$(pwd)/openboxmenu.xml" ~/.config/openbox/menu.xml
openbox --restart 2>/dev/null

