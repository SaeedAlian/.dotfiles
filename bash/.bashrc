######## bashrc ########

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

######## source env functions ########

. "$HOME/.dotfiles/coreconfig/check_container.sh"

if in_container; then
  set -a
  . "$HOME/.dotfiles/coreconfig/load_all_and_require.sh"
  set +a

  load_all_and_require true
fi

######## options ########
set -o vi               # vi mode
set -o ignoreeof        # force use exit
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control

######## history ########
shopt -s histappend                                # append to history file
shopt -s cmdhist                                   # save multi-line commands in history as single line
export HISTCONTROL="ignoredups:erasedups"          # no duplicate entries
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND" # makes history immediately write the current/new lines to the history file

######## launch x server ########
if ! in_container && [[ "$(tty)" = "/dev/tty1" ]]; then
  startx "$XINITRC"
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

######## aliases ########
alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias bashsrc="source $HOME/.bashrc"

alias gettemp="paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/'"

alias h="htop"
alias v="${EDITOR:-vim}"
alias v.="${EDITOR:-vim} ."
alias fm="${FILEMANAGER:-thunar}"

alias ex="arextract"
alias bcd="bettercd"
alias wlp="wallpaper"
alias orgtel="file_organizer $HOME/downloads/telegram"
alias orgdown="file_organizer $HOME/downloads"
alias mkpj="mkdoc project"
alias mknt="mkdoc note"
alias mkwrk="mkdoc work"
alias mkstu="mkdoc study"
alias upmu="update_music"
alias hs="bash_hsearch max"

alias fastfetch="fastfetch -l ${FAST_FETCH_LOGO:-artix_small}"
alias neofetch="fastfetch"

alias pac="sudo pacman"

alias rv="sudo bash -c '${VPN:?VPN is not set} &'"

alias pandoc="dc-pandoc pandoc"
alias md2pdf="dc-pandoc md2pdf"
alias pdflatex="dc-texlive pdflatex"
alias xelatex="dc-texlive xelatex"
alias typst="dc-typst typst"
alias typcomp="dc-typst typst compile"

######## prompt ########

parse_git_dirty() {
  STATUS="$(git status 2>/dev/null)" || {
    printf ""
    return
  }
  echo "$STATUS" | grep -q "tree clean" && {
    printf ""
    return
  }

  flags=""
  echo "$STATUS" | grep -q "renamed:" && flags="${flags}r"
  echo "$STATUS" | grep -q "branch is ahead:" && flags="${flags}!"
  echo "$STATUS" | grep -q "new file:" && flags="${flags}n"
  echo "$STATUS" | grep -q "Untracked files:" && flags="${flags}u"
  echo "$STATUS" | grep -q "modified:" && flags="${flags}m"
  echo "$STATUS" | grep -q "deleted:" && flags="${flags}d"

  [ -n "$flags" ] && printf " (%s)" "$flags"
}

parse_git_branch() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed -e 's/.*\/\(.*\)/\1/')
  [ -n "$BRANCH" ] && printf " (%s)" "$BRANCH"
}

parse_logo() {
  OS="$(sed -n 's/^NAME="\?\([^"]*\)"\?$/\1/p' /etc/os-release | head -n1)"

  case "$OS" in
  *Fedora*) printf " 󰣛 " ;;
  *Artix*) printf "  " ;;
  *Devuan*) printf "  " ;;
  *Arch*) printf " 󰣇 " ;;
  *Void*) printf "  " ;;
  *) printf " 󰌽 " ;;
  esac
}

parse_container_flag() {
  in_container && printf "(cont)"
}

PS1="\[\033[1;34m\]\$(parse_logo)\[\e[1;34m\]\$(parse_container_flag)\[\e[1;37m\] \W\[\e[1;32m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\[\e[1;34m\] \[\e[1;34m\] \[\033[00m\]"
