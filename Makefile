.PHONY: all news zsh

all:
	apt install stow git neovim tmux
	stow --dir="." --target="$(HOME)" sh
	stow --dir="." --target="$(HOME)" bash
	stow --dir="." --target="$(HOME)" nvim
	stow --dir="." --target="$(HOME)" git
	stow --dir="." --target="$(HOME)" tmux

zsh:
	apt install zsh
	stow --dir="." --target="$(HOME)" zsh

news:
	apt install newsboat
	stow --dir="." --target="$(HOME)" newsboat

