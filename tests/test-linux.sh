#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME="$PROJECT_DIR/src/shell-color.sh"

bash -n "$RUNTIME"
bash -n "$PROJECT_DIR/bin/shell-color"
bash -n "$PROJECT_DIR/install/install.sh"
bash -n "$PROJECT_DIR/install/uninstall.sh"

test_home="$(mktemp -d)"
trap 'rm -rf -- "$test_home"' EXIT

output="$({
  # This block intentionally verifies an isolated first-run configuration.
  # shellcheck disable=SC2030
  export HOME="$test_home"
  # shellcheck disable=SC2030
  export SHELL_COLOR_FORCE_LOAD=1
  # shellcheck source=/dev/null
  source "$RUNTIME"
  shell-color --set mint >/dev/null
  shell-color --style brackets >/dev/null
  shell-color --current
  shell-color --version
  shell-color --style list
} 2>/dev/null)"

grep -Fq '85 SeaGreen1 #5fffaf style=brackets path_position=inside' <<<"$output"
grep -Fq 'shell-color v1.33.7a' <<<"$output"
grep -Fq '4 arrow       <user@host ~/folder/file.type> $' <<<"$output"
grep -Fq '6 arrow-ip    <user@host(IP) ~/folder/file.type> $' <<<"$output"
grep -Fq '7 brackets-ip [user@host(IP) ~/folder/file.type] $' <<<"$output"
test "$(<"$test_home/.config/shell-color/color")" = "85"
test "$(<"$test_home/.config/shell-color/ps1_style")" = "brackets"

# Reapply both values outside the command-substitution subshell on purpose.
# shellcheck disable=SC2031
export HOME="$test_home"
# shellcheck disable=SC2031
export SHELL_COLOR_FORCE_LOAD=1
# shellcheck source=/dev/null
source "$RUNTIME"

strip_ansi() {
  sed $'s/\033\\[[0-9;]*m//g'
}

assert_prompt() {
  local style="$1" position="$2" expected="$3" actual
  # A literal tilde is the expected home-relative prompt representation.
  # shellcheck disable=SC2088
  local sample_path='~/folder/file.type'
  actual="$(__shell_color_build_ansi 85 "$style" user host 192.0.2.25 "$sample_path" "$position" | strip_ansi)"
  if [ "$actual" != "$expected" ]; then
    printf 'Unexpected %s prompt.\nExpected: %s\nActual:   %s\n' "$style" "$expected" "$actual" >&2
    exit 1
  fi
}

assert_prompt compact inside '(user@host ~/folder/file.type) $ '
assert_prompt compact-ip inside '(user@host[192.0.2.25] ~/folder/file.type) $ '
assert_prompt arrow inside '<user@host ~/folder/file.type> $ '
assert_prompt brackets inside '[user@host ~/folder/file.type] $ '
assert_prompt arrow-ip inside '<user@host(192.0.2.25) ~/folder/file.type> $ '
assert_prompt brackets-ip inside '[user@host(192.0.2.25) ~/folder/file.type] $ '

assert_prompt compact outside '(user@host) ~/folder/file.type $ '
assert_prompt compact-ip outside '(user@host[192.0.2.25]) ~/folder/file.type $ '
assert_prompt arrow outside '<user@host> ~/folder/file.type $ '
assert_prompt brackets outside '[user@host] ~/folder/file.type $ '
assert_prompt arrow-ip outside '<user@host(192.0.2.25)> ~/folder/file.type $ '
assert_prompt brackets-ip outside '[user@host(192.0.2.25)] ~/folder/file.type $ '

# Preserve Bash's array-valued PROMPT_COMMAND and all owner-defined hooks.
original_prompt_command="$(declare -p PROMPT_COMMAND 2>/dev/null || :)"
owner_updatewulf_probe() { :; }
PROMPT_COMMAND=(owner_updatewulf_probe)
shell-color-apply >/dev/null 2>&1
declare -p PROMPT_COMMAND | grep -Fq 'declare -a'
test "${PROMPT_COMMAND[0]}" = owner_updatewulf_probe
test "${PROMPT_COMMAND[1]}" = __shell_color_apply_ps1
shell-color-apply >/dev/null 2>&1
test "${#PROMPT_COMMAND[@]}" -eq 2
unset PROMPT_COMMAND
eval "$original_prompt_command"

