#!/bin/sh

DOTFILES_DIR="$HOME/.dotfiles"
CORECONFIG_DIR="$DOTFILES_DIR/coreconfig"

load_init_vars_conf() {
  set -a
  . "$CORECONFIG_DIR/init_vars.conf"
  set +a
}

load_background_conf() {
  set -a
  . "$CORECONFIG_DIR/background.conf"
  set +a
}

load_desktop_vars_conf() {
  set -a
  . "$CORECONFIG_DIR/desktop_vars.conf"
  set +a
}

load_shell_vars_conf() {
  set -a
  . "$CORECONFIG_DIR/shell_vars.conf"
  set +a
}

load_tmux_vars_conf() {
  set -a
  . "$CORECONFIG_DIR/tmux_vars.conf"
  set +a
}

load_touchpad_conf() {
  set -a
  . "$CORECONFIG_DIR/touchpad.conf"
  set +a
}

load_user_vars_conf() {
  set -a
  . "$CORECONFIG_DIR/user_vars.conf"
  set +a
}

load_window_classes_conf() {
  set -a
  . "$CORECONFIG_DIR/window_classes.conf"
  set +a
}

load_main_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/main.conf"
  set +a
}

load_alacritty_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/alacritty.conf"
  set +a
}

load_bar_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/bar.conf"
  set +a
}

load_bspwm_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/bspwm.conf"
  set +a
}

load_dunst_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/dunst.conf"
  set +a
}

load_nvim_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/nvim.conf"
  set +a
}

load_rofi_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/rofi.conf"
  set +a
}

load_xresources_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/xresources.conf"
  set +a
}

load_zathura_colors() {
  set -a
  . "$CORECONFIG_DIR/colors/zathura.conf"
  set +a
}

load_private_vars_conf() {
  if [ -f "$CORECONFIG_DIR/private_vars.conf" ]; then
    set -a
    . "$CORECONFIG_DIR/private_vars.conf"
    set +a
  fi
}

load_all_env_conf() {
  load_init_vars_conf
  load_shell_vars_conf
  load_desktop_vars_conf
  load_background_conf
  load_user_vars_conf
  load_touchpad_conf
  load_window_classes_conf
  load_tmux_vars_conf
}

load_all_colors() {
  load_main_colors
  load_xresources_colors
  load_bspwm_colors
  load_bar_colors
  load_alacritty_colors
  load_nvim_colors
  load_rofi_colors
  load_dunst_colors
  load_zathura_colors
}
