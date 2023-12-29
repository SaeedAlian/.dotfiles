# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# default apps
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"

# history file
export SAVEHIST=2000
export HISTFILE="$HOME/.zsh_history"

# adds ~/.local/bin and subfolders to $PATH
export PATH="$PATH:$HOME/.local/share/go/bin:${$(find ~/.local/bin -maxdepth 1 -type d -printf %p:)%%:}"

# path to oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# cleaning up home folder
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# encoding
export LC_ALL=en_US.UTF-8

# theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# auto update behaviour
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# run tmux session fuzzy finder
bindkey -s ^f "$HOME/scripts/tmux_fzf_session\n"

# aliases
alias zshc="nvim $XDG_CONFIG_HOME/zsh"
alias zshsrc="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias ohmyzsh="nvim $ZSH"
alias kittc="nvim $XDG_CONFIG_HOME/kitty"
alias i3c="nvim $XDG_CONFIG_HOME/i3"
alias tmuxc="nvim $XDG_CONFIG_HOME/tmux"
alias lfc="nvim $XDG_CONFIG_HOME/lf"
alias vic="nvim $XDG_CONFIG_HOME/nvim"
alias picomc="nvim $XDG_CONFIG_HOME/picom"
alias pbarc="nvim $XDG_CONFIG_HOME/polybar"
alias rofic="nvim $XDG_CONFIG_HOME/rofi"
alias scripted="nvim $HOME/scripts"
alias vi="nvim"
alias la="ls -a"
alias lla="ll -a"
alias slf="sudo lf"
alias fo="$HOME/scripts/file_organizer"
alias upmusic="$HOME/scripts/update_music"
alias icat="kitty +kitten icat"
alias clearmux="$HOME/scripts/tmux_clear_saves"
alias clearmuxlast="$HOME/scripts/tmux_clear_last_save"

# alias for running nekoray as sudo
alias rv="sudo ~/vpn/nekoray/launcher"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
