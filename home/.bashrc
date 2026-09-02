#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


export BROWSER="firefox"
export VISUAL="nvim"
export EDITOR="nvim"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\e[38;5;141m\]┌──(\[\e[94;1m\]\u\[\e[94m\]@\[\e[94m\]\h\[\e[38;5;141m\])-[\[\e[38;5;141;1m\]\w\[\e[38;5;141m\]]\n\[\e[38;5;141m\]╰─\[\e[94;1m\]\$\[\e[0m\] '
