#!/bin/sh
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# General config
xinput list --name-only | grep pad | xargs -n1 -INAME xinput set-prop 'NAME' 'libinput Tapping Enabled' 1

monitors=$(xrandr --listactivemonitors | head -n 1)
if [ "$monitors" = "Monitors: 2" ]; then
    echo "Two monitors"
    sh "$DIR/monitor-external-only.sh"
else
    echo $monitors
    sh "$DIR/monitor-laptop-only.sh"
fi

# Auto start programs
/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1 &
nm-applet &
# light-locker &
mate-screensaver &
mate-power-manager &

discord &
