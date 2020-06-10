#!/bin/bash

clonedev() {
  url="$1"
  path="${url#https://}"
  path="${path#http://}"
  path="${path%.git}"
  repo="${path##*/}"
  path="${path%/*}"
  mkdir -p "$HOME/dev/$path"
  git clone "$url" "$HOME/dev/$path/$repo"
}

# Syntax highlighted cat
# https://stackoverflow.com/questions/7851134/syntax-highlighting-colorizing-cat/14799752#14799752
alias codecat='pygmentize -g -O style=solarized-dark,linenos=1'
function codeless() {
  codecat "$@" | less -R
}

# Preview Markdown files like man
# http://blog.metamatt.com/blog/2013/01/09/previewing-markdown-files-from-the-terminal/
function mdless() {
  pandoc -s -f markdown -t man "$@" | groff -T utf8 -man | less
}

function tcommit() {
  repo=$(git rev-parse --show-toplevel)
  staged_files=$(git -C "$repo" diff --name-only --staged --diff-filter=d)

  if [ ! "$staged_files" ]; then
    echo "No staged files"
    return 1
  fi

  DATE=date
  if uname | grep -q "Darwin"; then
    # brew install coreutils
    DATE=gdate
  fi

  max_nanoseconds=0
  max_date=""

  while read -r file; do
    nanoseconds=$($DATE -r "$repo/$file" +'%s%N')
    if [ $nanoseconds -gt $max_nanoseconds ]; then
      max_nanoseconds=$nanoseconds
      max_date=$($DATE -r "$repo/$file" +'%Y-%m-%d %T.%N %z')
    fi
  done <<< "$staged_files"

  git -C "$repo" status

  ad="$max_date"
  cd="$max_date"
  [ -z ${GIT_AUTHOR_DATE+x} ]    || ad="$GIT_AUTHOR_DATE"
  [ -z ${GIT_COMMITTER_DATE+x} ] || cd="$GIT_COMMITTER_DATE"
  echo "Modify date: $max_date"
  echo "Author date: $ad"
  echo "Commit date: $cd"

  echo
  read -p "Commit? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    GIT_AUTHOR_DATE="$ad" GIT_COMMITTER_DATE="$cd" git -C "$repo" commit "$@"
  fi
}

alias tcommit-oregon='TZ=":America/Los_Angeles" tcommit'

__git_complete tcommit _git_commit
__git_complete tcommit-oregon _git_commit


# Some example functions:
#
# function settitle() {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }

# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
function cd_func() {
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 == "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

alias cd=cd_func
