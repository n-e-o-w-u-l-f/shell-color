#!/bin/sh
# Portable smoke tests for the native NetBSD sh adapter; also executable on Linux.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
for file in "$root/src/shell-color-netbsd.sh" "$root/bin/shell-color-netbsd" "$root/install/install-netbsd.sh"; do
  sh -n "$file"
done
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
HOME="$tmp/home"
export HOME
mkdir -p "$HOME"
printf '%s\n' "owner custom prompt" > "$HOME/.shrc"
# The installer must not overwrite existing .shrc contents or duplicate its block.
sh "$root/install/install-netbsd.sh" >/dev/null
sh "$root/install/install-netbsd.sh" >/dev/null
grep -Fq 'owner custom prompt' "$HOME/.shrc"
[ "$(grep -c '# >>> shell-color-netbsd >>>' "$HOME/.shrc")" -eq 1 ]
[ -r "$HOME/.local/share/shell-color/shell-color-netbsd.sh" ]
[ -x "$HOME/.local/bin/shell-color-netbsd" ]
"$HOME/.local/bin/shell-color-netbsd" --set 85 >/dev/null
"$HOME/.local/bin/shell-color-netbsd" --style brackets >/dev/null
test "$(cat "$HOME/.config/shell-color/color")" = 85
test "$(cat "$HOME/.config/shell-color/ps1_style")" = brackets
[ -x "$HOME/.local/bin/shell-color" ]
if "$HOME/.local/bin/shell-color-netbsd" --set '85;false' >/dev/null 2>&1; then
  printf 'Unsafe color input accepted\n' >&2
  exit 1
fi
# Test the adapter in an isolated noninteractive sh, without needing NetBSD.
(
  SHELL_COLOR_NETBSD_TEST=1
  export SHELL_COLOR_NETBSD_TEST
  PS1='OWNER> '
  . "$root/src/shell-color-netbsd.sh"
  [ "$SHELL_COLOR_NETBSD_ORIGINAL_PS1" = 'OWNER> ' ]
  [ "$PS1" = '$(shell_color_netbsd_render)' ]
  first=$(shell_color_netbsd_render)
  printf '%s' "$first" | grep -Fq 'brackets' && exit 1
  printf '%s' "$first" | grep -Fq '['
  . "$root/src/shell-color-netbsd.sh"
  [ "$PS1" = '$(shell_color_netbsd_render)' ]
  shell_color_netbsd_disable
  [ "$PS1" = 'OWNER> ' ]
)
printf 'NetBSD sh adapter and non-destructive install tests passed.\n'
