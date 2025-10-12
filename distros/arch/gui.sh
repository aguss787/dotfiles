#!/bin/bash

set -e

# Show help message
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Install GUI environment with i3 window manager and related packages.

Options:
  --no-audio     Skip installation of audio packages (pulseaudio, pulseaudio-bluetooth, pavucontrol)
  --no-greeter   Skip installation of display manager (sddm)
  --help         Display this help message and exit
EOF
}

INSTALL_AUDIO=true
INSTALL_GREETER=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-audio)
            INSTALL_AUDIO=false
            shift
            ;;
        --no-greeter)
            INSTALL_GREETER=false
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Base packages
PACKAGES="i3-wm i3-bar i3status rofi \
    arandr autorandr \
    dex picom feh \
    pavucontrol playerctl \
    network-manager-applet \
    bluez bluez-utils blueman \
    screengrab \
    ghostty wezterm \
    firefox zen-browser-bin"

# Add greeter if not skipped
if [ "$INSTALL_GREETER" = true ]; then
    PACKAGES="sddm $PACKAGES"
fi

# Add audio packages if not skipped
if [ "$INSTALL_AUDIO" = true ]; then
    PACKAGES="$PACKAGES pulseaudio pulseaudio-bluetooth"
fi

yay -Syyu --noconfirm $PACKAGES

if [ "$INSTALL_GREETER" = true ]; then
    sudo systemctl enable sddm
fi
sudo systemctl enable --now bluetooth
