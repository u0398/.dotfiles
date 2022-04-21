 # ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Mount Google Drive
if [ -d "$HOME/Google Drive" ] ; then
    if ! [ 'mount | grep "Google Drive"' ]; then
        google-drive-ocamlfuse ~/Google\ Drive
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's .bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# set PATH so it includes homebrew if it exists
if [ -d "/home/linuxbrew" ] ; then
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

