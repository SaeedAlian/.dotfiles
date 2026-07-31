set -a
USER_HOME="${USER_HOME:-"/home/$USER"}"
DOTFILES_DIR="$USER_HOME/.dotfiles"
set +a

. "$DOTFILES_DIR/coreconfig/helpers.sh"

load_all_and_require true

if in_container; then
  mkdir -p "$XDG_CONFIG_HOME"
  mkdir -p "$XDG_DATA_HOME"
  mkdir -p "$XDG_STATE_HOME"
  mkdir -p "$XDG_CACHE_HOME"
fi

export PATH="$PATH:\
/usr/local/bin:\
/usr/bin:\
/usr/sbin:\
$HOME/.cargo/bin:\
$SCRIPTS_DIR:\
$SCRIPTS_DIR/bar:\
$SCRIPTS_DIR/bspwm:\
$SCRIPTS_DIR/distrobox:\
$SCRIPTS_DIR/docker:\
$SCRIPTS_DIR/packages:\
$SCRIPTS_DIR/tools:\
$SCRIPTS_DIR/utils:\
/usr/local/go/bin:\
/var/lib/flatpak/exports/bin:\
$HOME/.local/share/applications:\
$HOME/.local/node:\
$HOME/.local/node/bin\
"

[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc
[[ -d $HOME/.cargo ]] && [[ -d $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
