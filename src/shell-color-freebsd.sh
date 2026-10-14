# Shell-Color: native FreeBSD /bin/sh prompt adapter.
# Source only in interactive FreeBSD sh. No Bash-only syntax or network work.
# FreeBSD sh(1) provides native PS1 escapes: \u, \h, \w, \$, \[, \], \e.
# Unlike NetBSD, FreeBSD sh does not have NetBSD's promptcmds option.
if [ "${SHELL_COLOR_FREEBSD_TEST-}" != "1" ]; then
    case $- in *i*) ;; *) return 0 ;; esac
    [ -z "${BASH_VERSION-}${ZSH_VERSION-}" ] || return 0
    [ "$(uname -s)" = FreeBSD ] || return 0
fi
[ "${SHELL_COLOR_FREEBSD_ACTIVE-}" = "1" ] && return 0
SHELL_COLOR_FREEBSD_ORIGINAL_PS1=${PS1-'$ '}
SHELL_COLOR_FREEBSD_CONFIG_DIR=${SHELL_COLOR_CONFIG_DIR:-"$HOME/.config/shell-color"}

shell_color_freebsd_config () {
    _sc_file=$SHELL_COLOR_FREEBSD_CONFIG_DIR/$1
    _sc_default=$2
    _sc_read=''
    if [ -r "$_sc_file" ]; then
        IFS= read -r _sc_read < "$_sc_file" || :
    fi
    printf '%s' "${_sc_read:-$_sc_default}"
}

shell_color_freebsd_disable () {
    PS1=$SHELL_COLOR_FREEBSD_ORIGINAL_PS1
    SHELL_COLOR_FREEBSD_ACTIVE=0
}

_sc_style=$(shell_color_freebsd_config ps1_style compact)
case $_sc_style in
    keep) return 0 ;;
    compact|brackets|arrow) ;;
    *) _sc_style=compact ;;
esac
_sc_color=$(shell_color_freebsd_config color 85)
case $_sc_color in
    ''|*[!0-9]*) _sc_color=85 ;;
    *) [ "${#_sc_color}" -le 3 ] && [ "$_sc_color" -le 255 ] || _sc_color=85 ;;
esac

# Compose PS1 as *data* using FreeBSD's documented prompt escapes. Never
# evaluate configuration contents, or use command substitution in PS1.
case $_sc_style in
    compact) _sc_left='('; _sc_right=')' ;;
    brackets) _sc_left='['; _sc_right=']' ;;
    arrow) _sc_left='<'; _sc_right='>' ;;
esac
if [ -n "${NO_COLOR-}" ] || [ "${TERM-}" = dumb ]; then
    PS1="${_sc_left}\\u@\\h \\w${_sc_right} \\$ "
else
    # The \[\] delimiters protect line editing from nonprinting CSI bytes.
    PS1="\\[\\e[38;5;${_sc_color}m\\]${_sc_left}\\u@\\h \\w${_sc_right}\\[\\e[0m\\] \\$ "
fi
SHELL_COLOR_FREEBSD_ACTIVE=1
unset _sc_style _sc_color _sc_left _sc_right _sc_file _sc_default _sc_read
