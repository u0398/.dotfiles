# oh-my-zsh Bureau Theme

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}c%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="%{$fg_bold[green]%}=%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}$%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}<%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[red]%}<>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[blue]%}S%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}o%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}%%{$reset_color%}"


_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"
_PATHSHORT="%{$fg_bold[white]%}%2~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[white]%}%n"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}@%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"


_1LEFT="$_USERNAME $_PATH"
_1LEFTSHORT="$_USERNAME $_PATHSHORT"
_1RIGHT="[%*]"

# return the length of two strings
get_length () {
  local STR=$1$2
  local ZERO='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~ZERO/}}
  echo $LENGTH
}

# return a string of n spaces
get_space () {
  local SPACE=`printf ' %.0s' {1..$1}`
  echo $SPACE
}

cyanocitta_precmd () {
  local LENGTH=`get_length $_1LEFT $_1RIGHT`
  if [ $LENGTH -ge $COLUMNS ]; then
    _1LEFT=$_1LEFTSHORT
    LENGTH=`get_length $_1LEFT $_1RIGHT`
  fi

  _1SPACE=`get_space $(($COLUMNS-$LENGTH))`
  _1=$_1LEFT$_1SPACE$_1RIGHT

  print
  print -rP "$_1"
}




setopt prompt_subst
PROMPT='$_LIBERTY '
GIT_PROMPT='$(out=$(git_prompt_info)$(git_prompt_status)$(git_remote_status);if [[ -n $out ]]; then printf %s " $white($green$out$white)$reset";fi)'
RPROMPT="$GIT_PROMPT"



autoload -U add-zsh-hook
add-zsh-hook precmd cyanocitta_precmd
