if [ "$(tty)" = "/dev/tty1" ] ; then
    exec startx
else
    . "$HOME/.profile"
fi
