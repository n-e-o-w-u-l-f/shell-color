#!/usr/bin/env bash
set -euo pipefail

MODE="user"
PREFIX=""
RC_FILE="${HOME}/.bashrc"

usage() {
  cat <<'EOF'
Usage: ./install/uninstall.sh [--user|--system] [--prefix PATH] [--shell-rc FILE]
EOF
}

while (($#)); do
  case "$1" in
    --user) MODE="user" ;;
    --system) MODE="system" ;;
    --prefix) shift; PREFIX="${1:?Missing value for --prefix}" ;;
    --shell-rc) shift; RC_FILE="${1:?Missing value for --shell-rc}" ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
  shift
done

if [[ -z "$PREFIX" ]]; then
  [[ "$MODE" == "system" ]] && PREFIX="/usr/local" || PREFIX="$HOME/.local"
fi

if [[ -f "$RC_FILE" ]]; then
  tmp_file="$(mktemp)"
  awk '
    $0 == "# >>> shell-color setup >>>" { skip=1; next }
    $0 == "# <<< shell-color setup <<<" { skip=0; next }
    !skip { print }
  ' "$RC_FILE" > "$tmp_file"
  chmod --reference="$RC_FILE" "$tmp_file" 2>/dev/null || true
  mv "$tmp_file" "$RC_FILE"
fi

rm -f -- "$PREFIX/bin/shell-color"
rm -f -- "$PREFIX/share/shell-color/shell-color.sh"
rmdir -- "$PREFIX/share/shell-color" 2>/dev/null || true

printf 'shell-color removed from %s\n' "$PREFIX"
printf 'User settings remain in %s/.config/shell-color\n' "$HOME"
