all: wezterm-config nvim-config tmux-config zshrc rofi-config lazygit-config gnupg-config
server: nvim-config tmux-config zshrc gnupg-config

wezterm-config:
	@echo "Setting up wezterm..."
	ln -s $(shell pwd)/wezterm/.wezterm.lua ~/.wezterm.lua

nvim-config: lazygit-config
	@echo "Setting up nvim..."
	mkdir -p ~/.config
	ln -s $(shell pwd)/nvim ~/.config/nvim

tmux-config:
	@echo "Setting up tmux..."
	ln -s $(shell pwd)/tmux/.tmux.conf ~/.tmux.conf

zshrc:
	@echo "Setting up zsh..."
	ln -s $(shell pwd)/zsh/.zshrc ~/.zshrc

rofi-config:
	@echo "Setting up rofi..."
	mkdir -p ~/.config
	ln -s $(shell pwd)/rofi ~/.config/rofi

lazygit-config:
	@echo "Setting up lazygit..."
	mkdir -p ~/.config
	ln -s $(shell pwd)/lazygit ~/.config/lazygit

gnupg-config:
	@echo "Setting up gnupg..."
	mkdir -p ~/.gnupg
	ln -s $(shell pwd)/gnupg/gpg.conf ~/.gnupg/gpg.conf

clean:
	@echo "Cleaning up..."
	rm -rf ~/.config/nvim
	rm -rf ~/.tmux.conf
	rm -rf ~/.zshrc
	rm -rf ~/.config/lazygit
	rm -rf ~/.gnupg/gpg.conf
	rm -rf ~/.wezterm.lua
	rm -rf ~/.config/rofi

timestamp = $(shell date +%s)

backup:
	@echo "Backing up to ~/.dotfiles/backup/$(timestamp)"
	mkdir -p ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/nvim ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.tmux.conf ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.zshrc ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/lazygit ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.gnupg/gpg.conf ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.wezterm.lua ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/rofi ~/.dotfiles/backup/$(timestamp)
