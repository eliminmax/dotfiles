#!/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set up pipx with its own bin directory in $PATH
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$PIPX_HOME/bin"

# set custom $PATH variable - the order here should show my priorities
# also remove /bin from the PATH, as it's a symlink to /usr/bin on my system
clean_path="$(echo "$PATH" | sed 's#:/bin:#:#')"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/pipx/bin:$HOME/.r2env/bin:$clean_path:$HOME/.local/share/flatpak/exports/bin:$HOME/.local/utils/bin"
unset clean_path

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set GOPATH
export GOPATH="$HOME/.go"

# change default less(1) behavior
#
export LESS=-iSRQ

# set preferred editor
export EDITOR="nvim"

# rlwrap history and completion file location
export RLWRAP_HOME="$HOME/.local/share/rlwrap"

# GTK Theming
export GTK_THEME=Materia-dark-compact

# use this file for variables that shouldn't be included in git, like my email (for deb packaging)
[ -e "$HOME/.config/private_environment" ] && . "$HOME/.config/private_environment"
