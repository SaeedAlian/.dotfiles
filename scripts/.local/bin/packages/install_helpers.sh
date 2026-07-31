create_work_dir() {
  local dir
  dir=$(mktemp -d)
  echo "$dir"
}

cleanup() {
  local workdir="$1"
  rm -rf "$workdir"
}

download() {
  local archive_path="$1"
  local url="$2"
  curl -fL -C - -o "$archive_path" "$url"
}
