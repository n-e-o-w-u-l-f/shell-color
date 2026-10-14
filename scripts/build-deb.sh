#!/usr/bin/env bash
set -euo pipefail

command -v dpkg-deb >/dev/null 2>&1 || { printf 'dpkg-deb is required.\n' >&2; exit 1; }
PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(<"$PROJECT_DIR/VERSION")"
ARCH="${PACKAGE_ARCH:-all}"
STAGE="$PROJECT_DIR/build/deb"
OUTPUT="$PROJECT_DIR/dist/shell-color_${VERSION}_${ARCH}.deb"

rm -rf -- "$STAGE"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" "$STAGE/usr/share/shell-color" \
  "$STAGE/usr/share/doc/shell-color" "$STAGE/etc/profile.d" "$PROJECT_DIR/dist"
install -m 0755 "$PROJECT_DIR/bin/shell-color" "$STAGE/usr/bin/shell-color"
install -m 0644 "$PROJECT_DIR/src/shell-color.sh" "$STAGE/usr/share/shell-color/shell-color.sh"
install -m 0644 "$PROJECT_DIR/profile.d/shell-color.sh" "$STAGE/etc/profile.d/shell-color.sh"
install -m 0644 "$PROJECT_DIR/LICENCE.md" "$STAGE/usr/share/doc/shell-color/LICENCE.md"
sed -e "s/@VERSION@/$VERSION/g" -e "s/@ARCH@/$ARCH/g" "$PROJECT_DIR/packaging/debian/control" > "$STAGE/DEBIAN/control"
dpkg-deb --root-owner-group --build "$STAGE" "$OUTPUT"
printf '%s\n' "$OUTPUT"
