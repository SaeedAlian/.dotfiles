#!/usr/bin/env bash

USER_HOME="${USER_HOME:-"/home/$USER"}"
DOTFILES_DIR="${DOTFILES_DIR:-$USER_HOME/.dotfiles}"

. "$DOTFILES_DIR/coreconfig/helpers.sh"

load_init_env

require_vars \
  XDG_CONFIG_HOME \
  SCRIPTS_DIR \
  XDG_DATA_HOME

cd "$DOTFILES_DIR"
STOW_FLAGS=""
TARGET_HOME="$USER_HOME"

CORE_PACKAGES="bash fastfetch git nvim tmux userconf"
SCRIPTS="scripts"
RUNIT_SERVICES="thinkfan"
DESKTOP_PACKAGES="X11 alacritty bspwm dconf dunst fonts mpv picom polybar redshift rofi sxhkd sxiv yazi zathura"

usage() {
  echo "Usage: $0 [--home=/path/to/target/home] group [group ...]"
  echo "Available groups: core desktop scripts runit"
}

case $1 in
-h | --help)
  usage
  exit 0
  ;;
esac

set -- "$@"
GROUP_ARGS=""
group_count=0

for arg in "$@"; do
  case "$arg" in
  --home=*)
      TARGET_HOME="${arg#--home=}"
      ;;
  core | desktop | scripts | runit)
    GROUP_ARGS="${GROUP_ARGS}${arg} "
    group_count=$((group_count + 1))
    ;;
  *)
    print_err "Unknown group: $arg"
    ;;
  esac
done

if [ "$group_count" -eq 0 ]; then
  print_err "Groups are empty, please specify at least one group"
fi

if [ ! -d "$TARGET_HOME" ]; then
  print_err "Target home does not exist: $TARGET_HOME"
fi

set -- $GROUP_ARGS

STOW_FLAGS="$STOW_FLAGS -t $TARGET_HOME"

if [ "$TARGET_HOME" != "$HOME" ]; then
  XDG_CONFIG_HOME="$TARGET_HOME/.config"
  XDG_DATA_HOME="$TARGET_HOME/.local/share"
  SCRIPTS_DIR="$TARGET_HOME/.local/scripts"
fi

setup_core_dirs() {
  mkdir -p "$TARGET_HOME/.themes"
  mkdir -p "$XDG_DATA_HOME/applications"

  mkdir -p "$XDG_CONFIG_HOME/fastfetch"
  mkdir -p "$XDG_CONFIG_HOME/git"
  mkdir -p "$XDG_CONFIG_HOME/gtk-3.0"
  mkdir -p "$XDG_CONFIG_HOME/gtk-4.0"
  mkdir -p "$XDG_CONFIG_HOME/nvim"
  mkdir -p "$XDG_CONFIG_HOME/qt5ct/colors"
  mkdir -p "$XDG_CONFIG_HOME/qt6ct/colors"
  mkdir -p "$XDG_CONFIG_HOME/tmux"
}

setup_scripts_dirs() {
  mkdir -p "$SCRIPTS_DIR"
}

setup_runit_services_dirs() {
  mkdir -p "$XDG_CONFIG_HOME/thinkfan"
  mkdir -p "$XDG_DATA_HOME/sv/thinkfan"
}

setup_desktop_dirs() {
  mkdir -p "$XDG_CONFIG_HOME/X11"
  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  mkdir -p "$XDG_CONFIG_HOME/bspwm"
  mkdir -p "$XDG_CONFIG_HOME/dconf"
  mkdir -p "$XDG_CONFIG_HOME/dunst"
  mkdir -p "$XDG_CONFIG_HOME/fontconfig"
  mkdir -p "$XDG_CONFIG_HOME/mpv"
  mkdir -p "$XDG_CONFIG_HOME/picom"
  mkdir -p "$XDG_CONFIG_HOME/polybar"
  mkdir -p "$XDG_CONFIG_HOME/redshift"
  mkdir -p "$XDG_CONFIG_HOME/rofi"
  mkdir -p "$XDG_CONFIG_HOME/sxhkd"
  mkdir -p "$XDG_CONFIG_HOME/sxiv"
  mkdir -p "$XDG_CONFIG_HOME/yazi"
  mkdir -p "$XDG_CONFIG_HOME/zathura"
}

stow_core() {
  setup_core_dirs
  for pkg in $CORE_PACKAGES; do
    stow $STOW_FLAGS "$pkg"
  done
}

stow_desktop() {
  setup_desktop_dirs
  for pkg in $DESKTOP_PACKAGES; do
    stow $STOW_FLAGS "$pkg"
  done
}

stow_runit_services() {
  setup_runit_services_dirs
  for srv in $RUNIT_SERVICES; do
    stow $STOW_FLAGS "$srv"
  done
}

stow_scripts() {
  setup_scripts_dirs
  stow $STOW_FLAGS scripts
}

for group in "$@"; do
  case "$group" in
  core)
    stow_core
    ;;
  desktop)
    stow_desktop
    ;;
  runit)
    stow_runit_services
    ;;
  scripts)
    stow_scripts
    ;;
  esac
done
