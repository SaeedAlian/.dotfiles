#!/bin/sh

require_vars() {
  for var; do
    eval "[ -n \"\${$var}\" ]" || {
      printf 'Error: required env var not set: %s\n' "$var" >&2
      return 1
    }
  done
}
