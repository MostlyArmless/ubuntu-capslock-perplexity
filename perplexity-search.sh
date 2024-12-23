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
    queryUrlEncoded=$(echo -n "$query" | python3 -c 'from sys import stdin; from urllib.parse import quote; print(quote(stdin.read().strip()))')
    echo "https://www.perplexity.ai/?q=$queryUrlEncoded" | xclip -selection clipboard

    # Get the current desktop number
    current_desktop=$(xdotool get_desktop)
    
    # Find windows of the OS's default browser, only on the current desktop
    browser_name=$(xdg-settings get default-web-browser | sed 's/.desktop//')
    browser_window=$(xdotool search --desktop $current_desktop --class $browser_name | head -n1)
    
    if [ -n "$browser_window" ]; then
        # Activate the found window
        xdotool windowactivate $browser_window
        sleep 0.1  # Small delay to ensure window activation
        xdotool key ctrl+t
        sleep 0.1  # Small delay to ensure new tab is ready
        xdotool key ctrl+v
        xdotool key Return
    else
        # If no browser window found on current desktop, start a new one
        $browser_name "https://www.perplexity.ai/?q=$queryUrlEncoded" &
    fi
fi