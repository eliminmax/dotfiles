#!/bin/sh
. /etc/X11/Xsession
printf '%s\n' "$*" > ~/Desktop/xinitrc-args

if [ "$(tty)" = /dev/tty1 ]; then
    exec startxfce4 >~/.xsession-errors 2>&1
fi
