# exit in non-kitty terminals
if ! [ "$TERM" = 'xterm-kitty' ]; then return 0; fi

# note: shellcheck thinks that I'm trying to escape a single quote at the end
# of each of these printf statements, but I'm not - I'm ending each of them
# with a literal backslash.
# shellcheck disable=SC1003
kitty_light_mode () {
    export LIGHT_MODE=1
    printf '\x1b]10;#000000\x1b\\\x1b]11;#ffffff\x1b\\\x1b]12;#000000\x1b\\'
    printf '\x1b]17;#b4d5ff\x1b\\\x1b]19;#ffffff\x1b\\\x1b]4;0;#000000\x1b\\'
    printf '\x1b]4;1;#cc0000\x1b\\\x1b]4;2;#4e9a06\x1b\\\x1b]4;3;#c4a000\x1b\\'
    printf '\x1b]4;4;#3465a4\x1b\\\x1b]4;5;#75507b\x1b\\\x1b]4;6;#06989a\x1b\\'
    printf '\x1b]4;7;#d3d7cf\x1b\\\x1b]4;8;#555753\x1b\\\x1b]4;9;#ef2929\x1b\\'
    printf '\x1b]4;10;#8ae234\x1b\\\x1b]4;11;#fce94f\x1b\\\x1b]4;12;#729fcf\x1b\\'
    printf '\x1b]4;13;#ad7fa8\x1b\\\x1b]4;14;#34e2e2\x1b\\\x1b]4;15;#eeeeec\x1b\\'
    __prompt_prev_okay_color_code='38;5;34'
    __prompt_prev_fail_color_code='38;5;202'
    alias bat='bat --theme=OneHalfLight'
}
if [ -n "$LIGHT_MODE" ]; then kitty_light_mode; fi

# alias ls to lsd and icat to the plugin that displays images in the terminal
alias ls='lsd --color=auto'
alias icat='kitty +kitten icat'

# remove the -F from the 'l' alias, as lsd already has file type indicators
alias l='ls'
