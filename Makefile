.PHONY: all update utils vscode essential tmux zsh news mw clean

all: essential zsh news tmux mw

update:
	apt update && apt upgrade -y && apt autoremove -y

utils: update
	apt install -y git stow
	stow --dir="." --target="$(HOME)" git

vscode: update utils
	apt install -y ctags neovim
	rm -f $(HOME)/.profile
	stow --dir="." --target="$(HOME)" sh
	rm -f $(HOME)/.bash* $(HOME)/.inputrc
	stow --dir="." --target="$(HOME)" bash
	stow --dir="." --target="$(HOME)" nvim

essential: vscode

tmux: update utils
	apt install -y tmux
	stow --dir="." --target="$(HOME)" tmux

zsh: update utils
	apt install -y zsh
	stow --dir="." --target="$(HOME)" zsh

news: update utils
	apt install -y newsboat
	stow --dir="." --target="$(HOME)" newsboat

mw: update utils
	apt install -y neomutt isync msmtp pass notmuch lynx abook
	rm -rf mutt-wizard/
	git clone https://github.com/LukeSmithxyz/mutt-wizard
	sudo make -C mutt-wizard install
	@echo "\nmw -a <email> to add a new email account"

clean:
	rm -rf mutt-wizard/
