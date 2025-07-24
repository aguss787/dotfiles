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

Follow the instruction in the top level README on how to setup this dotfile.

### Install plugins

Open NeoVim and install the plugins using `:Lazy`. The installation should run automatically.

## Updating the config

To update the config, pull the latest changes from this repo. LazyVim will install the new plugins
automatically.

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

## CodeCompanion Configuration

The `codecompanion.nvim` plugin uses a `.ai.json` configuration file to customize its behavior. This
file can be placed in two locations:

- `~/.ai.json`: For global configurations that apply to all projects.
- `<project_root>/.ai.json`: For project-specific configurations.

Project-specific configurations will override global configurations if the same keys are present in
both files.

### Available Configuration Fields

- `test_cmd`: (Optional) A string specifying the command to run your project's test suite.
  CodeCompanion will use this command when running agents in "Agent" mode to verify changes.
  Example: `"npm test"` or `"go test ./..."`
- `rules`: (Optional) An array of strings, where each string is a rule that the LLM should follow.
  These rules are prepended to the system prompt for CodeCompanion's prompts, ensuring the LLM
  adheres to them. Example:
  `["Always use Conventional Commits", "Never refactor existing code unless explicitly asked"]`

### Example `.ai.json`

```json
{
  "test_cmd": "npm test",
  "rules": [
    "Always use TypeScript for new files",
    "Ensure all public functions have JSDoc comments"
  ]
}
```
