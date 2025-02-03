#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $(id -u) -x polybar >/dev/null; do sleep 1; done

# Launch main bar
polybar main -c ~/.config/polybar/config.ini &
