#!/bin/bash

set -e

yay -Syyu --noconfirm sddm \
    i3-wm i3-bar i3status rofi \
    arandr autorandr \
    dex picom feh \
    pulseaudio pulseaudio-bluetooth pavucontrol playerctl \
    network-manager-applet \
    bluez bluez-utils blueman \
    screengrab \
    ghostty wezterm \
    firefox zen-browser-bin

sudo systemctl enable sddm
sudo systemctl enable --now bluetooth
