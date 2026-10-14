#!/usr/bin/env bash
set -euo pipefail

command -v zstd >/dev/null 2>&1 || { printf 'zstd is required.\n' >&2; exit 1; }
PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(<"$PROJECT_DIR/VERSION")"
ARCH="any"
STAGE="$PROJECT_DIR/build/arch/pkg"
OUTPUT="$PROJECT_DIR/dist/shell-color-${VERSION}-1-${ARCH}.pkg.tar.zst"
GZIP_OUTPUT="$PROJECT_DIR/dist/shell-color-${VERSION}-1-${ARCH}.pkg.tar.gz"

rm -rf -- "$PROJECT_DIR/build/arch"
mkdir -p "$STAGE/usr/bin" "$STAGE/usr/share/shell-color" \
  "$STAGE/usr/share/licenses/shell-color" "$STAGE/etc/profile.d" "$PROJECT_DIR/dist"
install -m 0755 "$PROJECT_DIR/bin/shell-color" "$STAGE/usr/bin/shell-color"
install -m 0644 "$PROJECT_DIR/src/shell-color.sh" "$STAGE/usr/share/shell-color/shell-color.sh"
install -m 0644 "$PROJECT_DIR/profile.d/shell-color.sh" "$STAGE/etc/profile.d/shell-color.sh"
install -m 0644 "$PROJECT_DIR/LICENCE.md" "$STAGE/usr/share/licenses/shell-color/LICENCE.md"
cat > "$STAGE/.PKGINFO" <<EOF
pkgname = shell-color
pkgbase = shell-color
pkgver = ${VERSION}-1
pkgdesc = Customizable xterm-256 Bash prompts and output coloring
url = https://github.com/n-e-o-w-u-l-f/shell-color
builddate = $(date +%s)
packager = shell-color release workflow
size = $(du -sb "$STAGE" | awk '{print $1}')
arch = $ARCH
license = MIT
depend = bash
EOF
tar -C "$STAGE" --sort=name --owner=0 --group=0 -cf - . | zstd -19 -T0 -o "$OUTPUT"
tar -C "$STAGE" --sort=name --owner=0 --group=0 -czf "$GZIP_OUTPUT" .
printf '%s\n' "$OUTPUT"
printf '%s\n' "$GZIP_OUTPUT"
