#!/bin/bash
# Use a lock file to prevent re-entry (otherwise the `xdotool key Caps_Lock` below would open a duplicate query popup)
# This also means you can use capslock normally within the query popup dialog
[ -f /tmp/perplexity_search.lock ] && exit
touch /tmp/perplexity_search.lock
trap "rm -f /tmp/perplexity_search.lock" EXIT # Delete the lockfile when this script exits, successfully or otherwise.

# Check the capslock state and press it again if required to make sure we're using lowercase before popping the dialog
sleep 0.1
caps_state=$(xset q | grep "Caps Lock:" | awk '{print $4}')
if [ "$caps_state" = "on" ]; then
    xdotool key Caps_Lock
    sleep 0.1  # Wait for toggle to complete
fi

query=$(zenity --entry --title "Perplexity Search" --text "Enter your search query:" --width=600)
if [ -n "$query" ]; then
  queryUrlEncoded=$(echo -n "$query" | python3 -c 'from sys import stdin; from urllib.parse import quote; print(quote(stdin.read().strip()))')
  echo "https://www.perplexity.ai/?q=$queryUrlEncoded" | xclip -selection clipboard
  xdotool search --onlyvisible --class "google-chrome" windowactivate
  xdotool key ctrl+t
  xdotool key ctrl+v
  xdotool key Return
fi