# Setup instructions for Ubuntu

1. Install required packages:
```bash
sudo apt install xbindkeys zenity xdotool
```

2. Copy the `perplexity-search.sh` script to some directory, e.g. `~/dev/capslock-rebind/perplexity-search.sh`

3. Make script executable:
```bash
chmod +x ~/dev/capslock-rebind/perplexity-search.sh
```

4. Create `~/.xbindkeysrc` and add these lines:
```
"~/dev/capslock-rebind/perplexity-search.sh"
  Caps_Lock
```

5. Start xbindkeys:
```bash
xbindkeys
```

6. Add xbindkeys to startup applications to persist across reboots:
```bash
mkdir -p ~/.config/autostart
echo -e "[Desktop Entry]\nType=Application\nName=XBindKeys\nExec=/usr/bin/xbindkeys\nComment=Key bindings for custom shortcuts" > ~/.config/autostart/xbindkeys.desktop
```

# Usage
Just press capslock! Capslock will no longer swap between upper/lower case (_except_ inside of a perplexity query popup dialog). Hit Enter and the query will be submitted in a new browser tab.

If you use something other than google chrome, just modify the script accordingly.