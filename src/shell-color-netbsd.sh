# shell-color native NetBSD /bin/sh adapter (v1.33.7a-netbsd)
# Source from ~/.shrc or ~/.profile only in interactive NetBSD sh.
# No root rights, package manager calls, network requests, or global terminal palette.
# Unlike the Bash runtime this adapter never changes PROMPT_COMMAND or shell options.
if [ "${SHELL_COLOR_NETBSD_TEST-}" != "1" ]; then
  case $- in *i*) ;; *) return 0 ;; esac
  [ -z "${BASH_VERSION-}" ] || return 0
  [ "$(uname -s)" = NetBSD ] || return 0
fi
[ "${SHELL_COLOR_NETBSD_ACTIVE-}" = "1" ] && return 0
SHELL_COLOR_NETBSD_ACTIVE=1
SHELL_COLOR_NETBSD_ORIGINAL_PS1=${PS1-'$ '}
SHELL_COLOR_NETBSD_HOME=${SHELL_COLOR_CONFIG_DIR:-"$HOME/.config/shell-color"}
SHELL_COLOR_NETBSD_USER=${USER:-$(id -un)}
SHELL_COLOR_NETBSD_HOST=${HOSTNAME:-$(hostname)}
SHELL_COLOR_NETBSD_HOST=${SHELL_COLOR_NETBSD_HOST%%.*}
SHELL_COLOR_NETBSD_MARKER='$'
[ "$(id -u)" -eq 0 ] && SHELL_COLOR_NETBSD_MARKER='#'
# NetBSD sh/editline supports PSlit: enclose only non-printing control sequences.
PSlit=$(printf '\001')

shell_color_netbsd_read () {
    _sc_default=$2
    _sc_file=$SHELL_COLOR_NETBSD_HOME/$1
    if [ -r "$_sc_file" ]; then
        IFS= read -r _sc_value < "$_sc_file" || :
        printf '%s' "${_sc_value:-$_sc_default}"
    else
        printf '%s' "$_sc_default"
    fi
}
shell_color_netbsd_render () {
    _sc_idx=$(shell_color_netbsd_read color 85)
    case $_sc_idx in
      ''|*[!0-9]*) _sc_idx=85 ;;
    esac
    if [ "$_sc_idx" -gt 255 ]; then _sc_idx=85; fi
    _sc_style=$(shell_color_netbsd_read ps1_style compact)
    case $_sc_style in
      compact|brackets|arrow|keep) ;;
      *) _sc_style=compact ;;
    esac
    # Width-specific UpdateWulf ANSI/PSlit-safe caches prevent wrapping.
    # Read through the shell builtin, without spawning a process.
    if [ "${SHELL_COLOR_NETBSD_UPDATEWULF:-0}" = "1" ]; then
        _sc_cols=${COLUMNS:-80}
        case $_sc_cols in ''|*[!0-9]*) _sc_cols=80 ;; esac
        _sc_width=22
        if [ "$_sc_cols" -ge 240 ]; then _sc_width=240
        elif [ "$_sc_cols" -ge 160 ]; then _sc_width=160
        elif [ "$_sc_cols" -ge 120 ]; then _sc_width=120
        elif [ "$_sc_cols" -ge 80 ]; then _sc_width=80
        elif [ "$_sc_cols" -ge 40 ]; then _sc_width=40
        fi
        _sc_state=${SHELL_COLOR_NETBSD_STATE:-"$HOME/.local/state/pc-mesh"}
        _sc_file=${SHELL_COLOR_NETBSD_FLEET:-"$_sc_state/fleet-prompt.netbsd."$_sc_width}
        if [ -r "$_sc_file" ]; then
            IFS= read -r _sc_line < "$_sc_file" || :
            case $_sc_line in
              '[ '*) printf '%s\n' "$_sc_line" ;;
            esac
        fi
    fi
    # Keep text expansion away from PS1 itself: PWD is rendered as data here.
    _sc_path=${PWD:-?}
    case $_sc_path in
      "$HOME") _sc_path='~' ;;
      "$HOME"/*) _sc_path="~${_sc_path#"$HOME"}" ;;
    esac
    if [ "$_sc_style" = keep ]; then
        # Keep is explicitly opt-in; restoring the exact original PS1 is safer
        # than trying to parse its existing escape codes or commands.
        printf '%s' "$SHELL_COLOR_NETBSD_ORIGINAL_PS1"
        return
    fi
    printf '%s\033[38;5;%sm%s' "$PSlit" "$_sc_idx" "$PSlit"
    case $_sc_style in
      arrow) printf '<%s@%s %s>' "$SHELL_COLOR_NETBSD_USER" "$SHELL_COLOR_NETBSD_HOST" "$_sc_path" ;;
      brackets) printf '[%s@%s %s]' "$SHELL_COLOR_NETBSD_USER" "$SHELL_COLOR_NETBSD_HOST" "$_sc_path" ;;
      *) printf '(%s@%s %s)' "$SHELL_COLOR_NETBSD_USER" "$SHELL_COLOR_NETBSD_HOST" "$_sc_path" ;;
    esac
    printf '%s\033[0m%s %s ' "$PSlit" "$PSlit" "$SHELL_COLOR_NETBSD_MARKER"
}
shell_color_netbsd_disable () {
    PS1=$SHELL_COLOR_NETBSD_ORIGINAL_PS1
    SHELL_COLOR_NETBSD_ACTIVE=0
}
# Respect 'keep' as a genuine no-op; never hide the owner's PS1 behind a
# command substitution that would render its expansion syntax literally.
if [ "$(shell_color_netbsd_read ps1_style compact)" = keep ]; then
    SHELL_COLOR_NETBSD_ACTIVE=0
    return 0
fi
# Assign the command substitution as literal data; set promptcmds only after
# replacing PS1, per the NetBSD sh(1) documented safety guidance.
PS1='$(shell_color_netbsd_render)'
if [ "${SHELL_COLOR_NETBSD_TEST-}" != "1" ]; then
    set -o promptcmds || shell_color_netbsd_disable
fi
