# Bash parameter expansion

[*Abbreviated from 3.5.3 Shell Parameter Expansion in the Bash Reference Manual*](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

If `parameter` is unset or null:

- `${parameter:-word}` - substitute the expansion of `word`; otherwise,
  substitute the value of `parameter`.
- `${parameter:=word}` - assign the expansion of `word` to `parameter` (except
  for to positional and special parameters); then, substitute the value of
  `parameter`.
- `${parameter:?word}` - write the expansion of `word` to stderr and, if it is
  non-interactive, exit the shell; otherwise, substitute the value of
  `parameter`.
- `${parameter:+word}` - substitute nothing; otherwise, substitute the expansion
  of `word`.

To instead only check if `parameter` is unset, omit the colon with `-`, `=`,
`?`, and `+`.
