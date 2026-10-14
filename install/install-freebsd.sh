#!/bin/sh
# Safe, unprivileged FreeBSD /bin/sh user installation. Never changes login shell.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
prefix=${HOME:?HOME required}/.local
rc=$HOME/.shrc
login_rc=$HOME/.profile
while [ "$#" -gt 0 ]; do
    case $1 in
        --prefix) shift; [ "$#" -gt 0 ] || exit 2; prefix=$1 ;;
        --shell-rc) shift; [ "$#" -gt 0 ] || exit 2; rc=$1 ;;
        --no-modify-rc) rc=''; login_rc='' ;;
        --help) printf '%s\n' 'usage: install-freebsd.sh [--prefix PATH] [--shell-rc PATH] [--no-modify-rc]'; exit 0 ;;
        *) printf '%s\n' "unknown option: $1" >&2; exit 2 ;;
    esac
    shift
done
# Reject paths unsafe to embed into the shell's startup configuration.
case $prefix in /*) ;; *) printf '%s\n' 'Absolute prefix required' >&2; exit 2 ;; esac
case $prefix in *\"*|*\'*|*'\\'*|*'
'*) printf '%s\n' 'Unsafe prefix' >&2; exit 2 ;; esac
[ -r "$root/src/shell-color-freebsd.sh" ] || exit 1
[ -r "$root/bin/shell-color-freebsd" ] || exit 1
# Fail closed before creating anything if an existing startup block is corrupt.
for path in "$rc" "$login_rc"; do
    [ -n "$path" ] || continue
    [ ! -L "$path" ] || { printf 'Symlinked rc file refused: %s\n' "$path" >&2; exit 1; }
    if [ -f "$path" ]; then
        starts=$(grep -c '^# >>> shell-color-freebsd' "$path" || :)
        ends=$(grep -c '^# <<< shell-color-freebsd' "$path" || :)
        [ "$starts" = "$ends" ] || { printf 'Incomplete managed startup block in %s\n' "$path" >&2; exit 1; }
    fi
done
mkdir -p "$prefix/share/shell-color" "$prefix/bin"
install -m 0644 "$root/src/shell-color-freebsd.sh" "$prefix/share/shell-color/shell-color-freebsd.sh"
install -m 0755 "$root/bin/shell-color-freebsd" "$prefix/bin/shell-color-freebsd"
[ -e "$prefix/bin/shell-color" ] || [ -L "$prefix/bin/shell-color" ] || install -m 0755 "$root/bin/shell-color-freebsd" "$prefix/bin/shell-color"
write_block () {
    path=$1; text=$2; start=$3; end=$4
    [ -n "$path" ] || return 0
    [ -f "$path" ] || : > "$path"
    if grep -Fqx "$start" "$path"; then return 0; fi
    cp -p "$path" "$path.shell-color-backup-$(date +%Y%m%d%H%M%S)"
    { printf '\n%s\n' "$start"; printf '%s\n' "$text"; printf '%s\n' "$end"; } >> "$path"
}
start='# >>> shell-color-freebsd >>>'
end='# <<< shell-color-freebsd <<<'
write_block "$rc" "[ -r \"$prefix/share/shell-color/shell-color-freebsd.sh\" ] && . \"$prefix/share/shell-color/shell-color-freebsd.sh\"" "$start" "$end"
start='# >>> shell-color-freebsd-login >>>'
end='# <<< shell-color-freebsd-login <<<'
write_block "$login_rc" "case \$- in *i*) [ -r \"$prefix/share/shell-color/shell-color-freebsd.sh\" ] && . \"$prefix/share/shell-color/shell-color-freebsd.sh\" ;; esac
[ -n \"${ENV-}\" ] || { ENV=\"\$HOME/.shrc\"; export ENV; }" "$start" "$end"
printf 'Installed native FreeBSD sh adapter to %s (new sessions only)\n' "$prefix"
