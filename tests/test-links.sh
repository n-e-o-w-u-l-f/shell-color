#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

while IFS= read -r file; do
  while IFS= read -r token; do
    target="${token#](}"
    target="${target%)}"
    target="${target%%#*}"
    case "$target" in
      ''|http://*|https://*|mailto:*) continue ;;
    esac
    if [[ ! -e "$(dirname "$file")/$target" ]]; then
      printf 'Dead local link in %s: %s\n' "${file#"$PROJECT_DIR/"}" "$target" >&2
      status=1
    fi
  done < <(rg -o --no-filename '\]\([^)]*\)' "$file" || true)
done < <(find "$PROJECT_DIR" -type f -name '*.md' \
  -not -path '*/.git/*' -not -path '*/build/*' -not -path '*/dist/*' | sort)

if [[ "$status" == "0" ]]; then
  printf 'Markdown links passed.\n'
fi
exit "$status"
