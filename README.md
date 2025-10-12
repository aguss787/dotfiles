# Dotfiles of aguss787

## Setup

This `make` command will try to create a symbolic link for each configuration in this repository.
You can setup individual configuration by specifying the target.

```bash
make
```

## Backup

This command will backup your previous configuration to `~/.dotfiles/backup`.

```bash
make backup
```

## Clean Up

```bash
make clean
```

> [!CAUTION]  
> Running the clean up command might result in loss of previous configuration. Run backup before
> cleaning up your configuration.

## Experimental - symkeeper

Using [symkeeper](https://github.com/aguss787/symkeeper) is a cleaner way to manage the symlinks
rather than using Makefile. The tool is still in its early stages, so this config is marked as
experimental.

To use it, install `symkeeper` and run the following command:

```bash
symkeeper sync
```
