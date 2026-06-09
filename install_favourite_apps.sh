#!/bin/bash

# Define the file containing the list of apps
APPS_FILE="favourite_apps.txt"

# Check if the app list file exists
if [ ! -f "$APPS_FILE" ]; then
    echo "Error: $APPS_FILE not found!"
    exit 1
fi

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Error: Cannot detect Linux distribution."
    exit 1
fi

# Initialize an empty list for missing apps
MISSING_APPS=()

# Function to check and install apps on Debian/Ubuntu
install_debian() {
    echo "Detected Debian/Ubuntu system. Updating package list..."
    sudo apt-get update -y

    while IFS= read -r app || [ -n "$app" ]; do
        [[ -z "$app" || "$app" =~ ^# ]] && continue
        
        # Check if the package exists in the repository first
        if ! apt-cache show "$app" >/dev/null 2>&1; then
            continue
        fi

        # Check if it is already installed
        if dpkg -s "$app" >/dev/null 2>&1; then
            echo "-> $app is already installed. Skipping."
        else
            MISSING_APPS+=("$app")
        fi
    done < "$APPS_FILE"

    # Install all missing apps at once
    if [ ${#MISSING_APPS[@]} -gt 0 ]; then
        echo "Installing missing apps: ${MISSING_APPS[*]}"
        sudo apt-get install -y "${MISSING_APPS[@]}"
    else
        echo "All packages are already installed!"
    fi
}

# Function to check and install apps on Fedora
install_fedora() {
    echo "Detected Fedora system..."

    while IFS= read -r app || [ -n "$app" ]; do
        [[ -z "$app" || "$app" =~ ^# ]] && continue

        # Check if the package or group exists
        if ! dnf list "$app" >/dev/null 2>&1 && ! dnf group info "$app" >/dev/null 2>&1; then
            continue
        fi

        # Check if it is already installed
        if rpm -q "$app" >/dev/null 2>&1 || dnf group list installed "$app" >/dev/null 2>&1; then
            echo "-> $app is already installed. Skipping."
        else
            MISSING_APPS+=("$app")
        fi
    done < "$APPS_FILE"

    if [ ${#MISSING_APPS[@]} -gt 0 ]; then
        echo "Installing missing apps: ${MISSING_APPS[*]}"
        sudo dnf install -y "${MISSING_APPS[@]}"
    else
        echo "All packages are already installed!"
    fi
}

# Function to check and install apps on Arch Linux
install_arch() {
    echo "Detected Arch Linux system. Updating package databases..."
    sudo pacman -Sy --noconfirm

    while IFS= read -r app || [ -n "$app" ]; do
        [[ -z "$app" || "$app" =~ ^# ]] && continue

        # Check if the package or group exists
        if ! pacman -Si "$app" >/dev/null 2>&1 && ! pacman -Sg "$app" >/dev/null 2>&1; then
            continue
        fi

        # Check if it is already installed
        if pacman -Qi "$app" >/dev/null 2>&1 || pacman -Qg "$app" >/dev/null 2>&1; then
            echo "-> $app is already installed. Skipping."
        else
            MISSING_APPS+=("$app")
        fi
    done < "$APPS_FILE"

    if [ ${#MISSING_APPS[@]} -gt 0 ]; then
        echo "Installing missing apps: ${MISSING_APPS[*]}"
        sudo pacman -S --noconfirm "${MISSING_APPS[@]}"
    else
        echo "All packages are already installed!"
    fi
}

# Run the correct function based on the detected OS
case "$OS" in
    ubuntu|debian|pop|mint)
        install_debian
        ;;
    fedora|rhel|centos)
        install_fedora
        ;;
    arch|manjaro|CachyOS Linux)
        install_arch
        ;;
    *)
        echo "Unsupported distribution: $OS"
        exit 1
        ;;
esac

echo "Done!"
