#!/bin/sh

CORECONFIG_DIR="${CORECONFIG_DIR:-$HOME/.dotfiles/coreconfig}"

. "$CORECONFIG_DIR/groups.conf"

load_conf() {
  export_vars=0

  case "$1" in
  -e | --export)
    export_vars=1
    shift
    ;;
  esac

  for f in "$@"; do
    if [ -f "$CORECONFIG_DIR/$f" ]; then
      if [ "$export_vars" -eq 1 ]; then
        set -a
        . "$CORECONFIG_DIR/$f"
        set +a
      else
        . "$CORECONFIG_DIR/$f"
      fi
    fi
  done
}

load_init_env() { load_conf "$@" $INIT_VARS; }
load_shell_env() { load_conf "$@" $SHELL_VARS; }
load_user_env() { load_conf "$@" $USER_VARS; }
load_desktop_env() { load_conf "$@" $DESKTOP_VARS; }
load_colors() { load_conf "$@" $COLOR_VARS; }

load_private_env() {
  if [ -f "$CORECONFIG_DIR/vars/private.conf" ]; then
    load_conf "$@" vars/private.conf
  fi
}
