######## bashrc ########

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# source env vars
source $HOME/.config/env/env_vars

# source private env vars
source $HOME/.config/env/private_env_vars

######## vars ########
export TERM="xterm-256color" # getting proper colors
export MANPAGER="nvim +Man!" # set the manpager to nvim
export LC_ALL="en_US.UTF-8"  # encoding

######## options ########
set -o vi               # vi mode
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control

######## history ########
shopt -s histappend                                # append to history file
shopt -s cmdhist                                   # save multi-line commands in history as single line
export HISTCONTROL="ignoredups:erasedups"          # no duplicate entries
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND" # makes history immediately write the current/new lines to the history file
export HISTFILE="$HOME/.cache/.bash_history"       # history file location
export HISTSIZE=10000                              # history file size
export HISTFILESIZE=10000                          # history file size

######## launch x server ########
if [[ "$(tty)" = "/dev/tty1" ]]; then
  startx "$XDG_CONFIG_HOME/X11/xinitrc"
  setxkbmap -layout us,ir -option 'grp:alt_shift_toggle'
  setxkbmap -option caps:none
fi

######## functions ########

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
    xdg-open "$s"
  fi
}

######## binds ########

# colors
bind 'set colored-stats On'
bind 'set colored-completion-prefix On'

# completion
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set completion-ignore-case on'
bind 'set menu-complete-display-prefix on'
bind 'set completion-display-width 500'
bind 'set completion-query-items 1000'

# ^C no longer shows on C-c keypress
bind 'set echo-control-characters off'

# keymaps
bind '"\t":menu-complete'
bind '"\e[Z":menu-complete-backward'
bind '"\C-r":"bettercd\n"'
bind '"\C-f":"tmux_fzf_session\n"'
bind '"\C-l":"clear\n"'
bind '"\C-a":"bash_hsearch 3000\n"'
bind '"\C-o":"fastfetch\n"'
bind '"\C-n\C-n":"dnote file-fzf\n"'
bind '"\C-n\C-d":"dnote dir-fzf\n"'
bind '"\C-p":"dnote prompt\n"'

######## aliases ########
alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias bashsrc="source $HOME/.bashrc"

alias dot="tmux_fzf_session $HOME/.dotfiles"
alias cnote="tmux_fzf_session $HOME/documents/notes"

alias gettemp="paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'"

alias v="nvim"
alias v.="nvim ."
alias z="zathura"
alias h="htop"
alias fm="$FILEMANAGER"

alias ex="arextract"
alias bcd="bettercd"
alias wlp="wallpaper"
alias mdp="markdown_preview"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias mkpj="mkproject"
alias upmu="update_music"
alias hs="bash_hsearch max"

alias fastfetch="fastfetch -l artix_small"
alias neofetch="fastfetch"

alias pac="sudo pacman"

alias rv="sudo bash -c '$VPN &'"

alias pandoc="dc-pandoc pandoc"
alias md2pdf="dc-pandoc md2pdf"
alias pdflatex="dc-texlive pdflatex"
alias xelatex="dc-texlive xelatex"
alias typst="dc-typst typst"
alias typcomp="dc-typst typst compile"

######## prompt ########

parse_git_dirty() {
  STATUS="$(git status 2>/dev/null)"

  if [[ $? -ne 0 ]]; then
    printf ""
    return
  elif echo ${STATUS} | grep -c "tree clean" &>/dev/null; then
    printf ""
    return
  else
    printf " ("
  fi

  if echo ${STATUS} | grep -c "renamed:" &>/dev/null; then printf " r"; else printf ""; fi
  if echo ${STATUS} | grep -c "branch is ahead:" &>/dev/null; then printf " !"; else printf ""; fi
  if echo ${STATUS} | grep -c "new file::" &>/dev/null; then printf " n"; else printf ""; fi
  if echo ${STATUS} | grep -c "Untracked files:" &>/dev/null; then printf " u"; else printf ""; fi
  if echo ${STATUS} | grep -c "modified:" &>/dev/null; then printf " m"; else printf ""; fi
  if echo ${STATUS} | grep -c "deleted:" &>/dev/null; then printf " d"; else printf ""; fi
  printf " )"
}

parse_git_branch() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed -e 's/.*\/\(.*\)/\1/')

  if [[ -z $BRANCH ]]; then
    printf ""
    return
  else
    printf "($BRANCH)"
  fi
}

parse_logo() {
  OS="$(cat /etc/os-release | grep "NAME=" | head -n 1 | sed 's/.*=//' | sed 's/\"//g')"

  case "$OS" in
  *Fedora*)
    echo "󰣛"
    ;;
  *Artix*)
    echo ""
    ;;
  *Arch*)
    echo "󰣇"
    ;;
  *Void*)
    echo ""
    ;;
  *)
    echo "󰌽"
    ;;
  esac
}

PS1="\[\033[1;34m\] \$(parse_logo) \[\e[1;37m\] \W \[\e[1;32m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty) \[\e[1;34m\] \[\033[00m\]"
