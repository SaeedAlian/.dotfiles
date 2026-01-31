set -a
. "$HOME/.dotfiles/coreconfig/load.sh"
. "$HOME/.dotfiles/coreconfig/require_vars.sh"
set +a

load_init_vars_conf

require_vars \
  XDG_CURRENT_DESKTOP \
  XDG_CONFIG_HOME \
  XDG_DATA_HOME \
  XDG_STATE_HOME \
  XDG_CACHE_HOME \
  XINITRC \
  YAZI_CONFIG_HOME \
  npm_config_prefix \
  DOTFILES_DIR \
  CORECONFIG_DIR \
  SCRIPTS_DIR \
  MOUNT_DIR \
  NOTES_DIR \
  PROJECTS_DIR \
  SCREEN_CAST_DIR \
  MUSICS_DIR \
  WALLPAPERS_DIR \
  LOCKSCREENS_DIR \
  SCREENSHOTS_DIR \
  START_LOCKSCREEN_SCRIPT_PATH \
  PICOM_CONF_PATH \
  CUSTOM_DOCKER_CONTAINERS_PATH \
  POLYBAR_VISIBILITY_SCRIPT_PATH \
  BACKGROUND_SCRIPT_PATH

export PATH="$PATH:\
/usr/local/bin:\
$HOME/.cargo/bin:\
$SCRIPTS_DIR:\
$SCRIPTS_DIR/bar:\
$SCRIPTS_DIR/bspwm:\
$SCRIPTS_DIR/tools:\
$SCRIPTS_DIR/utils:\
$SCRIPTS_DIR/dc-docker:\
/usr/local/go/bin:\
/var/lib/flatpak/exports/bin:\
$HOME/.local/share/applications:\
$HOME/.local/node:\
$HOME/.local/node/bin\
"

[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc
[[ -d $HOME/.cargo ]] && . "$HOME/.cargo/env"
