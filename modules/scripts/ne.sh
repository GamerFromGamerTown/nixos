#!/run/current-system/sw/bin/bash
if ! command -v fzf &> /dev/null; then
  echo "fzf could not be found, please install it first."
  exit 1
fi

# Find files and trim the "/etc/nixos/modules/" prefix for display
SUBDIR=$(find /etc/nixos/modules -type f | sed 's|/etc/nixos/modules/||' | fzf --prompt="Which file? ")

if [ -z "$SUBDIR" ]; then
  echo "No file selected."
  exit 1
fi

# Use the full path when opening the file
FULL_PATH="/etc/nixos/modules/$SUBDIR"
doas nano "$FULL_PATH"
