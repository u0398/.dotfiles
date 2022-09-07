# Use a color terminal
export TERM='xterm-256color'

export EDITOR='/bin/nvim'

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

## Functions

# List all occurrences of programm in current PATH
plap() {
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
lcheck() {
    if [[ -n "$1" ]] ; then
        nm -go /usr/lib/lib*.a 2>/dev/null | grep ":[[:xdigit:]]\{8\} . .*$1"
    else
        echo "Usage: lcheck <function>" >&2
    fi
}

# Download a file and display it locally
uopen() {
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
memusage() {
    ps aux | awk '{if (NR > 1) print $5;
                   if (NR > 2) print "+"}
                   END { print "p" }' | dc
}

# print hex value of a number
hex() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%x\n" $1
    else
        print 'Usage: hex <number-to-convert>'
        return 1
    fi
}

docker-clean-images() {
    # If there are dangling docker images, remove them
  if [[ $(docker images -a --filter=dangling=true -q) ]];
    then
    tput setaf 3; docker rmi $(docker images -a --filter=dangling=true -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no dangling images.\n"
    fi
}

docker-clean-ps() {
    # If there are stopped containers, remove them
  if [[ $(docker ps --filter=status=exited --filter=status=created -q) ]];
    then
    tput setaf 3; docker rm $(docker ps --filter=status=exited --filter=status=created -q) ; tput setaf 9
    else
        printf "\033[0;31mThere are no stopped containers.\n"
    fi
}

dfs() {
    df $* | sed -n '1p;/^\//p;'
}

# creates an alias and precedes the command with sudo if $EUID is not zero.
salias() {
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
xcat() {
  emulate -L zsh
  if (( ${#argv} != 1 )) ; then
    printf 'usage: xcat FILE\n' >&2
    return 1
  fi

  [[ -r $1 ]] && cat $1
  return 0
}

# start timer
preexec() {
  timer=${timer:-$SECONDS}
}

# calculate execution time
precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export EXECUTETIME="%F{238}${timer_show}s"
    unset timer
  fi
}

# Sets GITSTATUS_PROMPT to reflect the state of the current git repository. Empty if not
# in a git repository. In addition, sets GITSTATUS_PROMPT_LEN to the number of columns
# $GITSTATUS_PROMPT will occupy when printed.
function gitstatus_prompt_update() {
  emulate -L zsh
  typeset -g  GITSTATUS_PROMPT=''
  typeset -gi GITSTATUS_PROMPT_LEN=0

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  local      clean='%2F'   # green foreground
  local   modified='%3F'  # yellow foreground
  local  untracked='%4F'   # blue foreground
  local conflicted='%1F'  # red foreground

  local p

  local where  # branch name, tag or commit
  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    where=$VCS_STATUS_LOCAL_BRANCH
  elif [[ -n $VCS_STATUS_TAG ]]; then
    p+='%f#'
    where=$VCS_STATUS_TAG
  else
    p+='%f@'
    where=${VCS_STATUS_COMMIT[1,8]}
  fi

  (( $#where > 32 )) && where[13,-13]="…"  # truncate long branch names and tags
  p+="${clean}${where//\%/%%}"             # escape %

  # ⇣42 if behind the remote.
  (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
  # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
  (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
  (( VCS_STATUS_COMMITS_AHEAD  )) && p+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
  # ⇠42 if behind the push remote.
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
  (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  # *42 if have stashes.
  (( VCS_STATUS_STASHES        )) && p+=" ${clean}*${VCS_STATUS_STASHES}"
  # 'merge' if the repo is in an unusual state.
  [[ -n $VCS_STATUS_ACTION     ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
  # ~42 if have merge conflicts.
  (( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
  # +42 if have staged changes.
  (( VCS_STATUS_NUM_STAGED     )) && p+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
  # !42 if have unstaged changes.
  (( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
  # ?42 if have untracked files. It's really a question mark, your font isn't broken.
  (( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"

  GITSTATUS_PROMPT="${p}%f"

  # The length of GITSTATUS_PROMPT after removing %f and %F.
  GITSTATUS_PROMPT_LEN="${(m)#${${GITSTATUS_PROMPT//\%\%/x}//\%(f|<->F)}}"
  
  GITSTATUS_PROMPT="%F{243}($GITSTATUS_PROMPT%F{243})"
  GITSTATUS_PROMPT_LEN+=2
}


# ohmyzsh functions
# ------------------------------------------------------------------------------
# * Oh My Zsh functions - https://github.com/ohmyzsh/

top20() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

takedir() {
  mkdir -p $@ && cd ${@:$#}
}

takeurl() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeurl "$1"
  elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
    takegit "$1"
  else
    takedir "$@"
  fi
}
# ------------------------------------------------------------------------------

gco() {
  str="$*"
  git commit -m "$str"
}

lsl() {
  str="$*"
  ls --color=always $str | less -R
}

lal() {
  str="$*"
  ls -CFa --color=always $str | less -R
}

lll() {
  str="$*"
  ls -lF --color=always $str | less -R
}

llal() {
  str=""$*
  ls -lFa --color=always $str | less -R
}



## Set important settings &options early

xsource /etc/default/locale

# enable parameter expansion, command substitution and arithmetic expansion in prompts
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

# History file settings
HISTFILE=~/.histfile
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=3000
SAVEHIST=10000

## Key bindings

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
bindkey '^ ' autosuggest-accept
zle -N autosuggest-execute
bindkey '^\' autosuggest-execute

# fix some other binds
bindkey "^[f" forward-word
bindkey "^[b" backward-word
bindkey "^K" kill-line
bindkey "^E" end-of-line
bindkey "^O" accept-line-and-down-history

## use the vi navigation keys (hjkl) besides cursor keys in menu completion
#bindkey -M menuselect 'h' vi-backward-char        # left
#bindkey -M menuselect 'k' vi-up-line-or-history   # up
#bindkey -M menuselect 'l' vi-forward-char         # right
#bindkey -M menuselect 'j' vi-down-line-or-history # bottom

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

# Prompt

NEWLINE=$'\n'

GIT_PS1_SHOWDIRTYSTATE=yes

PROMPT_COLOR="%F{10}"
PROMPT_ERROR="%F{9}"

# remote connections show host
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  PROMPT='%(!.%F{9}.$PROMPT_COLOR)%n%F{15}@%F{7}%m %F{243}'
else
  PROMPT='%(!.%F{9}.$PROMPT_COLOR)%n%F{15} %F{243}'
fi

#PROMPT+='${GITSTATUS_PROMPT:+ $GITSTATUS_PROMPT}'
PROMPT+='$GITSTATUS_PROMPT'

PROMPT+='${NEWLINE}%F{7}%0~%f%b %(?.$PROMPT_COLOR.$PROMPT_ERROR)%#%F{7} '

# Only show date/time on wide terminals
if [ $(tput cols) -lt 96 ]; then
  RPROMPT='%(?..$PROMPT_ERROR%? %F{243}- )${EXECUTETIME}'
else
  RPROMPT='%(?..$PROMPT_ERROR%? %F{243}- )${EXECUTETIME} %F{243}- %D{%a %b %d %H:%M:%S}'
fi

PROMPT_SUF='${NEWLINE}%F{7}%0~%f%b %(?.$PROMPT_COLOR.$PROMPT_ERROR)%#%F{7} '

# insert git status if repo
#PROMPT=$PROMPT_PRE'$(git branch &>/dev/null;\
#if [ $? -eq 0 ]; then \
#  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
#  if [ "$?" -eq "0" ]; then \
#    echo "%F{28}"$(__git_ps1 " (%s)"); \
#  else \
#    echo "%F{1}"$(__git_ps1 " (%s)"); \
#  fi) '$PROMPT_SUF'"; \
#else \
#  echo " '$PROMPT_SUF'"; \
#fi)'

## aliases ##

alias less='less -R'

alias ls='ls -CF --color=always'
alias ll='ls -lF'
alias lla='ll -a'
alias la='ls -CFa'
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

alias gst='git status'
alias gad='git add'
alias gbr='git branch'
#alias gco (see gco function)
alias gdf='git diff'
alias gck='git checkout'
alias glo='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --max-count=40'
alias gps='git push'
alias gpl='git pull'

alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotlazy='/usr/local/bin/lazygit -w $HOME -g $HOME/.dotfiles'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

alias fzf='fzf --preview-window "top:50%:nohidden" --preview "batcat --style numbers,changes --color=always {} | head -500"'

alias vf='v $(fzf)'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && (echo terminal; exit 0) || (echo error; exit 1))" "$([ $? = 0 ] && echo Task finished || echo Something went wrong!)" "$(history | sed -n "\$s/^\s*[0-9]\+\s*\(.*\)[;&|]\s*alert\$/\1/p")"'

## global aliases (for those who like them) ##

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


# Systemd aliases
# ------------------------------------------------------------------------------
# * Oh My Zsh systemd plugin - https://github.com/ohmyzsh/

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
# ------------------------------------------------------------------------------

# sudo or sudo -e (replacement for sudoedit) will be inserted before the command
# ------------------------------------------------------------------------------
# * Dongweiming <ciici123@gmail.com>
# * Subhaditya Nath <github.com/subnut>
# * Marc Cornellà <github.com/mcornella>
# * Carlo Sala <carlosalag@protonmail.com>

__sudo-replace-buffer() {
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

sudo-command-line() {
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

zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
# ------------------------------------------------------------------------------

## miscellaneous code ##

# Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

# Set a search path for the cd builtin
cdpath=(.. ~)

## tmux autoload ##

# if remote connection
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # if tmux is installed, attach to the main session, or create it
  if [ `command -v tmux` > /dev/null ]; then
    if [ ! "$TMUX" ]; then
      tmux -2 attach -t main || tmux -2 new -s main
    fi
  fi
fi

## gitprompt setup

GITSTATUS_DIR=~/.config/zsh/gitstatus
source $GITSTATUS_DIR/gitstatus.plugin.zsh # xsource not working

# Start gitstatusd instance with name "MY". The same name is passed to
# gitstatus_query in gitstatus_prompt_update. The flags with -1 as values
# enable staged, unstaged, conflicted and untracked counters.
gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

# On every prompt, fetch git status and set GITSTATUS_PROMPT.
autoload -Uz add-zsh-hook
add-zsh-hook precmd gitstatus_prompt_update

## git completion setup

zstyle ':completion:*:*:git:*' script ~/.config/git-completion.bash
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' prompt '1'

# provides '.' completion
zstyle ':completion:*' special-dirs true

zstyle :compinstall filename '/home/peterm/.zshrc'

# add custom functions to fpath
fpath=(~/.config/zsh/functions $fpath)

# enable completion system
autoload -Uz compinit && compinit

## dotbare plugin

export DOTBARE_DIR="$HOME/.dotfiles"
export DOTBARE_TREE="$HOME"
xsource ~/.dotbare/dotbare.plugin.zsh

## zsh-completions plugin

fpath=(~/.config/zsh/zsh-completions/src $fpath)

## dirhistory plugin

xsource ~/.config/zsh/dirhistory.plugin.zsh

xsource ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## zsh-autosuggestions plugin
xsource ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30

xsource ~/.config/profile.sh

## EOF
