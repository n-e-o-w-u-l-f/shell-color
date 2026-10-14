#!/usr/bin/env bash
set -euo pipefail

VERSION="v1.33.7a"
MODE="user"
PREFIX=""
RC_FILE="${HOME}/.bashrc"
MODIFY_RC=1

usage() {
  cat <<'EOF'
Usage: ./install/install.sh [options]

Options:
  --user                  install below ~/.local (default)
  --system                install below /usr/local (requires suitable rights)
  --prefix PATH           use a custom installation prefix
  --shell-rc FILE         startup file to update (default: ~/.bashrc)
  --no-modify-rc          do not change a shell startup file
  --help                  show this help
EOF
}

while (($#)); do
  case "$1" in
    --user) MODE="user" ;;
    --system) MODE="system" ;;
    --prefix)
      shift
      [[ $# -gt 0 ]] || { printf 'Missing value for --prefix\n' >&2; exit 2; }
      PREFIX="$1"
      ;;
    --shell-rc)
      shift
      [[ $# -gt 0 ]] || { printf 'Missing value for --shell-rc\n' >&2; exit 2; }
      RC_FILE="$1"
      ;;
    --no-modify-rc) MODIFY_RC=0 ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(CDPATH='' cd -- "$SCRIPT_DIR/.." && pwd)"

if [[ -z "$PREFIX" ]]; then
  if [[ "$MODE" == "system" ]]; then
    PREFIX="/usr/local"
  else
    PREFIX="$HOME/.local"
  fi
fi

SHARE_DIR="$PREFIX/share/shell-color"
BIN_DIR="$PREFIX/bin"
RUNTIME="$SHARE_DIR/shell-color.sh"
BEGIN_MARKER="# >>> shell-color setup >>>"
END_MARKER="# <<< shell-color setup <<<"

install -d "$SHARE_DIR" "$BIN_DIR"
install -m 0644 "$PROJECT_DIR/src/shell-color.sh" "$RUNTIME"
install -m 0755 "$PROJECT_DIR/bin/shell-color" "$BIN_DIR/shell-color"

if [[ "$MODIFY_RC" == "1" ]]; then
  touch "$RC_FILE"
  if ! grep -Fq "$BEGIN_MARKER" "$RC_FILE"; then
    {
      printf '\n%s\n' "$BEGIN_MARKER"
      printf '[ -r %q ] && . %q\n' "$RUNTIME" "$RUNTIME"
      printf '%s\n' "$END_MARKER"
    } >> "$RC_FILE"
  fi
fi

printf 'shell-color %s installed in %s\n' "$VERSION" "$PREFIX"
printf 'Start a new Bash session or run: source %q\n' "$RUNTIME"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  printf 'Add %s to PATH to use the standalone command.\n' "$BIN_DIR"
fi
