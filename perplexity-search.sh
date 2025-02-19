#!/bin/bash
# Use a lock file to prevent re-entry
[ -f /tmp/perplexity_search.lock ] && exit
touch /tmp/perplexity_search.lock
trap "rm -f /tmp/perplexity_search.lock" EXIT

# Check the capslock state and press it again if required
sleep 0.1
caps_state=$(xset q | grep "Caps Lock:" | awk '{print $4}')
if [ "$caps_state" = "on" ]; then
    xdotool key Caps_Lock
    sleep 0.1  # Wait for toggle to complete
fi

query=$(zenity --entry --title "Perplexity Search" --text "Enter your search query:" --width=600)
if [ -n "$query" ]; then
    # Log the query with timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp | $query" >> ~/perplexity-queries.log
    
    queryUrlEncoded=$(echo -n "$query" | python3 -c 'from sys import stdin; from urllib.parse import quote; print(quote(stdin.read().strip()))')
    url="https://www.perplexity.ai/?q=$queryUrlEncoded"
    echo $url | xclip -selection clipboard
    xdg-open "$url" &
fi