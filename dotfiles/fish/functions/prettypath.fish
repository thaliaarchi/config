function prettypath -d 'Format paths with ~ for $HOME'
  set home (string escape --style=regex $HOME)
  string replace -r "^$home\b" '~' $argv
end
