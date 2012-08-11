# for Complex combinations {{{
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
# }}}

# Play Around
alias nethack.telnet='telnet nethack.alt.org'
