# exclude certain commands from history if they are too generic or dangerous
# Specifically, it blocks the followig from appearing in bash history:
# * rm with or without arguments
# * anything with a leading backslash to bypass aliases
# * ls and my aliases for it with no arguments
# * clear and my alias for it with no arguments,
# * id with no arguments - I often run it absentmindedly for no reason
# * history and its alias with or without arguments
HISTIGNORE='rm:rm *:\\*:ls:ll:la:l:c:clear:id:history *:h *:history:h'
# vi:ft=bash
