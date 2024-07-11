# u0398's dotfiles

A collection of dotfiles for a number of programs:

- Zsh Shell
- Bash Shell
- tmux Terminal Multiplexer
- nvim Text Editor

Both Bash and Zsh shell configurations include some degree of completion and git support.

## Installation

The dotfiles are intended to be cloned as a bare repository:
```
git clone --bare https://github.com/u0398/dotfiles $HOME/.dotfiles
rm -r ~/.bash* ~/.profile
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --init --recursive --remote
chsh -s /bin/zsh
```
Then use the`dotgit`and`dotlazy`(lazygit) to work with the repository.

## Recommended Packages

- zsh
- lazygit
- neovim
- fzf
