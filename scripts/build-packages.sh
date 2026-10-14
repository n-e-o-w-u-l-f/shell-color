#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if (($#)); then
  formats=("$@")
else
  formats=(tarball deb rpm arch)
fi

for format in "${formats[@]}"; do
  case "$format" in
    tarball) "$SCRIPT_DIR/build-tarball.sh" ;;
    deb) "$SCRIPT_DIR/build-deb.sh" ;;
    rpm) "$SCRIPT_DIR/build-rpm.sh" ;;
    arch) "$SCRIPT_DIR/build-arch.sh" ;;
    *) printf 'Unknown package format: %s\n' "$format" >&2; exit 2 ;;
  esac
done
