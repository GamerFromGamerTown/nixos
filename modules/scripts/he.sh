#!/run/current-system/sw/bin/bash
if ! command -v fzf &> /dev/null; then
  echo "fzf could not be found, please install it first."
  exit 1
fi

# Find files and trim the "/etc/nixos/modules/" prefix for display
SUBDIR=$(find /home/gaymer/.config/home-manager -type f | sed 's|/home/gaymer/.config/home-manager||' | fzf --prompt="Which file? ")

if [ -z "$SUBDIR" ]; then
  echo "No file selected."
  exit 1
fi

# Use the full path when opening the file
FULL_PATH="/home/gaymer/.config/home-manager/$SUBDIR"
nano "$FULL_PATH"
