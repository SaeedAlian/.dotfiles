# default apps
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export FILEMANAGER="thunar"
export CALCULATOR="qalculate-qt"

# set cache
ZSH_CACHE="$HOME/.cache/zsh/"

if [[ ! -d $ZSH_CACHE ]]; then
  mkdir -p $ZSH_CACHE 
fi

ZSH_COMPDUMP="$ZSH_CACHE/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# theme
ZSH_THEME="robbyrussell"

# history file
export SAVEHIST=4000
export HISTFILE="$HOME/.zsh_history"
export HISTDUP=erase

# path variable
export PATH="$PATH:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/go/bin"

# path to oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

# home dir path variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# set the manpager to nvim
export MANPAGER="nvim +Man!"

# encoding
export LC_ALL=en_US.UTF-8

# auto update behaviour
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# plugins
plugins=(git)

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# setup nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use # This loads nvm

# Ability to change the current working directory when exiting Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#### User configuration ####

# set the vi mode in shell
set -o vi

# run tmux session fuzzy finder
bindkey -s ^f "tmux_fzf_session\n"

# run history fuzzy finder
bindkey -s ^h "shell_history_search 3000\n"

# run dnote fzf
bindkey -s ^n^n "dnote -f\n"
# run dnote all fzf
bindkey -s ^n^a "dnote -af\n"
# run dnote prompt
bindkey -s ^p "dnote -p\n"

### aliases ###

# source aliases
alias zshsrc="source $XDG_CONFIG_HOME/zsh/.zshrc"

# edit config aliases
alias zshc="$EDITOR $XDG_CONFIG_HOME/zsh --cmd 'cd $XDG_CONFIG_HOME/zsh'"
alias i3c="$EDITOR $XDG_CONFIG_HOME/i3 --cmd 'cd $XDG_CONFIG_HOME/i3'"
alias tmuxc="$EDITOR $XDG_CONFIG_HOME/tmux --cmd 'cd $XDG_CONFIG_HOME/tmux'"
alias nvimc="$EDITOR $XDG_CONFIG_HOME/nvim --cmd 'cd $XDG_CONFIG_HOME/nvim'"
alias picomc="$EDITOR $XDG_CONFIG_HOME/picom --cmd 'cd $XDG_CONFIG_HOME/picom'"
alias pbarc="$EDITOR $XDG_CONFIG_HOME/polybar --cmd 'cd $XDG_CONFIG_HOME/polybar'"
alias dot="$EDITOR $HOME/.dotfiles --cmd 'cd $HOME/.dotfiles'"

alias z="zathura"
alias dn="dnote"
alias df="dnote -f"
alias dfa="dnote -fa"
alias pcfm="pcmanfm-qt"
alias v="nvim"
alias wlp="wallpaper"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias upmu="update_music"
alias mkpj="mkproject"
alias zh="shell_history_search"
alias zhm="shell_history_search max"
alias node='unalias yarn ; unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias yarn ; unalias node ; unalias npm ; nvm use default ; npm $@'
alias yarn='unalias yarn ; unalias node ; unalias npm ; nvm use default ; yarn $@'

# alias for running hiddify as sudo
alias rh="sudo bash -c 'hiddify &'"
