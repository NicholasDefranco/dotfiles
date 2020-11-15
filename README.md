# My Dotfiles

## How to use

To effectively use this repository you should use
[GNU stow](https://www.gnu.org/software/stow/)

##### Quick instructions:

1. `git clone https://github.com/NicholasDefranco/dotfiles/` the repository
2. `stow --dir=path --target="~" package`
  * Where _path_ is the path to the root directory of the cloned repository
  * Where _package_ is the directory containing the configuration files you want (within my repository)

**Done!** All the dotfiles you're using are organized in the repository while
the location where the application expects the dotfile(s) to appear will be
symlinked to the appropriate file in the repository.
