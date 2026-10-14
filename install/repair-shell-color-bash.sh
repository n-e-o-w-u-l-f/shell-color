#!/usr/bin/env bash
# Inspect/recover Shell-Color Bash startup integration without changing PS1
# in the caller's running session or replacing unrelated dotfile content.
set -euo pipefail
mode="${1:---audit}"
[[ "$mode" == --audit || "$mode" == --apply ]] || {
  printf 'Usage: repair-shell-color-bash.sh [--audit|--apply]\n' >&2
  exit 2
}
home="${HOME:?HOME required}"
rc="$home/.bashrc"
runtime=''
for candidate in "$home/.local/share/shell-color/shell-color.sh" \
                 /usr/local/share/shell-color/shell-color.sh \
                 /usr/share/shell-color/shell-color.sh; do
  if [[ -r "$candidate" ]]; then runtime="$candidate"; break; fi
done
if [[ -z "$runtime" ]]; then
  printf 'NO_RUNTIME: no installed shell-color Bash runtime; no changes made\n'
  exit 3
fi
if [[ -L "$rc" ]]; then
  printf 'SYMLINK_RC: preserve and inspect target manually; no changes made\n'
  exit 3
fi
start='# >>> shell-color setup >>>'
end='# <<< shell-color setup <<<'
if [[ -r "$rc" ]]; then
  if grep -Fq "$start" "$rc" || grep -Fq "$end" "$rc"; then
    if ! grep -Fq "$start" "$rc" || ! grep -Fq "$end" "$rc"; then
      printf 'BROKEN_MARKERS: inspect prior setup; no changes made\n'
      exit 3
    fi
    # Existing managed block might point to a different runtime; do not
    # overwrite it without first inspecting actual user preferences.
    printf 'EXISTING_MARKER: check existing shell-color path and login-shell load order\n'
    exit 0
  fi
  if grep -E '^[[:space:]]*(source|\.)[[:space:]].*shell-color\.sh' "$rc" >/dev/null; then
    printf 'EXISTING_CUSTOM_LOADER: preserve custom shell-color startup\n'
    exit 0
  fi
fi
if [[ "$mode" == --audit ]]; then
  printf 'MISSING_LOADER: runtime=%s rc=%s (use --apply after reviewing)\n' "$runtime" "$rc"
  exit 1
fi
mkdir -p "$(dirname "$rc")"
if [[ -e "$rc" ]]; then
  backup="$rc.shell-color-recovery-$(date +%Y%m%d%H%M%S).bak"
  cp -p "$rc" "$backup"
else
  : > "$rc"
fi
# Double-quote validated installed path as data; reject names containing
# shell metacharacters instead of evaluating them in the owner's rc file.
case "$runtime" in *[!A-Za-z0-9_./-]*)
    printf 'Unsafe path characters; no new block installed\n' >&2
    exit 3 ;;
esac
{
  printf '\n%s\n' "$start"
  printf '[ -r "%s" ] && . "%s"\n' "$runtime" "$runtime"
  printf '%s\n' "$end"
} >> "$rc"
printf 'RECOVERED: managed shell-color Bash loader added after preserved content. Open a new shell to validate.\n'
