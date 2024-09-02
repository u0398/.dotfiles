# Early setup {{{1

export TERM='xterm-256color' # Use a color terminal
export EDITOR='/bin/nvim'    # Default editor

# Exit if non-interactive
case $- in
  *i*) ;;
    *) return;;
esac

# Settings for umask
if (( EUID == 0 )); then
    umask 002
else
    umask 022
fi

# History file settings
HISTFILE=~/.histfile
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=3000
SAVEHIST=10000

# Set terminal title
printf "\033];%s\07\n" "$USER@$(hostname)"

# Options {{{1

source /etc/default/locale    #load important settings &options early

# enable parameter expansion, command substitution and arithmetic expansion
setopt prompt_subst

# expand certain escape sequences starting with `%'
setopt prompt_percent

# disable replacing '!' in the prompt by the current history event number
setopt no_prompt_bang

# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history

# import new commands from the history file also in other zsh-session
setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob

# display PID when suspending processes as well
setopt longlistjobs

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt completeinword

# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# don't error out when unset parameters are used
setopt unset

# add `|' to output redirections in the history
setopt histallowclobber

# try to avoid the 'zsh: no matches found...'
setopt nonomatch

# warning if file exists ('cat /dev/null > ~/.zshrc')
setopt NO_clobber

# don't warn me about bg processes when exiting
#setopt nocheckjobs

# alert me if something failed
#setopt printexitvalue

# Allow comments even in interactive shells
setopt interactivecomments

# if a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups

# do not auto remove /'s
unsetopt AUTO_REMOVE_SLASH

# Functions {{{1

# Assorted utility funcitons {{{2

