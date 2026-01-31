#!/bin/sh

require_vars \
  DOTFILES_DIR \
  XDG_CONFIG_HOME \
  SCRIPTS_DIR \
  CUSTOM_DOCKER_CONTAINERS_PATH \
  XDG_DATA_HOME

cd "$DOTFILES_DIR"
STOW_FLAGS=()

mkdir -p $HOME/.themes
mkdir -p $SCRIPTS_DIR
mkdir -p $CUSTOM_DOCKER_CONTAINERS_PATH
mkdir -p $XDG_DATA_HOME/applications
mkdir -p $XDG_CONFIG_HOME/fontconfig

mkdir -p $XDG_CONFIG_HOME/X11
mkdir -p $XDG_CONFIG_HOME/alacritty
mkdir -p $XDG_CONFIG_HOME/bspwm
mkdir -p $XDG_CONFIG_HOME/dunst
mkdir -p $XDG_CONFIG_HOME/fastfetch
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/mpv
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_CONFIG_HOME/picom
mkdir -p $XDG_CONFIG_HOME/polybar
mkdir -p $XDG_CONFIG_HOME/redshift
mkdir -p $XDG_CONFIG_HOME/rofi
mkdir -p $XDG_CONFIG_HOME/sxhkd
mkdir -p $XDG_CONFIG_HOME/sxiv
mkdir -p $XDG_CONFIG_HOME/tmux
mkdir -p $XDG_CONFIG_HOME/yazi
mkdir -p $XDG_CONFIG_HOME/zathura
mkdir -p $XDG_CONFIG_HOME/qt5ct/colors
mkdir -p $XDG_CONFIG_HOME/qt6ct/colors

# stow defaults
stow "${STOW_FLAGS[@]}" X11
stow "${STOW_FLAGS[@]}" alacritty
stow "${STOW_FLAGS[@]}" bash
stow "${STOW_FLAGS[@]}" bspwm
stow "${STOW_FLAGS[@]}" dockerscripts
stow "${STOW_FLAGS[@]}" dunst
stow "${STOW_FLAGS[@]}" fastfetch
stow "${STOW_FLAGS[@]}" fonts
stow "${STOW_FLAGS[@]}" git
stow "${STOW_FLAGS[@]}" mpv
stow "${STOW_FLAGS[@]}" nvim
stow "${STOW_FLAGS[@]}" picom
stow "${STOW_FLAGS[@]}" polybar
stow "${STOW_FLAGS[@]}" redshift
stow "${STOW_FLAGS[@]}" rofi
stow "${STOW_FLAGS[@]}" scripts
stow "${STOW_FLAGS[@]}" sxhkd
stow "${STOW_FLAGS[@]}" sxiv
stow "${STOW_FLAGS[@]}" tmux
stow "${STOW_FLAGS[@]}" userconf
stow "${STOW_FLAGS[@]}" yazi
stow "${STOW_FLAGS[@]}" zathura
