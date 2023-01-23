# Default values set by __fish_config_interactive
# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_config_interactive.fish

function config_vars -d 'Set universal variables from configuration'
  set -Ux EMAIL andrew@aarchibald.com
  set -Ux EDITOR vim
  set -Ux GIT_EDITOR 'code --wait'

  set -l path_dirs ~/bin /usr/local/go/bin ~/go/bin \
    ~/.cargo/bin /usr/local/opt/llvm/bin \
    ~/dev/github.com/andrewarchi/whitespace-haskell/bin \
    ~/dev/github.com/LLNL/yorick/relocate/bin
  set -Ue fish_user_paths
  for dir in $path_dirs
    if test -d $dir
      set -a fish_user_paths $dir
    end
  end

  # Set host color based on hostname
  set -l host_color
  switch (hostname)
    case raspi;          set host_color c31c4a # Raspberry Pi Foundation red
    case blueberrye;     set host_color blue
    case marionberryphi; set host_color magenta
    case blackberryi;    set host_color magenta
    case strawberrytau;  set host_color red
    case germany;        set host_color dd0000 # Flag red
  end
  if test -n "$host_color"
    set -U fish_color_host $host_color
    set -U fish_color_host_remote $host_color
  else
    set -U fish_color_host normal
    set -U fish_color_host_remote yellow
  end
  return 0
end
