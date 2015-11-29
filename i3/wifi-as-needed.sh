#!/bin/bash
# Start up nm-applet if there is a wireless card present
if [[ "`ifconfig | grep wlan`" != "" ]]; then
	nm-applet &
fi

