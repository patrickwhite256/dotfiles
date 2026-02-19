# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### configure plugins

SP_PROJECT_DIRS=(~/workspace:1 ~/workspaces:1)

### zgen config
local DOTFILES_DIR=$(dirname $(dirname $(readlink $HOME/.bashrc)))

ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc ${HOME}/.zshrc.local)

source $HOME/.zgen/zgen.zsh

if ! zgen saved; then
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/zsh-interactive-cd

    zgen load $DOTFILES_DIR/zsh/web-search
    zgen load $DOTFILES_DIR/zsh/dotfile-check
    zgen load $DOTFILES_DIR/zsh/is
    zgen load $DOTFILES_DIR/zsh/switch-project
    zgen load $DOTFILES_DIR/zsh/change-terraform
    zgen load $DOTFILES_DIR/zsh/parse-token

    zgen load romkatv/powerlevel10k powerlevel10k

    zgen save
fi

### configure powerlevel10k

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### general config

bindkey -s '^p' 'vim +CtrlP\n'

if [[ -s $HOME/bin/vim ]]; then
    export EDITOR=$HOME/bin/vim
else
    export EDITOR=vim
fi

source ~/.zsh_aliases
if [ -e $HOME/.zshrc.local ]; then 
    source $HOME/.zshrc.local
fi

export GOPATH=$HOME/go
export PATH=$HOME/bin:/usr/local/bin:$PATH:$GOPATH/bin
eval "$(direnv hook zsh)"

export AWS_EC2_METADATA_DISABLED=true


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
