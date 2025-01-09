### cache ###

ZSH_CACHE="$HOME/.cache/zsh/"
if [[ ! -d $ZSH_CACHE ]]; then
  mkdir -p $ZSH_CACHE 
fi
ZSH_COMPDUMP="$ZSH_CACHE/.zcompdump-${ZSH_VERSION}"

### options ###
setopt prompt_subst # set prompt subset for parsing functions in prompt
setopt append_history # append rather then overwrite
setopt extended_history # save timestamp
setopt inc_append_history # add history immediately after typing a command

# source env vars
source $HOME/.config/env/env_vars

# source prompt
source $XDG_CONFIG_HOME/zsh/.zprompt

# launch xserver
if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx "$XDG_CONFIG_HOME/X11/xinitrc"
fi

# history file
export SAVEHIST=10000
export HISTFILE="$HOME/.cache/.zsh_history"
export HISTDUP=erase

# set the manpager to nvim
export MANPAGER="nvim +Man!"

# encoding
export LC_ALL=en_US.UTF-8

# ability to change the current working directory when exiting Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# better cd with fzf
function bettercd() {
  s="$(ls -a | fzf --height 50% --reverse)"
  if [ -d "$s" ]; then
    cd "$s"
  elif [ -f "$s" ]; then
    $EDITOR "$s"
  fi
}

# extract archive
function ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *.deb) ar x $1 ;;
    *.tar.xz) tar xf $1 ;;
    *.tar.zst) tar xf $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#### User configuration ####

# set the vi mode in shell
set -o vi

# run tmux session fuzzy finder
bindkey -s ^f "tmux_fzf_session\n"

# run history fuzzy finder
bindkey -s ^h "zsh_hsearch 3000\n"

# run dnote fzf
bindkey -s ^n^n "dnote -f\n"
# run dnote all fzf
bindkey -s ^n^a "dnote -af\n"
# run dnote prompt
bindkey -s ^p "dnote -p\n"

# reverse move in completion menu
bindkey '^[[Z' reverse-menu-complete

### aliases ###

alias zshsrc="source $XDG_CONFIG_HOME/zsh/.zshrc"

alias dot="cd $HOME/.dotfiles && $EDITOR $HOME/.dotfiles --cmd 'cd $HOME/.dotfiles'"
alias cnote="cd $HOME/documents/notes"

alias v="nvim"
alias z="zathura"
alias fm="pcmanfm-qt"

alias bcd="bettercd"
alias wlp="wallpaper"
alias mdp="markdown_preview"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias mkpj="mkproject"
alias upmu="update_music"
alias h="zsh_hsearch"
alias hm="zsh_hsearch max"

alias neofetch="neofetch --ascii_distro Fedora_small"
alias fastfetch="fastfetch -l Fedora_small"

alias rv="sudo bash -c '$VPN &'"

# autoload colors for completion
autoload compinit && compinit -d "$ZSH_COMPDUMP"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={a-za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
