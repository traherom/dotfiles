#!/bin/sh
xrandr --output eDP-1 --mode 1920x1080 \
    --output DP-1 --mode 1920x1080 --same-as eDP-1 \
    --output DP-2 --off \
    --output HDMI-1 --off \
    --output HDMI-2 --off
