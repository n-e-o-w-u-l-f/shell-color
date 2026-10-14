#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

required_commands=(bash dpkg-deb gzip make rg shellcheck tar)
missing_commands=()

for required_command in "${required_commands[@]}"; do
  if ! command -v "$required_command" >/dev/null 2>&1; then
    missing_commands+=("$required_command")
  fi
done

if ((${#missing_commands[@]})); then
  printf 'Linux CI prerequisites are missing: %s\n' "${missing_commands[*]}" >&2
  printf 'Install them, then rerun ./ci/linux.sh.\n' >&2
  exit 1
fi

cd "$PROJECT_DIR"
make test-linux
make lint
make tarball
make deb

printf 'Local Linux CI passed.\n'
