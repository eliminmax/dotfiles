# Define a function to set up incognito mode
incognito() {
    # if called, but already incognito, stop here with an error message
    # unless force called (i.e. called with 'force' as the first argument)
    if [ "$INCOG_ON" = 'true' ] && ! [ "$1" = 'force' ]; then
        printf '\e[01;93mAlready incognito!\e[m\n' >&2
        return 1
    else
        # replace the prompt with a much shorter visually distinct one
        # this makes it easy to tell at a glance that it's incognito
        PS1='\[\e[0;1m\][\[\e[$(__prompt_prev_exit_color_code)m\]$?\[\e[39m\]] \[\e[1;38;5;245m\]\w\[\e[39m\]\$ \[\e[0m\]'
        # if force called, assume that it's a new session, and
        # load history into memory before unsetting the HISTFILE variable
        # inless it's already unset or empty - in that case, do nothing
        if [ "$1" = 'force' ] && [ -n "$HISTFILE" ]; then history -r; fi
        # unsetting this with discard history when the shell exits
        unset HISTFILE
        # unalias rm if it is aliased to print_rm_warning
        # don't want to send deleted files to the trash
        if [ "$(alias rm)" = $'alias rm=\'print_rm_warning\'' ]; then unalias rm; fi
        # alias nvim to not use any shada file or swap file - leave no trace
        alias nvim='nvim -i NONE -n'
        # make sure that running `vim`, `view`, or `vimdiff` still uses the nvim
        # alias options for incognito mode
        alias vim='nvim'
        alias view='nvim -R'
        alias vimdiff='nvim -d'
        # save a variable so that subshells can see that it's incognito
        export INCOG_ON='true'
        # anything that uses $EDITOR should also use the same flags as nvim
        export EDITOR='nvim -i NONE -n'
        # set the prompt to just be the current directory
        export PROMPT_COMMAND=$'printf \'\\e]0;%s\\007\' "$PWD"'
        # change the umask so that new files are not readable to other users
        umask 0077
    fi
}
# if INCOG_ON variable is set to 'true', force call the incognito function
if [ "$INCOG_ON" = 'true' ]; then
    incognito force
fi

# alias to call the incognito function, because I'm a lazy typist
alias i=incognito

# vi:ft=bash
