#!/bin/bash -e

max_date=''
if [[ ! -v GIT_AUTHOR_DATE || ! -v GIT_COMMITTER_DATE ]]; then
  toplevel="$(git rev-parse --show-toplevel)"
  max_seconds=-1
  max_file=
  while IFS= read -r -d $'\0' file; do
    if [[ -e $toplevel/$file ]]; then
      seconds="$(date -r "$toplevel/$file" +'%s')"
      if [[ $seconds > $max_seconds ]]; then
        max_seconds="$seconds"
        max_file="$toplevel/$file"
      fi
    fi
  done < <(git diff --name-only -z --staged --diff-filter=d)
  if [[ $max_seconds != -1 ]]; then
    max_date="$(date -r "$max_file" +'%Y-%m-%d %H:%M:%S %z')"
  fi
fi

export GIT_AUTHOR_DATE="${GIT_AUTHOR_DATE-"$max_date"}"
export GIT_COMMITTER_DATE="${GIT_COMMITTER_DATE-"$max_date"}"

if [[ "$GIT_AUTHOR_DATE" != "$GIT_COMMITTER_DATE" ]]; then
  echo "Modify date: $max_date"
  echo "Author date: ${GIT_AUTHOR_DATE:-now}"
  echo "Commit date: ${GIT_COMMITTER_DATE:-now}"
else
  echo "Date: ${GIT_AUTHOR_DATE:-now}"
fi

git commit "$@"
