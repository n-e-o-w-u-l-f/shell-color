#!/usr/bin/env bash
set -euo pipefail

command -v rpmbuild >/dev/null 2>&1 || { printf 'rpmbuild is required.\n' >&2; exit 1; }
PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(<"$PROJECT_DIR/VERSION")"
TOPDIR="$PROJECT_DIR/build/rpmbuild"

rm -rf -- "$TOPDIR"
mkdir -p "$TOPDIR"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} "$PROJECT_DIR/dist"
cp "$PROJECT_DIR/src/shell-color.sh" "$TOPDIR/SOURCES/"
cp "$PROJECT_DIR/bin/shell-color" "$TOPDIR/SOURCES/"
cp "$PROJECT_DIR/profile.d/shell-color.sh" "$TOPDIR/SOURCES/shell-color-profile.sh"
cp "$PROJECT_DIR/LICENCE.md" "$TOPDIR/SOURCES/"
sed "s/@VERSION@/$VERSION/g" "$PROJECT_DIR/packaging/rpm/shell-color.spec" > "$TOPDIR/SPECS/shell-color.spec"
rpmbuild --define "_topdir $TOPDIR" -bb "$TOPDIR/SPECS/shell-color.spec"
find "$TOPDIR/RPMS" -type f -name '*.rpm' -exec cp -v {} "$PROJECT_DIR/dist/" \;
