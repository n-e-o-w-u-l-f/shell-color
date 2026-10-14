#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
for file in "$root/src/shell-color-freebsd.sh" "$root/bin/shell-color-freebsd" "$root/install/install-freebsd.sh"; do sh -n "$file"; done
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
HOME=$tmp/home; export HOME
mkdir -p "$HOME"
printf '%s\n' '# custom shrc' > "$HOME/.shrc"
printf '%s\n' '# custom profile' > "$HOME/.profile"
sh "$root/install/install-freebsd.sh" >/dev/null
sh "$root/install/install-freebsd.sh" >/dev/null
[ "$(grep -c '^# >>> shell-color-freebsd >>>' "$HOME/.shrc")" -eq 1 ]
[ "$(grep -c '^# >>> shell-color-freebsd-login >>>' "$HOME/.profile")" -eq 1 ]
grep -Fqx '# custom shrc' "$HOME/.shrc"
grep -Fqx '# custom profile' "$HOME/.profile"
[ -x "$HOME/.local/bin/shell-color-freebsd" ]
[ -r "$HOME/.local/share/shell-color/shell-color-freebsd.sh" ]
"$HOME/.local/bin/shell-color-freebsd" --set 85 >/dev/null
"$HOME/.local/bin/shell-color-freebsd" --style brackets >/dev/null
[ "$(cat "$HOME/.config/shell-color/color")" = 85 ]
[ "$(cat "$HOME/.config/shell-color/ps1_style")" = brackets ]
if "$HOME/.local/bin/shell-color-freebsd" --set '85;bad' >/dev/null 2>&1; then exit 1; fi
if "$HOME/.local/bin/shell-color-freebsd" --set 999 >/dev/null 2>&1; then exit 1; fi
(
    SHELL_COLOR_FREEBSD_TEST=1; export SHELL_COLOR_FREEBSD_TEST
    TERM=xterm-256color; export TERM
    PS1='OWNER> '
    . "$root/src/shell-color-freebsd.sh"
    [ "$SHELL_COLOR_FREEBSD_ORIGINAL_PS1" = 'OWNER> ' ]
    [ "$SHELL_COLOR_FREEBSD_ACTIVE" = 1 ]
    case $PS1 in *'\u@\h \w'*'\$ '*) ;; *) printf 'Bad FreeBSD sh prompt: %s\n' "$PS1" >&2; exit 1 ;; esac
    case $PS1 in *'\[\e[38;5;85m\]'*) ;; *) printf 'Missing FreeBSD color delimiters\n' >&2; exit 1 ;; esac
    . "$root/src/shell-color-freebsd.sh"
    shell_color_freebsd_disable
    [ "$PS1" = 'OWNER> ' ]
    NO_COLOR=1; export NO_COLOR
    . "$root/src/shell-color-freebsd.sh"
    case $PS1 in *'\['*) printf 'NO_COLOR ignored\n' >&2; exit 1 ;; esac
)
"$HOME/.local/bin/shell-color-freebsd" --style keep >/dev/null
(
    SHELL_COLOR_FREEBSD_TEST=1; export SHELL_COLOR_FREEBSD_TEST
    PS1='ORIGINAL! '
    . "$root/src/shell-color-freebsd.sh"
    [ "$PS1" = 'ORIGINAL! ' ]
)
printf 'FreeBSD sh adapter safety tests passed.\n'
