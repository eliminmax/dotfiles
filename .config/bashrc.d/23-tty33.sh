# ttyemu emulates a classic ASR-33 terminal and exports TERM=tty33
# if set, unset a bunch of values that cause problems with it

# exit if term ≠ tty33
if [ "$TERM" != tty33 ]; then return 0; fi

# set a simple set of PS{1..4} vars and unset PROMPT_COMMAND,

PS1='$ '
PS2='> '
PS3=': '
PS4='+ '
if [ -n "$PROMPT_COMMAND" ]; then unset PROMPT_COMMAND; fi

# If launched from terminals like kitty, inherits COLORTERM=truecolor.
# That's bad. Unset it here.

if [ -n "$COLORTERM" ]; then unset COLORTERM; fi

# alias clear to true, so that if I run it out of habit, it does nothing
alias clear=:

# set editor to Ed, man! !man ed
export EDITOR=ed

unalias ls
unalias grep
