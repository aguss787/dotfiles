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
