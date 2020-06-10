# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

[ -f "$HOME/.bash_aliases" ]   && source "$HOME/.bash_aliases"
[ -f "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"
[ -d "$HOME/bin" ]  && PATH="$HOME/bin:$PATH"
[ -d "$HOME/man" ]  && MANPATH="$HOME/man:$MANPATH"
[ -d "$HOME/info" ] && INFOPATH="$HOME/info:$INFOPATH"

export EMAIL=andrew@aarchibald.com
export EDITOR=vim
export GIT_EDITOR=vim

# Bash 4+
# https://github.com/Homebrew/homebrew-command-not-found#requirements
PATH="/usr/local/bin/bash:$PATH"

# Homebrew Command Not Found
# https://github.com/Homebrew/homebrew-command-not-found
# Installation check is slow, so I removed it:
# if brew command command-not-found-init > /dev/null 2>&1; then eval "$(brew command-not-found-init)"; fi
eval "$(brew command-not-found-init)"

# Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source "$HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh"

# Reset permissions
# find . -type d -exec chmod 755 {} \;
# find . -type f -exec chmod 644 {} \;

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Folder-based applications
export PATH="$HOME/lib/bin:$PATH"

# Go
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Yorick
export PATH="$HOME/dev/github.com/dhmunro/yorick/relocate/bin:$PATH"

# Whitespace
export PATH="$HOME/dev/compsoc.dur.ac.uk/whitespace/WSpace/bin:$PATH"

# LLVM (keg only, see Homebrew caveats)
export PATH="/usr/local/opt/llvm/bin:$PATH"

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options

# Format as "2006-01-02 15:04:05: "
export HISTTIMEFORMAT="%F %T: "

# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Umask

# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
umask 077
