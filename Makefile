all: nvim-config

nvim-config:
	@echo "Setting up nvim..."
	ln -s $(shell pwd)/nvim ~/.config/nvim

clean:
	@echo "Cleaning up..."
	rm ~/.config/nvim
