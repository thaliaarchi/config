#!/bin/bash

repo=$(git rev-parse --show-toplevel)
staged_files=$(git -C "$repo" diff --name-only --staged)

if [ ! "$staged_files" ]; then
  echo "No staged files"
  return 1
fi

DATE=date
if uname | grep -q Darwin; then
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
  #stat -c '%y' "$file" | tr -d '\n'
  #date -r "$file" +'%Y-%m-%d %T.%N %z' | tr -d '\n'
  #printf '\t'
  #date -r "$file" +'%s%N' | tr -d '\n'
  #printf '\t'
  #printf '%s\n' "$file"
done <<< "$staged_files"

export GIT_COMMITTER_DATE=$max_date
export GIT_AUTHOR_DATE=$max_date
echo "Commit and author dates set to $max_date"
