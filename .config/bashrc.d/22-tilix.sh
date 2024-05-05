# fix an issue where /etc/profile.d/vte.sh is only sourced in login shells
# and is used to properly set $PROMPT_COMMAND within tilix.
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
    # check if one of the defined functions already exist - if so, stop here.
    if [ "$(type -t __vte_prompt_command)" = 'function' ]; then return 0; fi
    # source the file if not already sourced
    # hide shellcheck warning about not checking the sourced file.
    # shellcheck disable=SC1091
    source /etc/profile.d/vte.sh
fi
