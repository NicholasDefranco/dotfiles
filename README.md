# My Dotfiles

## How to use

To effectively use this repository you should use
[GNU stow](https://www.gnu.org/software/stow/)

## Quick instructions

1. Clone the repository with:

   ```bash
   git clone https://github.com/nick-cd/dotfiles/
   ```

2. Use stow:

   ```bash
   stow --dir=path --target="~" package
   ```

   - Where _path_ is the path to the root directory of the cloned repository;
   - Where _package_ is the directory containing the configuration files you
     want (within the cloned repository).
