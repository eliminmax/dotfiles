# exclude certain commands from history if they are too generic or dangerous
# Specifically, it blocks the followig from appearing in bash history:
# * rm with or without arguments
# * anything with a leading backslash to bypass aliases
# * ls and my aliases for it with no arguments
# * clear and my alias for it with no arguments,
# * id with no arguments - I often run it absentmindedly for no reason
# * history and its alias with or without arguments
_histignore_append() {
    # "${HISTIGNORE:+$HISTIGNORE:}$1" expands to "$HISTIGNORE:$1" if HISTIGNORE
    # non-null and non-empty, but just "$1" if HISTIGNORE is null or empty.
    # This is done to avoid an extra leading ":" the first time this is called.
    # For more info, see section "3.5.3 Shell Parameter Expansion" in the Bash
    # Reference Manual:
    # https://www.gnu.org/software/bash/manual/html_node/
    HISTIGNORE="${HISTIGNORE:+$HISTIGNORE:}$1"
}
# to have rm commands in the history - have wiped my $HOME that way in the past
_histignore_append 'rm:rm *'
# backslash-escpaed "rm" - sometimes use to bypass my "rm" safeguard alias
_histignore_append '\\rm *'
# commands I run habitually saved - those would add pointless noise
_histignore_append 'ls:ll:la:l:c:clear:id'
# commands that view or edit history in history themselves
_histignore_append 'history *:h *:history:h:history|*:h|*'
# don't want job control "fg" and "bg" on their own in history
_histignore_append "[fb]g"
# don't want to accidentally wipe trash all the time
_histignore_append 'trash-empty'
# vi:ft=bash
