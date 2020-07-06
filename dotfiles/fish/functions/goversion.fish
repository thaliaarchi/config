function select_option
  set prompt $argv[1]
  set options $argv[2..-1]
  while true
    read -P "$prompt: " val
    if contains $val $options
      echo $val
      return
    end
  end
end

function prompt_yn
  read -P "$argv[1] (y/n) " -n1 reply
  string match -q -i 'y' $reply
  return $status
end

function append_install
  set go $argv[1]
  if ! test -x $go
    echo "Not executable: $go" >&2
    return
  end
  set GOROOT ($go env GOROOT)
  if ! contains -- $GOROOT $installs
    set -a installs $GOROOT
  end
end

function goversion
  for dep in git jq curl wget
    if ! command -q $dep
      set -a missing $dep
    end
  end
  if count $missing > /dev/null
    echo "Required dependencies: $missing" >&2
    exit 1
  end

  # See https://github.com/golang/website/blob/master/internal/dl/server.go
  set releases (curl -sS 'https://golang.org/dl/?mode=json&include=all')
  set versions (echo $releases | jq -r '.[].version')

  # Go GitHub release tags:
  # curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
  #     jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'

  set_color -o green
  echo 'Stable versions:'
  set_color normal
  echo $releases | jq -r '.[] | select(.stable == true) | .version' | column
  echo

  set_color -o red
  echo 'Unstable versions:'
  set_color normal
  echo $releases | jq -r '.[] | select(.stable == false) | .version' | column
  echo

  set_color -o blue
  echo 'Installed versions:'
  set_color normal
  set installs

  if command -q go
    append_install (command -v go)
  end

  # Installs in PATH
  for p in $PATH
    if test -f $p/go -a -x $p/go
      append_install $p/go
    end
  end

  # Homebrew
  if command -q brew
    # `brew list --versions golang` is too slow.
    # Instead list versions in cellar directory.
    set brew_prefix (brew --prefix)
    for v in (command ls $brew_prefix/Cellar/go 2>/dev/null)
      append_install "$brew_prefix/Cellar/go/$v/bin/go"
    end
  end

  # Extra versions: https://golang.org/doc/install#extra_versions
  for goversion in (command ls ~/sdk 2>/dev/null | grep '^go')
    append_install ~/sdk/$goversion/bin/go
  end

  set --path gopaths
  for GOROOT in $installs
    set go $GOROOT/bin/go
    set goversion ($go version)
    echo (string replace -r '^go version ' '' $goversion)'  '$GOROOT
    set -a installs
    set GOPATH ($go env GOPATH)
    for p in $GOPATH
      if ! contains -- $p $gopaths
        set -a gopaths $p
      end
    end
  end
  echo

  if prompt_yn 'Install main version?'
    set goversion (select_option 'Select version' $versions)
    echo

    echo 'Binaries:'
    set binaries (echo -n $releases |
        jq --arg goversion $goversion \
          -r '.[] | select(.version == $goversion) | .files | .[].filename')
    string collect $binaries | column

    set binary (select_option 'Select binary' $releases)

    echo 'Fetching binary...'
    wget -nc -q --show-progress "https://golang.org/dl/$binary"
    echo
  end

  if prompt_yn 'Install extra versions?'
    go get -d golang.org/dl/gotip
    set GOPATH (go env GOPATH)
    set versions (git -C "$GOPATH[1]/src/golang.org/dl" ls-tree -d --name-only HEAD | grep '^go')

    echo 'Versions:'
    string collect $versions | sort -Vr | column
    echo

    while true
      set go (select_option 'Select version' $versions)
      go install golang.org/dl/$go
      eval $go download
      eval $go version
    end
  end
end
