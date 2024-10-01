# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# default apps
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

# history file
export SAVEHIST=2000
export HISTFILE="$HOME/.zsh_history"

# path variable
export PATH="$PATH:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

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

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

#### User configuration ####

# run tmux session fuzzy finder
bindkey -s ^f "tmux_fzf_session\n"

### aliases ###

# source aliases
alias zshsrc="source $XDG_CONFIG_HOME/zsh/.zshrc"

# edit config aliases
alias zshc="$EDITOR $XDG_CONFIG_HOME/zsh"
alias ohmyzsh="$EDITOR $ZSH"
alias alacrittyc="$EDITOR $XDG_CONFIG_HOME/alacritty"
alias i3c="$EDITOR $XDG_CONFIG_HOME/i3"
alias tmuxc="$EDITOR $XDG_CONFIG_HOME/tmux"
alias nvimc="$EDITOR $XDG_CONFIG_HOME/nvim"
alias picomc="$EDITOR $XDG_CONFIG_HOME/picom"
alias pbarc="$EDITOR $XDG_CONFIG_HOME/polybar"
alias rofic="$EDITOR $XDG_CONFIG_HOME/rofi"
alias scriptedit="$EDITOR $HOME/.local/bin"
alias dot="$EDITOR $HOME/.dotfiles"

alias v="nvim"
alias la="ls -a"
alias lla="ll -a"
alias update="sudo dnf update && sudo dnf upgrade"
alias updatey="sudo dnf update -y && sudo dnf upgrade -y"
alias fo="file_organizer"
alias btop="sudo btop"
alias htop="sudo htop"
alias wlp="wallpaper"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias upmusic="update_music"
alias mkpj="mkproject"
alias cleartmux="tmux_clear_saves"
alias cleartmuxlast="tmux_clear_last_save"
alias zh="shell_history_search"
alias zhm="shell_history_search max"

# alias for running nekoray as sudo
alias rv="sudo ~/vpn/nekoray/launcher"

# alias for running hiddify as sudo
alias rh="sudo bash -c 'hiddify &'"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# setup nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Ability to change the current working directory when exiting Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
