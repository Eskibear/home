# vi-mode
#set -g fish_key_bindings fish_vi_key_bindings

set PATH $PATH ~/.bin ~/.gem/ruby/2.2.0/bin
# alias {{
# op
function c -d 'clear screen'
  clear
end

#function ll -d 'list via ls++'
#  ls++ --potsf $argv
#end

# sys
function na -d 'netctl-auto' --wraps=netctl-auto
  sudo netctl-auto $argv
end

function n -d 'netctl' --wraps=netctl
  sudo netctl $argv
end

function rm -d 'rm -i'
  command rm -i $argv
end

function plz -d 'sudo' --wraps=sudo
  command sudo $argv
end

function pm -d 'pacman' --wraps=pacman 
  if echo $argv | grep -q -E '[-]S[^si]'
    sudo pacman $argv
  else
    pacman $argv
  end
end

function y -d 'yaourt' --wraps=yaourt
  yaourt $argv
end

function dmesg -d 'dmesg readable'
  command dmesg --human $argv
end

function sc -d 'systemctl' --wraps=systemctl
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

function sd -d 'sudo'
  sudo $argv
end

function fuck -d 'Correct your previous console command'
    set -l exit_code $status
    set -l eval_script (mktemp 2>/dev/null ; or mktemp -t 'thefuck')
    set -l fucked_up_command $history[1]
    thefuck $fucked_up_command > $eval_script
    . $eval_script
    command rm -f $eval_script
    if test $exit_code -ne 0
        history --delete $fucked_up_command
    end
end

# app

. ~/.config/fish/z.fish
# }}
