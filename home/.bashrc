alias ls='ls -la --color=auto'

export EDITOR=nvim
export VISUAL=nvim

export HISTCONTROL=ignoredups:erasedups   # avoid duplicate history entries
export HISTSIZE=10000
export HISTFILESIZE=20000

shopt -s histappend                  # append to history file, don't overwrite

set -o vi
