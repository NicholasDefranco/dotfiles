# Code from the offical git-scm website
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
# **I have made the branch name blue here**
RPROMPT=%F{blue}\$vcs_info_msg_0_%f
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%B(%b) %r'

# Credit to Luke Smith for these configs
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
# Enable colors
autoload -U colors && colors

# Added a ternary conditional that changes the colour of the dollar prompt depending on the exit code of the previously executed command
# Found out about this feature here:
# https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
#
# The dir path will be shorten if it is longer than three elements, the code for this was found here:
# https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt#273567
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%(3~|../%2~|%~)%{$fg[red]%}]%(?.%{$fg[green]%}.%{$fg[red]%}) $%{$reset_color%}% %b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# plugins list for antibody
# antibody bundle <plugin> >> "${ZSHPLUGS}"
# to install a plugin
source "${ZSHPLUGS}"

# Load aliases
[ -f "$HOME/.config/aliases" ] && source "$HOME/.config/aliases"

# Load custom functions
if [ -f ~/.config/funcs.sh ]; then
    source ~/.config/funcs.sh
fi

# bind Ctrl+o to lfcd function
bindkey -s '^o' 'lfcd\n'

# added by travis gem
[ ! -s /home/nick/.travis/travis.sh ] || source /home/nick/.travis/travis.sh
