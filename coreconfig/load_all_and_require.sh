. "$HOME/.dotfiles/coreconfig/load.sh"
. "$HOME/.dotfiles/coreconfig/require_vars.sh"

load_all_and_require() {
  export_vars="$1"

  if $export_vars; then
    EXPORT_FLAG="-e"
  else
    EXPORT_FLAG=""
  fi

  load_init_env $EXPORT_FLAG
  load_shell_env $EXPORT_FLAG
  load_user_env $EXPORT_FLAG
  load_desktop_env $EXPORT_FLAG
  load_colors $EXPORT_FLAG

  require_vars_group init shell user desktop colors
}
