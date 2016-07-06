#!/bin/bash
# Every 30 minutes notify on power level no matter what
noticeCount=10000

while true; do
  per=$(upower -e | grep battery | xargs upower -i | grep percentage | sed -rn 's/^.*percentage:[^0-9]*([0-9]+)%$/\1/p')

  # Critical warnings
  if (( $per < 15 )); then
    notify-send -u critical "Battery Critical" "Battery is at $per%"
  elif (( $per < 30 )); then
    notify-send -u normal "Battery Getting Low" "Battery is at $per%, find a cord"
  fi

  ((noticeCount++))
  if (( noticeCount > 6 )); then
    notify-send -u low "Battery: $per%"
    noticeCount=0
  fi

  sleep 300
done
