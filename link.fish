#!/usr/bin/env fish

# Install links to config

set dotfiles_dir (dirname (realpath (status -f)))/dotfiles

functions -q prettypath || source $dotfiles_dir/fish/functions/prettypath.fish

# Symlink config to destination and replace existing
# when unchanged from default.
function link_config -a src dest
  set src $dotfiles_dir/$src

  if test -L "$dest"
    # Preserve unchanged symlinks
    if test (readlink $dest) != "$src"
      ln -sf -- $src $dest
    end
    return
  end

  if test -d $src -a -d $dest
    if count (command ls -A $dest) > /dev/null
      echo "Files in directory" (prettypath $dest) >&2
      return 1
    end
    rm -r $dest
  end

  if test -e "$dest"
    echo "File or directory already exists at" (prettypath $dest) >&2
    return 1
  end

  mkdir -p -- (dirname $dest)
  ln -s -- $src $dest
end

function fetch_file -a url dest
  set dest $dotfiles_dir/$dest
  mkdir -p -- (dirname $dest)
  test -f "$dest" || wget $url -O $dest
end

function remove_default -a dest default
  if test -f "$dest" -a ! -L "$dest"
    if cmp -s -- $default $dest
      rm $dest
    else
      echo "File" (prettypath $dest) "is modified from default at" (prettypath $default) >&2
    end
  end
end

function remove_default_neofetch -a dest
  if test -f "$dest" -a ! -L (dirname $dest)
    if neofetch --print_config 2>/dev/null | cmp -s -- $dest -
      rm $dest
    else if after_version (neofetch --version | head -n1) '4.0.2'
      echo "File" (prettypath $dest) "is modified from `neofetch --print_config`" >&2
    end
  end
end

function after_version -a current min
  set versions (string collect $current $min | sort -V)
  test "$versions[1]" = "$min"
end

test -z "$XDG_CONFIG_HOME" && set XDG_CONFIG_HOME ~/.config

fetch_file 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' bash/completions/git-completion.bash

remove_default ~/.bashrc /etc/skel/.bashrc
remove_default ~/.bash_profile /etc/skel/.bash_profile
remove_default ~/.bash_logout /etc/skel/.bash_logout
remove_default ~/.screenrc /etc/skel/.screenrc
remove_default_neofetch $XDG_CONFIG_HOME/neofetch/config.conf

# Files in $HOME
link_config bash/bashrc.bash ~/.bashrc
link_config bash/bash_profile.bash ~/.bash_profile
link_config bash/bash_logout.bash ~/.bash_logout
link_config screenrc ~/.screenrc
test -f ~/.hushlogin || touch ~/.hushlogin # Suppress MOTD
# Directories in $XDG_CONFIG_HOME
link_config neofetch $XDG_CONFIG_HOME/neofetch
# Files in $XDG_CONFIG_HOME
link_config shellcheckrc $XDG_CONFIG_HOME/shellcheckrc
link_config karabiner $XDG_CONFIG_HOME/karabiner

if after_version (tmux -V) 'tmux 3.1'
  # tmux checks ~/.config, not $XDG_CONFIG_HOME
  test -L ~/.tmux.conf && rm ~/.tmux.conf
  test -f ~/.tmux.conf && echo 'Config at ~/.tmux.conf shadows ~/.config/tmux/tmux.conf' >&2
  link_config tmux ~/.config/tmux
else
  tmux -L ~/.config/tmux && rm ~/.config/tmux
  test -f ~/.config/tmux/tmux.conf && echo 'Config at ~/.config/tmux/tmux.conf is ignored by' (tmux -V) >&2
  link_config tmux/tmux.conf ~/.tmux.conf
end

if ! test -L $XDG_CONFIG_HOME/fish
  for file in $XDG_CONFIG_HOME/fish/{fish_variables*,config_local.fish}
    set dotfiles_file $dotfiles_dir/fish/(basename $file)
    if test -e "$dotfiles_file" && ! cmp -s -- $file $dotfiles_file
      echo (basename $file) "exists at both" (prettypath $XDG_CONFIG_HOME/fish) "and" (prettypath $dotfiles_dir/fish) >&2
    else
      mv -- $file $dotfiles_dir/fish/
    end
  end
end
link_config fish $XDG_CONFIG_HOME/fish
