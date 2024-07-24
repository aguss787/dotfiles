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

### Install Plug

Follow the instructions on the [Plug GitHub page](https://github.com/junegunn/vim-plug?tab=readme-ov-file#installation).

### Install node, npm, and yarn

Use your package manager to install node, npm, and yarn. I believe in you. :)

### Clone this repo

```bash
git clone https://github.com/aguss787/nvim-config.git ~/.config/nvim
```

### Install plugins

Open NeoVim and run `:PlugInstall`

> :bulb: The first time you open NeoVim, it might show some warning regarding missing dependencies. Just ignore it and run `:PlugInstall`.

Once the installation is done, restart NeoVim.

## Trouble Shooting

### Error installing markdown-preview.nvim

If you see an error installing `markdown-preview.nvim`, you might be missing either `npm` or `yarn`. Make sure you have both installed.
Comment out the line in `plugins.lua` that installs `markdown-preview.nvim`, restart NeoVim, and run `:PlugClean`.
After `markdown-preview.nvim` is removed, uncomment the line in `plugins.lua`, restart NeoVim, and run `:PlugInstall` again.

