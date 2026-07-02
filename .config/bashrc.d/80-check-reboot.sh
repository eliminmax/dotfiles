# Print a yellow note that a reboot is required if it is, in fact, required.
test -f /var/run/reboot-required && \
    printf '\e[1;33mNOTE:\e[22m reboot required!\e[m\n'
