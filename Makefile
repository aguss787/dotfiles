all: nvim-config tmux-config zshrc

nvim-config:
	@echo "Setting up nvim..."
	ln -s $(shell pwd)/nvim ~/.config/nvim

tmux-config:
	@echo "Setting up tmux..."
	ln -s $(shell pwd)/tmux/.tmux.conf ~/.tmux.conf

zshrc:
	@echo "Setting up zsh..."
	ln -s $(shell pwd)/zsh/.zshrc ~/.zshrc

clean:
	@echo "Cleaning up..."
	rm -f ~/.config/nvim
	rm -f ~/.tmux.conf
	rm -f ~/.zshrc

timestamp = $(shell date +%s)

backup:
	@echo "Backing up to ~/.dotfiles/backup/$(timestamp)"
	mkdir -p ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/nvim ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.tmux.conf ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.zshrc ~/.dotfiles/backup/$(timestamp)
