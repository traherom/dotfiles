#!/bin/bash
# General config
xinput list --name-only | grep pad | xargs -n1 -INAME xinput set-prop 'NAME' 'libinput Tapping Enabled' 1

# Auto start programs
/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1 &
nm-applet &
# light-locker &
mate-screensaver &
mate-power-manager &
