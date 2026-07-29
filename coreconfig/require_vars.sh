#!/bin/sh

CORECONFIG_DIR="${CORECONFIG_DIR:-$HOME/.dotfiles/coreconfig}"

. "$CORECONFIG_DIR/groups.conf"

_vars_in_file() {
  grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$CORECONFIG_DIR/$1" | cut -d= -f1
}

require_vars() {
  for var; do
    eval "[ -n \"\${$var}\" ]" || {
      printf 'Error: required env var not set: %s\n' "$var" >&2
      return 1
    }
  done
}

require_vars_in() {
  missing=""
  for f in "$@"; do
    [ -f "$CORECONFIG_DIR/$f" ] || continue
    for var in $(_vars_in_file "$f"); do
      eval "[ -n \"\${$var}\" ]" || missing="$missing $var"
    done
  done
  if [ -n "$missing" ]; then
    printf 'Error: required env vars not set:%s\n' "$missing" >&2
    return 1
  fi
}

require_vars_group() {
  for group in "$@"; do
    case "$group" in
    init) require_vars_in $INIT_VARS ;;
    shell) require_vars_in $SHELL_VARS ;;
    user) require_vars_in $USER_VARS ;;
    desktop) require_vars_in $DESKTOP_VARS ;;
    colors) require_vars_in $COLOR_VARS ;;
    *)
      printf 'Error: unknown var group: %s\n' "$group" >&2
      return 1
      ;;
    esac
  done
}