# List all occurrences of programm in current PATH
function plap() {
    emulate -L zsh
    if [[ $# = 0 ]] ; then
        echo "Usage:    $0 program"
        echo "Example:  $0 zsh"
        echo "Lists all occurrences of program in the current PATH."
    else
        ls -l ${^path}/*$1*(*N)
    fi
}

# Find out which libs define a symbol
function lcheck() {
    if [[ -n "$1" ]] ; then
        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
    else
        echo "Usage: lcheck <function>" >&2
    fi
}

# Download a file and display it locally
function uopen() {
    emulate -L zsh
    if ! [[ -n "$1" ]] ; then
        print "Usage: uopen \$URL/\$file">&2
        return 1
    else
        FILE=$1
        MIME=$(curl --head $FILE | \
               grep Content-Type | \
               cut -d ' ' -f 2 | \
               cut -d\; -f 1)
        MIME=${MIME%$'\r'}
        curl $FILE | see ${MIME}:-
    fi
}

# Memory overview
function memusage() {
    ps aux | awk '{if (NR > 1) print $5;
                   if (NR > 2) print "+"}
                   END { print "p" }' | dc
}

# print hex value of a number
function hex() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%x\n" $1
    else
        print 'Usage: hex <number-to-convert>'
        return 1
    fi
}

# list physical devices
function dfs() {
    df $* | sed -n '1p;/^\//p;'
}

# fuzzy explorer
# extending Phantas0's work (https://thevaluable.dev/practical-guide-fzf-example/)
function fex() {
  local selection=$(find -type d | fzf --multi --print0 \
  --preview='tree -C {}' \
  --prompt='   ' \
  --bind='del:execute(rm -ri {+})' \
  --bind='ctrl-p:toggle-preview' \
  --bind='ctrl-d:change-prompt(   )' \
  --bind='ctrl-d:+reload(find -type d)' \
  --bind='ctrl-d:+change-preview(tree -C {})' \
  --bind='ctrl-d:+refresh-preview' \
  --bind='ctrl-f:change-prompt(   )' \
  --bind='ctrl-f:+reload(find -type f)' \
  --bind='ctrl-f:+change-preview(batcat --style numbers,changes --color=always {} | head -500)' \
  --bind='ctrl-f:+refresh-preview' \
  --bind='ctrl-a:select-all' \
  --bind='ctrl-x:deselect-all' \
  --border-label ' fzf Explorer ' \
  --header ' CTRL-D (directories) CTRL-F (files)
 CTRL-A (select all) CTRL-X (deselect) 
 CTRL-P (toggle preview) DEL (delete)' 
  )

  # if no selection made do nothing
  if [ -z "$selection" ]; then
    return 0
  fi

  # if selection is a folder (with multiples go to the first)
  if [ -d "$(echo $selection | sed 's/\x0.*$//')" ]; then
    cd "$selection" || exit
  else
    # supports multiple selections
    eval $EDITOR $(echo $selection |sed -e 's/\x00/ /g')
  fi
}

# Docker Functions {{{2

function docker-clean-images() {
  # If there are dangling docker images, remove them
  if [[ $(docker images -a --filter=dangling=true -q) ]]; then
    tput setaf 3; docker rmi $(docker images -a --filter=dangling=true -q) ; tput setaf 9
  else
    printf "\033[0;31mThere are no dangling images.\n"
  fi
}

function docker-clean-ps() {
  # If there are stopped containers, remove them
  if [[ $(docker ps --filter=status=exited --filter=status=created -q) ]]; then
    tput setaf 3; docker rm $(docker ps --filter=status=exited --filter=status=created -q) ; tput setaf 9
  else
    printf "\033[0;31mThere are no stopped containers.\n"
  fi
}

# X Functions (fail gracefully) {{{2

# Check if we can read given files and source those we can.
function xsource () {
  if (( ${#argv} < 1 )) ; then
    printf 'usage: xsource FILE(s)...\n' >&2
    return 1
  fi

  while (( ${#argv} > 0 )) ; do
    [[ -r "$1" ]] && source "$1"
    shift
  done
  return 0
}

# Check if we can read a given file and 'cat(1)' it.
function xcat() {
  emulate -L zsh
  if (( ${#argv} != 1 )) ; then
    printf 'usage: xcat FILE\n' >&2
    return 1
  fi

  [[ -r $1 ]] && cat $1
  return 0
}

# Oh My Zsh Functions {{{2
# https://github.com/ohmyzsh/

function top20() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

function takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}

# Git Functions {{{2

function gco() {
  str="$*"
  git commit -m "$str"
}

function dco() {
  str="$*"
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m "$str"
}

# List Functions {{{2

function lsl() {
  str="$*"
  ls --color=always $str | less -R
}

function lal() {
  str="$*"
  ls -CFa --color=always $str | less -R
}

function lll() {
  str="$*"
  ls -lF --color=always $str | less -R
}

function llal() {
  str=""$*
  ls -lFa --color=always $str | less -R
}

## SUDO Functions {{2

# creates an alias and precedes the command with sudo if $EUID is not zero.
function salias() {
  emulate -L zsh
  local only=0 ; local multi=0
  local key val
  while getopts ":hao" opt; do
    case $opt in
      o) only=1 ;;
      a) multi=1 ;;
      h)
        printf 'usage: salias [-hoa] <alias-expression>\n'
        printf '  -h      shows this help text.\n'
        printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
        printf '          be careful using this option.\n'
        printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
        return 0
        ;;
      *) salias -h >&2; return 1 ;;
    esac
  done
  shift "$((OPTIND-1))"

  if (( ${#argv} > 1 )) ; then
    printf 'Too many arguments %s\n' "${#argv}"
    return 1
  fi

  key="${1%%\=*}" ;  val="${1#*\=}"
  if (( EUID == 0 )) && (( only == 0 )); then
    alias -- "${key}=${val}"
  elif (( EUID > 0 )) ; then
    (( multi > 0 )) && val="${val// ; / ; sudo }"
    alias -- "${key}=sudo ${val}"
  fi

  return 0
}

# sudo or sudo -e (replacement for sudoedit) will be inserted before the command
# authors: Dongweiming <ciici123@gmail.com>, Subhaditya Nath <github.com/subnut>,
#          Marc Cornellà <github.com/mcornella>, Carlo Sala <carlosalag@protonmail.com>

# sudo-command-line helper function 
function __sudo-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

# prepend sudo to command or last command 
function sudo-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

    # If $EDITOR is not set, just toggle the sudo prefix on and off
    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "" ;;
        sudo\ *) __sudo-replace-buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      __sudo-replace-buffer "$cmd" "sudo -e"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __sudo-replace-buffer "$editorcmd" "sudo -e" ;;
      \$EDITOR\ *) __sudo-replace-buffer '$EDITOR' "sudo -e" ;;
      sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "$EDITOR" ;;
      sudo\ *) __sudo-replace-buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle redisplay
  }
}

# Key Bindings {{{1

# sudo prepend bindings
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line

# use vi mode binds
bindkey -v

# bind up/down arrows to search history
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward

# disable terminal freeze/unfreeze behavior
stty -ixon

# bind forward search history to ctrl-t
zle -N forward-search-history
bindkey "^T" forward-search-history

# bind beginning of line to ctrl-s
bindkey "^S" beginning-of-line

# autosuggest
zle -N autosuggest-accept
bindkey '^]' autosuggest-accept
zle -N autosuggest-execute
bindkey '^\' autosuggest-execute

# fix some other binds
bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey "^K" kill-line
bindkey "^E" end-of-line
bindkey "^O" accept-line-and-down-history

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char        # left
bindkey -M menuselect 'k' vi-up-line-or-history   # up
bindkey -M menuselect 'l' vi-forward-char         # right
bindkey -M menuselect 'j' vi-down-line-or-history # bottom

## set command prediction from history, see 'man 1 zshcontrib'
#is4 && zrcautoload predict-on && \
#zle -N predict-on         && \
#zle -N predict-off        && \
#bindkey "^X^Z" predict-on && \
#bindkey "^Z" predict-off

## define word separators (for stuff like backward-word, forward-word, backward-kill-word,..)
#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' # the default
#WORDCHARS=.
#WORDCHARS='*?_[]~=&;!#$%^(){}'
#WORDCHARS='${WORDCHARS:s@/@}'

#bindkey '\eq' push-line-or-edit

# Aliases {{{1

alias less='less -R'

alias ls='ls -CF --color=always'
alias lsa='ls -CFa'
alias ll='ls -lF'
alias lla='ll -a'
#alias lsl (see lsl function)
#alias lal (see lal function)
#alias lll (see lll function)
#alias llal (see llal function)
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias fhere='find . -name '
alias fd='fdfind'
alias df='df -Tha --total'
alias du='du -ch'
alias dus='du | sort -h'
alias dul='dus | less'
alias free='free -mt'
alias ps='ps auxf'
alias psl='ps | less'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias mkdir='mkdir -pv'
alias histg='history | grep'
alias x='exit'
alias clr='clear'
alias sudo='sudo '

alias cmx='cmatrix -ab -u 3'

alias bat='batcat'

alias fzf='fzf --height=80% --reverse --preview-window "right:70%:nohidden" --bind="ctrl-p:toggle-preview" --preview "batcat --style numbers,changes --color=always {} | head -500"'
alias vf='v $(find . -type f | fzf)'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && (echo terminal; exit 0) || (echo error; exit 1))" "$([ $? = 0 ] && echo Task finished || echo Something went wrong!)" "$(history | sed -n "\$s/^\s*[0-9]\+\s*\(.*\)[;&|]\s*alert\$/\1/p")"'

## Git Aliases {{{2

alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/'
alias dotlazy='/usr/local/bin/lazygit -g $HOME/.dotfiles'

#dotgit shortcuts
alias dst='dotgit status'
alias dad='dotgit add'
alias dbr='dotgit branch'
#alias dco (add un-commented string to commit. see dco function)
alias ddf='dotgit diff'
alias dck='dotgit checkout'
alias dlo='dotgit log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --max-count=40'
alias dps='dotgit push'
alias dpl='dotgit pull'

#git shortcuts
alias gst='git status'
alias gad='git add'
alias gbr='git branch'
#alias gco (add un-commented string to commit. see gco function)
alias gdf='git diff'
alias gck='git checkout'
alias glo='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --max-count=40'
alias gps='git push'
alias gpl='git pull'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

## global aliases (for those who like them) {{{2

#alias -g '...'='../..'
#alias -g '....'='../../..'
#alias -g BG='& exit'
#alias -g C='|wc -l'
#alias -g G='|grep'
#alias -g H='|head'
#alias -g Hl=' --help |& less -r'
#alias -g K='|keep'
#alias -g L='|less'
#alias -g LL='|& less -r'
#alias -g M='|most'
#alias -g N='&>/dev/null'
#alias -g R='| tr A-z N-za-m'
#alias -g SL='| sort | less'
#alias -g S='| sort'
#alias -g T='|tail'
#alias -g V='| vim -'


## Systemd Aliases {{{2
# source: Oh My Zsh systemd plugin - https://github.com/ohmyzsh/

user_commands=(
  cat
  get-default
  help
  is-active
  is-enabled
  is-failed
  is-system-running
  list-dependencies
  list-jobs
  list-sockets
  list-timers
  list-unit-files
  list-units
  show
  show-environment
  status
)

sudo_commands=(
  add-requires
  add-wants
  cancel
  daemon-reexec
  daemon-reload
  default
  disable
  edit
  emergency
  enable
  halt
  import-environment
  isolate
  kexec
  kill
  link
  list-machines
  load
  mask
  preset
  preset-all
  reenable
  reload
  reload-or-restart
  reset-failed
  rescue
  restart
  revert
  set-default
  set-environment
  set-property
  start
  stop
  switch-root
  try-reload-or-restart
  try-restart
  unmask
  unset-environment
)

power_commands=(
  hibernate
  hybrid-sleep
  poweroff
  reboot
  suspend
)

for c in $user_commands; do
  alias "sc-$c"="systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $sudo_commands; do
  alias "sc-$c"="sudo systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $power_commands; do
  alias "sc-$c"="systemctl $c"
done

unset c user_commands sudo_commands power_commands

# --now commands
alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

alias scu-enable-now="scu-enable --now"
alias scu-disable-now="scu-disable --now"
alias scu-mask-now="scu-mask --now"

## miscellaneous code

# Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

# Set a search path for the cd builtin
cdpath=(.. ~)

# Plugins & Sourcing {{{1

# git completion
zstyle ':completion:*:*:git:*' script ~/.config/git-completion.bash
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' prompt '1'

# provides '.' completion
zstyle ':completion:*' special-dirs true

zstyle :compinstall filename '/$HOME/.zshrc'

# add custom functions to fpath
fpath=(~/.config/zsh/functions $fpath)

# enable completion system
autoload -Uz compinit && compinit

# zsh-completions plugin
fpath=(~/.config/zsh/zsh-completions/src $fpath)

# dirhistory plugin
xsource ~/.config/zsh/dirhistory.plugin.zsh

# syntax highlighting plugin 
xsource ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions plugin
xsource ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30

# fzf plugin

xsource <(~/.config/fzf/bin/fzf --zsh)
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#b8c0e0,fg+:#cad3f5,bg:#24273a,bg+:#363a4f
  --color=hl:#ed8796,hl+:#7dc4e4,info:#c6a0f6,marker:#91d7e3
  --color=prompt:#d7005f,spinner:#7dc4e4,pointer:#7dc4e4,header:#ed8796
  --color=gutter:#1e2030,border:#6e738d,separator:#494d64,scrollbar:#494d64
  --color=preview-label:#c6a0f6,label:#c6a0f6,query:#b8c0e0
  --border="rounded" --border-label-pos="0" --preview-window="border-rounded"
  --prompt=" " --marker="" --pointer=" " --separator="─"
  --scrollbar="│"'
# profile
xsource ~/.config/profile.sh

# oh-my-posh prompt
eval "$(~/.local/bin/oh-my-posh init zsh --config ~/.config/zsh/catppuccin.omp.json)"

## EOF
