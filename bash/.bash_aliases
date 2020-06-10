# To override the alias instruction use a \ before,
# ie \rm will call the real rm not the alias.

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in color
alias egrep='egrep --color=auto'              # show differences in color
alias fgrep='fgrep --color=auto'              # show differences in color

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in color
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'

# Enable ls color output for macOS
# https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output
# export CLICOLOR=1
# export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
# alias l='ls -h'
# alias ls='ls -h'
# alias la='ls -Ah'
# alias ll='ls -Alh'

# Directory aliases
alias ~='cd $HOME'
alias ..='cd ..'
alias dev='cd $HOME/dev'
alias godev='cd $HOME/go/src'

# Git
alias master='git checkout master'
source "$HOME/.config/bash_completion/git-completion.bash"

alias g='git'
alias branch='git branch'
alias checkout='git checkout'
alias check='git checkout'
alias clone='git clone'
alias commit='git commit'
alias gdiff='git diff'
alias fetch='git fetch'
alias glog='git log'
alias pull='git pull'
alias push='git push'
# https://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases
__git_complete g __git_main
__git_complete branch _git_branch
__git_complete checkout _git_checkout
__git_complete check _git_checkout
__git_complete clone _git_clone
__git_complete commit _git_commit
__git_complete gdiff _git_diff
__git_complete fetch _git_fetch
__git_complete glog _git_log
__git_complete pull _git_pull
__git_complete push _git_push

# SSH remotes
alias bb='ssh -t schizo "ssh blackbird"'
alias de='ssh -t schizo "ssh germany"'

# SSH into a random CS lab machine
alias cs='CS_MACHINES=($(cat ~/cs_machines_random)); RANDOM_MACHINE="${CS_MACHINES[$RANDOM % ${#CS_MACHINES[@]}]}"; echo "ssh $RANDOM_MACHINE"; ssh "$RANDOM_MACHINE"'

# Aliases
alias weather='curl wttr.in'

# rsync command for copying from an NTFS drive.
# Permissions are not preserved; symlinks and times are preserved.
# Attributes set to rwxr-xr-x for dirs, rw-r--r-- for files.
# Excludes Thumbs.db and desktop.ini.
alias rsyncwin='rsync -rltDvzh --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --exclude Thumbs.db --exclude desktop.ini'

alias ascii4='wspace $HOME/go/src/github.com/andrewarchi/nebula/programs/ascii4.out.ws'
