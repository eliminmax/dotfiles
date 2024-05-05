# not all systems have tmux terminfo, but screen terminfo works okay enough
# note: shellcheck notes that the variable in the alias "expands when defined, not when used."
# That is intentional, so disable that check in this case.
# shellcheck disable=SC2139
case $TERM in 
    tmux*) alias ssh="TERM=${TERM/tmux/screen} ssh" ;;
esac
