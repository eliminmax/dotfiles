# print a list of changes that need to be committed to my dotfiles repo
if git -C "$PWD" rev-parse &>/dev/null; then
    toilet --metal -t --font digital -- \
        "$(basename "$(git rev-parse --show-toplevel)")"
    git status
fi
