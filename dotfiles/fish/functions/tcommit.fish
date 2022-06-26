function tcommit -d 'Git commit at file modification time' --wraps='git commit'
  set -l toplevel (git rev-parse --show-toplevel)

  set -l max_seconds 0
  set -l max_date ''
  for file in (git diff --name-only -z --staged --diff-filter=d)
    if test -e "$toplevel/$file"
      set -l seconds (date -r $toplevel/$file +'%s')
      if test "$seconds" -gt "$max_seconds"
        set max_seconds $seconds
        set max_date (date -r $toplevel/$file +'%Y-%m-%d %H:%M:%S %z')
      end
    end
  end

  set -l ad $max_date
  set -l cd $max_date
  if set -q GIT_AUTHOR_DATE
    set ad $GIT_AUTHOR_DATE
  end
  if set -q GIT_COMMITTER_DATE
    set cd $GIT_COMMITTER_DATE
  end
  echo "Modify date: $max_date"
  echo "Author date: $ad"
  echo "Commit date: $cd"

  GIT_AUTHOR_DATE=$ad \
  GIT_COMMITTER_DATE=$cd \
  git commit $argv
end
