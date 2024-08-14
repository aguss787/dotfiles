all: nvim-config tmux-config zshrc

nvim-config: lazygit-config
	@echo "Setting up nvim..."
	ln -s $(shell pwd)/nvim ~/.config/nvim

tmux-config:
	@echo "Setting up tmux..."
	ln -s $(shell pwd)/tmux/.tmux.conf ~/.tmux.conf

zshrc:
	@echo "Setting up zsh..."
	ln -s $(shell pwd)/zsh/.zshrc ~/.zshrc

lazygit-config:
	@echo "Setting up lazygit..."
	ln -s $(shell pwd)/lazygit ~/.config/lazygit

clean:
	@echo "Cleaning up..."
	rm -rf ~/.config/nvim
	rm -rf ~/.tmux.conf
	rm -rf ~/.zshrc
	rm -rf ~/.config/lazygit

timestamp = $(shell date +%s)

backup:
	@echo "Backing up to ~/.dotfiles/backup/$(timestamp)"
	mkdir -p ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/nvim ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.tmux.conf ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.zshrc ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/lazygit ~/.dotfiles/backup/$(timestamp)
