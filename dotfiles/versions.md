# Version requirements

- fish next-minor may omit range limits in index range expansions like
  `$x[$start..$end]`: `$start` and `$end` default to 1 and -1,
  respectively.
- tmux 3.1 (20200203) adds `~/.config/tmux/tmux.conf` to the default
  search path for configuration files
  (see https://github.com/tmux/tmux/issues/142).
- fish 3.1b1 (20200126) changed `command -q` to imply `command -sq`
  (see https://github.com/fish-shell/fish-shell/pull/5631).
- shellcheck 0.7.0 (20190728) searches for `.shellcheckrc` or
  `shellcheckrc` in parent directories and falls back to
  `~/.shellcheckrc` or `$XDG_CONFIG_HOME/shellcheckrc`
  (see https://github.com/koalaman/shellcheck/issues/725).
- Neofetch 4.0.2 (20180519) added the `--print_config` option.
- fish 3.0b1 (20181211) supports `&&`, `||`, and `!`
  (see https://github.com/fish-shell/fish-shell/issues/4620).
