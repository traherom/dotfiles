#!/usr/bin/fish
if test -z "$LAPTOP_DISPLAY_CONF"
    echo Setting default config for laptop
    set LAPTOP_DISPLAY_CONF "eDP-1, preferred, auto, 1.33333"
end

while true
    echo Checking

    set externalMonitor (hyprctl monitors | grep "Monitor DP-")
    set libClosed (grep closed /proc/acpi/button/lid/LID0/state)

    if test -n "$externalMonitor"
        echo Using only external monitor
        hyprctl keyword monitor "eDP-1, disable"
    else
        echo Enabling laptop monitor
        hyprctl keyword monitor "$LAPTOP_DISPLAY_CONF"
    end

    if test -z "$externalMonitor" && test -n "$libClosed"
        echo Lid closed and external monitor not connected, suspending
        systemctl suspend
    end

    sleep 10
end
