USER_HOME="${USER_HOME:-"/home/$USER"}"
DOTFILES_DIR="$USER_HOME/.dotfiles"
CORECONFIG_DIR="${CORECONFIG_DIR:-$DOTFILES_DIR/coreconfig}"

. "$CORECONFIG_DIR/groups.conf"

in_container() { [ -f /run/.containerenv ] || [ -f /.dockerenv ]; }

print_err() {
  local script_name="${BASH_SOURCE[1]}"
  local err="$1"

  echo "Error: $err" >&2
  echo "Enter [$(basename "$script_name") --help] for help" >&2

  exit 1
}

need_bin() {
  command -v "$1" >/dev/null 2>&1 || print_err "'$1' is required but not installed"
}

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
load_distrobox_env() { load_conf "$@" $DISTROBOX_VARS; }
load_desktop_env() { load_conf "$@" $DESKTOP_VARS; }
load_colors() { load_conf "$@" $COLOR_VARS; }

load_private_env() {
  if [ -f "$CORECONFIG_DIR/vars/private.conf" ]; then
    load_conf "$@" vars/private.conf
  fi
}

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
    distrobox) require_vars_in $DISTROBOX_VARS ;;
    desktop) require_vars_in $DESKTOP_VARS ;;
    colors) require_vars_in $COLOR_VARS ;;
    *)
      printf 'Error: unknown var group: %s\n' "$group" >&2
      return 1
      ;;
    esac
  done
}

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

load_all_and_require_for_distrobox() {
  export_vars="$1"

  if $export_vars; then
    EXPORT_FLAG="-e"
  else
    EXPORT_FLAG=""
  fi

  load_all_and_require "$export_vars"
  load_distrobox_env $EXPORT_FLAG

  require_vars_group distrobox
}

docker_cmd_exec() {
  if groups "$USER" | grep -q "\bdocker\b"; then
    docker "$@"
  else
    sudo docker "$@"
  fi
}

run_root() {
  if [ "$EUID" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

ex() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: ex <archive> [-o|--outdir <dir>] [extra args...]" >&2
    return 1
  fi

  local file="$1"
  shift

  local outdir="."

  while [ "$#" -gt 0 ]; do
    case "$1" in
    -o | --outdir)
      outdir="$2"
      shift 2
      ;;
    *)
      print_err "Unknown arg: $1"
      ;;
    esac
  done

  if [ ! -f "$file" ]; then
    echo "'$file' is not a valid file" >&2
    return 1
  fi

  curr_path=$(pwd)
  file="$(cd "$(dirname "$file")" && pwd)/$(basename "$file")"

  mkdir -p "$outdir" || return 1

  cd "$outdir" || exit 1
  case "$file" in
  *.tar.bz2 | *.tbz2)
    need_bin tar
    command tar xjf "$file"
    ;;
  *.tar.gz | *.tgz)
    need_bin tar
    command tar xzf "$file"
    ;;
  *.tar.xz | *.txz)
    need_bin tar
    command tar xJf "$file"
    ;;
  *.tar.zst | *.tzst)
    need_bin tar
    command tar --zstd -xf "$file"
    ;;
  *.tar)
    need_bin tar
    command tar xf "$file"
    ;;
  *.bz2)
    need_bin bunzip2
    command bunzip2 -k "$file"
    ;;
  *.gz)
    need_bin gunzip
    command gunzip -k "$file"
    ;;
  *.xz)
    need_bin unxz
    command unxz -k "$file"
    ;;
  *.zst)
    need_bin unzstd
    command unzstd "$file"
    ;;
  *.rar)
    need_bin unrar
    command unrar x "$file"
    ;;
  *.zip)
    need_bin unzip
    command unzip "$file"
    ;;
  *.7z)
    need_bin 7z
    command 7z x "$file"
    ;;
  *.Z)
    need_bin uncompress
    command uncompress -k "$file"
    ;;
  *)
    echo "'$file' cannot be extracted via ex()" >&2
    exit 2
    ;;
  esac

  cd "$curr_path" || exit 1
}
