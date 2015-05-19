# vi-mode
#set -g fish_key_bindings fish_vi_key_bindings

# alias {{
# op
function c -d 'clear screen'
  clear
end

#function ll -d 'list via ls++'
#  ls++ --potsf $argv
#end

# sys
function na -d 'netctl-auto'
  sudo netctl-auto $argv
end

function n -d 'netctl'
  sudo netctl $argv
end

function rm -d 'rm -i'
  rm -i $argv
end

function pm -d 'pacman'
  if echo $argv | grep -q -E '[-]S[^si]'
    sudo pacman $argv
  else
    pacman $argv
  end
end

function y -d 'yaourt'
  yaourt $argv
end

function dmesg -d 'dmesg readable'
  dmesg --human $argv
end

function sc -d 'systemctl'
  if echo $argv | grep -q -E 'status'
    systemctl $argv
  else
    sudo systemctl $argv
  end
end

function sjc -d 'su journalctl'
  sudo journalctl $argv
end

function jc -d 'journalctl'
  journalctl $argv
end

# app

. ~/.config/fish/z.fish
# }}
