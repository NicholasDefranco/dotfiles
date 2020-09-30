#!/bin/bash

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.config/aliases ]; then
    . ~/.config/aliases
fi


# Load custom functions
if [ -f ~/.config/funcs.sh ]; then
    source ~/.config/funcs.sh
fi

