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

PS1='\n'$YELLOW'[\u '$GRENN'\h '$BLUE'\w'$ORE'\[\e[1;33m\]]\n\$> \[\e[0m\]'
#\[\e[34m\]
#\[\e[m\]

# for office 2010
export WINEPREFIX="/home/six/.wine32/"
export WINEARCH="win32"


alias ..='cd ..'
# confirm before any rm operation
alias rm='rm -i'

# shortcut alias
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -al --color=auto'
alias grep='grep --color'
alias sd='sudo'
alias sc='sudo systemctl'
alias pm='sudo pacman'
alias n='sudo netctl'
alias na='sudo netctl-auto'
alias y='yaourt'

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
complete -F _sudo -o default sd

# mount smb fs in lab
alias mshare='sudo mount -t cifs //192.168.1.66/SharedFolder /mnt/winshare -o user=sdf,password=sdf,uid=1000,gid=100'
alias umshare='sudo umount /mnt/winshare'
