# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's .bin if it exists
if [ -d "$HOME/.bin" ] ; then
  PATH="$HOME/.bin:$PATH"
fi

# set PATH so it includes user's local/.bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes homebrew if it exists
if [ -d "$HOME/.linuxbrew" ] ; then
  PATH="$HOME/.linuxbrew/bin:$PATH"
fi

# set PATH so it includes deno if it exists
if [ -d "$HOME/.deno" ] ; then
  PATH="$HOME/.deno/bin:$PATH"
fi

# Mount Google Drive
if [ -d "$HOME/Google Drive" ] ; then
  if ! [ 'mount | grep "Google Drive"' ]; then
    google-drive-ocamlfuse ~/Google\ Drive
  fi
fi

# Load SDKMAN
if [ -d "$HOME/.sdkman" ] ; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Load nvm
if [ -d "$HOME/.nvm" ] ; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  if [ $0 == "/bin/bash" ] ; then # This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi
fi

## EOF
