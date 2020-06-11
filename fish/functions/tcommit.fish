function tcommit --description='Git commit at file modification time' --wraps='git commit'
  set repo (git rev-parse --show-toplevel)
  set staged_files (git -C $repo diff --name-only --staged --diff-filter=d)

  if test -z "$staged_files"
    echo 'No staged files'
    return 1
  end

  set DATE date
  if uname | grep -q Darwin
    # brew install coreutils
    set DATE gdate
  end

  set max_nanoseconds 0
  set max_date ''

  for file in $staged_files
    set nanoseconds ($DATE -r $repo/$file +'%s%N')
    if test $nanoseconds -gt $max_nanoseconds
      set max_nanoseconds $nanoseconds
      set max_date ($DATE -r $repo/$file +'%Y-%m-%d %T.%N %z')
    end
  end

  git -C $repo status

  set ad $max_date
  set cd $max_date
  if set -q GIT_AUTHOR_DATE
    set ad $GIT_AUTHOR_DATE
  end
  if set -q GIT_COMMITTER_DATE
    set cd $GIT_COMMITTER_DATE
  end
  echo "Modify date: $max_date"
  echo "Author date: $ad"
  echo "Commit date: $cd"

  echo
  read -P 'Commit? (y/n) ' -n 1 reply
  if string match -i 'y' $reply
    GIT_AUTHOR_DATE=$ad GIT_COMMITTER_DATE=$cd git -C $repo commit $argv
  end
end
