# print a list of changes that need to be committed to my dotfiles repo
case "$(dotfiles status --porcelain --branch)" in
    '## main...origin/main') : ;; # do nothing, already committed and pushed
    *) dotfiles status --short --branch ;; # show brief human-readable info
esac