# An owner-defined PS1 decorator is applied after Shell-Color regeneration.
# It does not create a command wrapper or fork a network process.
shell_color_decorator_test() {
  PS1="[ UpdateWulf ::: cached ]"$'\n'"$PS1"
}
SHELL_COLOR_PS1_DECORATOR=shell_color_decorator_test
shell-color-apply >/dev/null 2>&1
case "$PS1" in
  '[ UpdateWulf ::: cached ]'*) ;;
  *) printf 'Owner PS1 decorator did not survive Shell-Color apply.\n' >&2; exit 1 ;;
esac
unset SHELL_COLOR_PS1_DECORATOR
unset -f shell_color_decorator_test

# Path positioning is persisted and reflected in the active configuration.
shell-color --path-position outside >/dev/null 2>&1
test "$(<"$test_home/.config/shell-color/path_position")" = "outside"
grep -Fq 'path_position=outside' <<<"$(shell-color --current)"
shell-color --path-position inside >/dev/null 2>&1
test "$(<"$test_home/.config/shell-color/path_position")" = "inside"

# Terminal-global OSC mutations are opt-in so SSH sessions cannot recolor parent/local shells.
unset SHELL_COLOR_TERMINAL_GLOBAL
if __shell_color_terminal_global_enabled; then
  printf 'Terminal-global recoloring unexpectedly enabled by default.\n' >&2
  exit 1
fi
SHELL_COLOR_TERMINAL_GLOBAL=1
__shell_color_terminal_global_enabled
unset SHELL_COLOR_TERMINAL_GLOBAL

# The colored cursor explicitly enables blinking and requests a blinking block.
test "$(__shell_color_cursor_sequence '#5fffaf')" = $'\033]12;#5fffaf\007\033[?12h\033[1 q'

# IP modes promote the matching base style; unsetting demotes it again.
shell-color --style brackets >/dev/null 2>&1
shell-color --set local >/dev/null 2>&1
test "$(<"$test_home/.config/shell-color/ps1_style")" = "brackets-ip"
shell-color --unset local >/dev/null 2>&1
test "$(<"$test_home/.config/shell-color/ps1_style")" = "brackets"

# Selecting an IP style enables the local mode when no IP mode is active.
shell-color --style arrow-ip >/dev/null 2>&1
test "$(<"$test_home/.config/shell-color/ps1_style")" = "arrow-ip"
test "$(<"$test_home/.config/shell-color/ip_mode")" = "local"

if grep -Rni --exclude-dir=.git 'n''eon' "$PROJECT_DIR" >/dev/null; then
  printf 'Forbidden legacy name found.\n' >&2
  exit 1
fi

# A managed PC-MESH block is never a reason to wipe the owner's PS1 or
# Shell-Color loader. Diagnose first; restore only if its known runtime exists.
recovery_home="$(mktemp -d)"
mkdir -p "$recovery_home/.local/share/shell-color"
printf '# runtime fixture\n' > "$recovery_home/.local/share/shell-color/shell-color.sh"
printf '%s\n' 'PS1="COLORFUL> "' '# BEGIN PC-MESH' '# status hook' '# END PC-MESH' > "$recovery_home/.bashrc"
if HOME="$recovery_home" bash "$PROJECT_DIR/install/repair-shell-color-bash.sh" --audit >/dev/null; then
  printf 'Missing shell-color loader was not detected.\n' >&2; exit 1
fi
HOME="$recovery_home" bash "$PROJECT_DIR/install/repair-shell-color-bash.sh" --apply >/dev/null
HOME="$recovery_home" bash "$PROJECT_DIR/install/repair-shell-color-bash.sh" --apply >/dev/null
grep -Fq 'PS1="COLORFUL> "' "$recovery_home/.bashrc"
grep -Fq '# BEGIN PC-MESH' "$recovery_home/.bashrc"
test "$(grep -Fc '# >>> shell-color setup >>>' "$recovery_home/.bashrc")" -eq 1
test "$(find "$recovery_home" -name '*.bak' | wc -l)" -eq 1
rm -rf -- "$recovery_home"

printf 'Linux tests passed.\n'
