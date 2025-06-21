#!/bin/bash

set -e

# install yay
if ! [ -x "$(command -v yay)" ]; then
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

# upgrade and install packages
yay -Syyu --noconfirm \
    pambase polkit openssh cmake \
    zsh vi neovim less \
    npm yarn \
    luarocks unzip \
    fzf zoxide ripgrep \
    python3 python-pip \
    tmux htop fastfetch \
    noto-fonts-cjk noto-fonts-emoji noto-fonts-extra powerline powerline-fonts


