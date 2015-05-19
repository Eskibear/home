function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l under_yellow (set_color -ou yellow)
  set -l yellow (set_color -o yellow)
  set -l normal (set_color normal)

  set -l marker
  if test $USER = root -o $USER = toor
    set marker $red'# '
  else
    set marker $yellow'$> '
  end

  set -l cwd $under_yellow(echo $PWD | sed -e "s|^$HOME|~|")
  if not set -q __fish_hostname
    set -g __fish_hostname $red(hostname)
  end

  set -l gitbranch $cyan(git branch ^/dev/null | grep \* | sed 's/* //')

  echo 
  echo -s $yellow [$normal $cyan $USER$normal\ $__fish_hostname$normal\ $cwd $normal $yellow ] $gitbranch
  echo $marker

  z --add "$PWD"
end

function fish_right_prompt
  set -l stat $status

  set -l green (set_color -o green)
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l normal (set_color normal)

  echo -e "\n"
  if [ $stat -ne 0 ]
    echo -n $red
  else
    echo -n $green
  end
  echo "($stat)"

end
