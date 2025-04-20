#!/bin/bash

# install yay
if ! [ -x $(command -v yay) ]; then
  sudo pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ..
  rm -r yay
fi

# upgrade and install packages
yay -Syyu\
  pambase polkit openssh\
  vi neovim\
  npm yarn\
  luarocks unzip\
  fzf zoxide ripgrep\
  python3 python-pip\
  tmux

