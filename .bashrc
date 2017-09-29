#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# color definition
ORE='\[\e[0m\]'
YELLOW='\[\e[1;33m\]'
GRENN='\[\e[1;32m\]'
BLUE='\[\e[1;34m\]'

# reveal git branch
function git_branch {
  git branch &> /dev/null
  if [ $? -eq 0 ]; then 
    GIT_BR=' -> '$(git branch | grep '*' | cut -d ' ' -f 2)
  else 
    GIT_BR=''
  fi
  PS1='\n'$YELLOW'[\u '$GRENN'\H '$BLUE'\w'$ORE$YELLOW']'$GIT_BR'\n\$> '$ORE
}
PROMPT_COMMAND="git_branch; $PROMPT_COMMAND"


alias ..='cd ..'
# confirm before any rm operation
alias rm='rm -i'

# shortcut alias
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -al --color=auto'
alias grep='grep --color'
alias plz='sudo'
alias sc='sudo systemctl'
alias pm='sudo pacman'
alias n='sudo netctl'
alias na='sudo netctl-auto'
alias y='yaourt'
alias fuck='eval $(thefuck $(fc -ln -1))'

# auto-completion for alias
_completion_loader systemctl
_completion_loader netctl
_completion_loader pacman
_completion_loader yaourt
_completion_loader sudo
complete -F _systemctl -o default sc
complete -F _pacman -o default pm
complete -F _netctl -o default n
complete -F _netctl_auto -o default na
complete -F _yaourt -o default y
complete -F _sudo -o default plz

#editor
export EDITOR="vim"

# local bin folder
export PATH=$PATH:~/.bin

# including this ensures that new gnome-terminal tabs keep the parent `pwd` !
if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi

# z for bash
if [ -e /usr/lib/z.sh ]; then
    . /usr/lib/z.sh
fi
