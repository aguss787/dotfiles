all: nvim-config tmux-config

nvim-config:
	@echo "Setting up nvim..."
	ln -s $(shell pwd)/nvim ~/.config/nvim

tmux-config:
	@echo "Setting up tmux..."
	ln -s $(shell pwd)/tmux/.tmux.conf ~/.tmux.conf

clean:
	@echo "Cleaning up..."
	rm ~/.config/nvim
	rm ~/.tmux.conf

timestamp = $(shell date +%s)

backup:
	@echo "Backing up to ~/.dotfiles/backup/$(timestamp)"
	mkdir -p ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.config/nvim ~/.dotfiles/backup/$(timestamp)
	cp -R ~/.tmux.conf ~/.dotfiles/backup/$(timestamp)
