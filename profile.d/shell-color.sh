# shellcheck shell=bash
# Load shell-color only in interactive Bash sessions.
if [ -n "${BASH_VERSION:-}" ]; then
  case "$-" in
    *i*)
      for __shell_color_runtime in \
        "$HOME/.local/share/shell-color/shell-color.sh" \
        "/usr/local/share/shell-color/shell-color.sh" \
        "/usr/share/shell-color/shell-color.sh"
      do
        if [ -r "$__shell_color_runtime" ]; then
          # shellcheck source=/dev/null
          . "$__shell_color_runtime"
          break
        fi
      done
      unset __shell_color_runtime
      ;;
  esac
fi
