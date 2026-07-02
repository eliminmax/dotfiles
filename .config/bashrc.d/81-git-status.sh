git_status_needbreak=0
# print a list of changes that need to be committed to my dotfiles repo
if git -C "$PWD" rev-parse &>/dev/null; then
    toilet --metal -t --font digital -- \
        "$(basename "$(git rev-parse --show-toplevel)")"
    git status
    git_status_needbreak=1
fi

case "$(dotfiles status --porcelain --branch)" in
    '## thinker...github/thinker') : ;; # do nothing, already committed and pushed
    *)
        # show brief human-readable info
        if [ "$git_status_needbreak" -eq 1 ]; then printf '\n\n'; fi
        toilet --gay -t --font digital dotfiles
        dotfiles status
    ;;
esac

unset git_status_needbreak
