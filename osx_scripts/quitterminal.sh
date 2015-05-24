#!/bin/bash
# Kills Terminal.app on OSX. Intended for use with the alias:
#	alias exit='~/bin/quitterminal.sh; exit'
# Add bash and osascript to the list of programs that Terminal is allowed to kill silently
bashes=`ps -ax | grep '\-bash' | wc -l`
if [[ "$bashes" -le "2" ]]
then
	osascript -e 'tell application "Terminal" to quit'
fi
