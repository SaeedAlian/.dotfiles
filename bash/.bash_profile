set -a
. "$HOME/.dotfiles/coreconfig/load_all_and_require.sh"
set +a

load_all_and_require true

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
[[ -d $HOME/.cargo ]] && [[ -d $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
