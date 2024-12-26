# home dir path variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export VOLTA_HOME="$HOME/.volta"

# launch xserver
if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx "$XDG_CONFIG_HOME/X11/xinitrc"
fi

# default apps
export EDITOR="nvim"
export VPN="hiddify"
export TERMINAL="alacritty"
export BROWSER="librewolf"
export FILEMANAGER="pcmanfm-qt"
export CALCULATOR="qalculate-qt"

# init cargo env
. "$HOME/.cargo/env"

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
export PATH="$PATH:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/go/bin:$VOLTA_HOME/bin"

# path to oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"

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
alias mdp="markdown_preview"
alias note="dnote"
alias cdnote="cd $HOME/documents/notes"
alias fm="pcmanfm-qt"
alias v="nvim"
alias wlp="wallpaper"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias upmu="update_music"
alias mkpj="mkproject"
alias neofetch="neofetch --ascii_distro Fedora_old"
alias fastfetch="fastfetch -l fedora-old"
alias ftch="fastfetch"
alias zh="shell_history_search"
alias zhm="shell_history_search max"

# alias for running vpn as sudo
alias rv="sudo bash -c '$VPN &'"
