
#!/usr/bin/env bash

set -euo pipefail

INPUT_FILE="flatpak_apps.txt"

# Ensure flatpak is installed
if ! command -v flatpak >/dev/null 2>&1; then
    echo "Error: flatpak is not installed."
    exit 1
fi

# Ensure file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: $INPUT_FILE not found."
    exit 1
fi

echo "Starting Flatpak installation from $INPUT_FILE..."
echo

# Read file line-by-line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim whitespace
    pkg="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    # Skip empty lines or comments
    if [[ -z "$pkg" || "$pkg" =~ ^# ]]; then
        continue
    fi

    echo "Installing: $pkg"

    if flatpak install -y flathub "$pkg"; then
        echo "✔ Successfully installed: $pkg"
    else
        echo "✖ Failed to install: $pkg"
    fi

    echo
done < "$INPUT_FILE"

echo "All done."
