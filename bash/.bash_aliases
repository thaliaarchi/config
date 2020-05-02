# To override the alias instruction use a \ before,
# ie \rm will call the real rm not the alias.

# Interactive operation...
#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'

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

# Directory aliases
alias ~='cd $HOME'
alias ..='cd ..'

# Git
alias master='git checkout master'
source "$HOME/.config/git-completion.bash"

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
