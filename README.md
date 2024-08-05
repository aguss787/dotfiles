# aguss787's NeoVim Config

## Dependencies

- NeoVim >= 0.10
- Plug
- node
- npm
- yarn

## Setup

### Install NeoVim

If you are opening this repo, I assume you already have neovim installed. Update it if necessary.

### Install node, npm, and yarn

Use your package manager to install node, npm, and yarn. I believe in you. :)

### Clone this repo

```bash
git clone https://github.com/aguss787/nvim-config.git ~/.config/nvim
```

### Install plugins

Open NeoVim and install the plugins using `:Lazy`. The installation should run automatically.

### TreeSitter Setup

TreeSitter parsers is not handled in the config. This is choosen because it is not necessary to
install all the parsers for all the languages. You can install the parsers you need. Please refer to
[TreeSitter GitHub Page](https://github.com/nvim-treesitter/nvim-treesitter) on how to install the
parsers.

## Updating the config

To update the config, pull the latest changes from this repo.

```bash
cd ~/.config/nvim
git pull
```

LazyVim will install the new plugins automatically.

## Trouble Shooting

### Error installing markdown-preview.nvim

If you see an error installing `markdown-preview.nvim`, you might be missing either `npm` or `yarn`.
Make sure you have both installed.

## xdg-open-log

xdg-open-log is a simple command that read `$HOME/xdg-open.log`. This file format is not standard in
anyway, but it's a nice work around for working with xdg-open in a remote server. To set this up,
configure xdg-open to write to `$HOME/xdg-open.log`.

If you are working with a remote server, there's a high chance that it doesn't have xd-open. Add the
following script as `xdg-open` in your `$PATH`:

```bash
#!/bin/bash

echo "$1" >> $HOME/.xdg-open.log
```
