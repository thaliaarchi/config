# Disable greeting
set fish_greeting

# Git
alias g='git'
alias gadd='git add'
alias branch='git branch'
alias checkout='git checkout'
alias check='git checkout'
alias clone='git clone'
alias commit='git commit'
alias gdiff='git diff'
alias fetch='git fetch'
alias ginit='git init'
alias glog='git log'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias gstatus='git status'

alias master='git checkout master'
alias tcommit-pacific='TZ=":America/Los_Angeles" tcommit'
alias tcommit-mountain='TZ=":America/Denver" tcommit'
alias tcommit-berlin='TZ=":Europe/Berlin" tcommit'

# Directory listings
if uname | grep -q Darwin
  # Enable ls color output
  # https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output
  set -x CLICOLOR 1
  set -x LSCOLORS ExGxBxDxCxEgEdxbxgxcxd
  alias ls='ls -hF'
else
  alias ls='ls -hF --color=tty'
end
alias ll='ls -l'
alias la='ls -A'  # all but . and ..
alias lla='ls -lA'
alias l='ls -CF'

# Misc
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias df='df -h'
alias du='du -h'
alias whence='type -a'

# Directory shortcuts
# ~ and .. are supported by default
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias dev='cd ~/dev'
alias godev='cd ~/go/src'

# Update credentials on every sudo
alias sudo='command sudo -v; command sudo'

# Code Search, show line numbers
command -q csearch && alias csearch='csearch -n'
command -q cgrep   && alias cgrep='cgrep -n'

command -q lynx && alias ddg='lynx https://duckduckgo.com/lite'
command -q curl && alias weather='curl wttr.in'

# rsync command for copying from an NTFS drive.
# Permissions are not preserved; symlinks and times are preserved.
# Attributes set to rwxr-xr-x for dirs, rw-r--r-- for files.
# Excludes Thumbs.db and desktop.ini.
command -q rsync && alias rsyncwin='rsync -rltDvzh --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --exclude Thumbs.db --exclude desktop.ini'

# 4-column ASCII table
command -q wspace && alias ascii4='wspace ~/go/src/github.com/andrewarchi/nebula/programs/ascii4.out.ws'

# Format history time as "2006-01-02 15:04:05  "
alias history='history --show-time="%Y-%m-%d %H:%M:%S  "'

# https://github.com/ungoogled-software/ungoogled-chromium-macos#setting-up-the-build-environment
# https://github.com/pyenv/pyenv#basic-github-checkout
command -q pyenv && pyenv init - | source

# Homebrew Command Not Found
# https://github.com/Homebrew/homebrew-command-not-found
if status is-interactive && command -q brew
  set handler (brew --prefix)'/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish'
  if test -f $handler
    source $handler
  end
end

# /etc/profile sets 022, removing write perms to group and others.
# Neither group nor others have any perms:
umask 077

# set -a CDPATH . ~/dev/github.com/andrewarchi ~/go/src/github.com/andrewarchi

if test -d ~/man
  set MANPATH ~/man $MANPATH
end
if test -d ~/info
  set INFOPATH ~/info $INFOPATH
end

# Load local configuration
if test -e ~/.config/fish/config_local.fish
  source ~/.config/fish/config_local.fish
end

if status is-login && status is-interactive
  command -q neofetch && neofetch
end
