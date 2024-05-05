# use bpython to test code a lot. Don't want to create .pyc files when testing
alias bpython='PYTHONDONTWRITEBYTECODE=1 bpython'
alias bpython3='bpython'
alias bp='bpython'
alias bpy='bpython'

# use c for clear a lot
alias c='clear'

# note: shellcheck notes that "this expands when defined, not when used."
# That is deliberate, so that it works even if incognito.
# Disable that check in this case.
# shellcheck disable=SC2139
alias clear-shell-history='history -c > '"$HISTFILE"

# colorize /[ef]?grep/
alias grep='grep --color=auto'
alias egrep='grep -E'
alias fgrep='grep -F'

# sometimes use this one
alias get-dims='echo "${COLUMNS}x${LINES}"'

# often use this one.
alias h='history'

# like reset, but without the delay that exists for historical reasons
alias reset='tput reset'

# make it a bit harder to screw up
alias print_rm_warning=$'printf \'\\e[33mUse trash-put instead!\\e[m\\n\' >&2'
alias rm='print_rm_warning'

# I'm a lazy typist, and use vim all the time.
alias v='vim'
alias vi='vim'

# occasionally useful
alias wanip='curl text.myip.wtf'

# This one is stupid, but it's force of habit from when I had an alias for
# every letter of the Latin alphabet, and I got in the habit of using it.
alias x='xclip -selection clipboard'

# if 256-color or full-color support, use bat instead of cat
# -pp (short for --style=plain --paging=never) removes line numbering, file
# headings, and prevents bat from piping to less, so that it's like normal
# cat, but if output is a tty, there's syntax highlighting.
case "$(tput colors)" in
    256|16777216) alias cat='bat -pp' ;;
esac

# colorize ls
alias ls='ls --color=auto'
alias l='ls -F'
alias la='ls -A'
alias ll='ls -lA'

# vim: ft=sh 
