source $HOME/.config/env/env_vars
source $HOME/.config/env/private_env_vars

[[ -f $HOME/.bashrc ]] && . $HOME/.bashrc
[[ -d $HOME/.cargo ]] && . "$HOME/.cargo/env"
