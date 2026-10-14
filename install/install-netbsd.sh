#!/bin/sh
# Non-root user installation for NetBSD /bin/sh.
# Preserves existing PS1, ~/.shrc and unrelated startup blocks.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
home=${HOME:?HOME required}
prefix="$home/.local"
rc="$home/.shrc"
while [ "$#" -gt 0 ]; do
  case $1 in
    --prefix) shift; [ "$#" -gt 0 ] || exit 2; prefix=$1 ;;
    --shell-rc) shift; [ "$#" -gt 0 ] || exit 2; rc=$1 ;;
    --no-modify-rc) rc='' ;;
    --help) printf 'usage: install-netbsd.sh [--prefix PATH] [--shell-rc PATH] [--no-modify-rc]\n'; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
  shift
done
[ -r "$root/src/shell-color-netbsd.sh" ] || exit 1
[ -r "$root/bin/shell-color-netbsd" ] || exit 1
mkdir -p "$prefix/share/shell-color" "$prefix/bin"
install -m 0644 "$root/src/shell-color-netbsd.sh" "$prefix/share/shell-color/shell-color-netbsd.sh"
install -m 0755 "$root/bin/shell-color-netbsd" "$prefix/bin/shell-color-netbsd"
# Do not replace an existing Bash-oriented shell-color executable.
if [ ! -e "$prefix/bin/shell-color" ] && [ ! -L "$prefix/bin/shell-color" ]; then
  install -m 0755 "$root/bin/shell-color-netbsd" "$prefix/bin/shell-color"
fi
if [ -n "$rc" ]; then
  [ ! -L "$rc" ] || { printf 'Symlinked rc file not modified\n' >&2; exit 1; }
  [ -f "$rc" ] || : > "$rc"
  start='# >>> shell-color-netbsd >>>'
  end='# <<< shell-color-netbsd <<<'
  if grep -Fq "$start" "$rc"; then
    grep -Fq "$end" "$rc" || { printf 'Incomplete managed block in %s\n' "$rc" >&2; exit 1; }
    printf 'Managed NetBSD startup block already present; no duplicate\n'
  else
    cp -p "$rc" "$rc.shell-color-backup-$(date +%Y%m%d%H%M%S)"
    {
      printf '\n%s\n' "$start"
      printf '[ -r "%s/share/shell-color/shell-color-netbsd.sh" ] && . "%s/share/shell-color/shell-color-netbsd.sh"\n' "$prefix" "$prefix"
      printf '%s\n' "$end"
    } >> "$rc"
  fi
fi
printf 'Installed NetBSD user prompt runtime: %s/share/shell-color/shell-color-netbsd.sh\n' "$prefix"
printf 'No current session or system-wide startup files were changed. Open a new interactive sh to activate.\n'
