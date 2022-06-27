function tcommit -d 'Git commit at file modification time' --wraps='git commit'
  set -l max_date ''
  if ! set -q GIT_AUTHOR_DATE || ! set -q GIT_COMMITTER_DATE
    set -l toplevel (git rev-parse --show-toplevel)
    set -l max_seconds -1
    set -l max_file
    for file in (git diff --name-only -z --staged --diff-filter=d)
      if test -e "$toplevel/$file"
        set -l seconds (date -r $toplevel/$file +'%s')
        if test "$seconds" -gt "$max_seconds"
          set max_seconds $seconds
          set max_file $toplevel/$file
        end
      end
    end
    if test $max_seconds != -1
      set max_date (date -r $max_file +'%Y-%m-%d %H:%M:%S %z')
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
  if test $ad != $cd
    echo "Modify date: $max_date"
    echo "Author date: "(test -n "$ad" && echo $ad || echo now)
    echo "Commit date: "(test -n "$cd" && echo $cd || echo now)
  else
    echo "Date: "(test -n "$ad" && echo $ad || echo now)
  end

  GIT_AUTHOR_DATE=$ad \
  GIT_COMMITTER_DATE=$cd \
  git commit $argv
end
