# print a list of changes that need to be committed to my dotfiles repo
case "$(dotfiles status --porcelain --branch)" in
    '## main...origin/main') : ;; # do nothing, already committed and pushed
    *)
        # show brief human-readable info
        toilet --gay -t --font digital dotfiles
        dotfiles status
    ;;
esac

if git -C "$PWD" rev-parse &>/dev/null; then
    toilet --metal -t --font digital -- \
        "$(basename "$(git rev-parse --show-toplevel)")"
    git status
fi
