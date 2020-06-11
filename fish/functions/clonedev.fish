function clonedev --description='Clone git repo to ~/dev'
  set url $argv[1]
  if test -z $url
    echo "Usage: clonedev URL"
    return 1
  end
  set path (string replace --regex '^https?://(.+?)(\.git)?/?$' '$1' $url)
  mkdir -p ~/dev/$path
  git clone $url ~/dev/$path
end
