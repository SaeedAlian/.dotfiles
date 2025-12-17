#!/bin/sh

use_zsh=0
use_bash=1
use_i3=0
use_bspwm=1
use_alacritty=1

while [ $# -gt 0 ]; do
  case $1 in
  --shell)
    use_zsh=0
    use_bash=0
    shift 1
    if [ "$1" == "zsh" ]; then
      use_zsh=1
    elif [ "$1" == "bash" ]; then
      use_bash=1
    else
      echo "Wrong shell entered" >&2
      exit 1
    fi
    ;;
  --wm)
    use_bspwm=0
    use_i3=0
    shift 1
    if [ "$1" == "bspwm" ]; then
      use_bspwm=1
    elif [ "$1" == "i3" ]; then
      use_i3=1
    else
      echo "Wrong wm entered" >&2
      exit 1
    fi
    ;;
  --terminal)
    use_alacritty=0
    shift 1
    if [ "$1" == "alacritty" ]; then
      use_alacritty=1
    else
      echo "Wrong terminal entered" >&2
      exit 1
    fi
    ;;
  *)
    echo "Wrong option $1" >&2
    exit 1
    ;;
  esac
  shift 1
done

# make default dirs

mkdir -p $HOME/.themes
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/dccontainers
mkdir -p $HOME/.local/share/fonts
mkdir -p $HOME/.local/share/applications
mkdir -p $HOME/.config/env
mkdir -p $HOME/.config/fontconfig

mkdir -p $HOME/.config/X11
mkdir -p $HOME/.config/dunst
mkdir -p $HOME/.config/fastfetch
mkdir -p $HOME/.config/git
mkdir -p $HOME/.config/mpv
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/picom
mkdir -p $HOME/.config/polybar
mkdir -p $HOME/.config/qt5ct/colors
mkdir -p $HOME/.config/qt6ct/colors
mkdir -p $HOME/.config/redshift
mkdir -p $HOME/.config/rofi
mkdir -p $HOME/.config/sxiv
mkdir -p $HOME/.config/tmux
mkdir -p $HOME/.config/yazi
mkdir -p $HOME/.config/zathura

# stow defaults
stow X11
stow dunst
stow dockerscripts
stow fastfetch
stow fonts
stow git
stow mpv
stow nvim
stow picom
stow polybar
stow redshift
stow rofi
stow scripts
stow sxiv
stow tmux
stow userconf
stow yazi
stow zathura

if [ $use_alacritty == 1 ]; then
  mkdir -p $HOME/.config/alacritty
  stow alacritty
fi

if [ $use_bspwm == 1 ]; then
  mkdir -p $HOME/.config/bspwm
  mkdir -p $HOME/.config/sxhkd
  stow bspwm
  stow sxhkd
fi

if [ $use_i3 == 1 ]; then
  mkdir -p $HOME/.config/i3
  stow i3
fi

if [ $use_zsh == 1 ]; then
  mkdir -p $HOME/.config/zsh
  stow zsh
fi

if [ $use_bash == 1 ]; then
  stow bash
fi

exit 0
