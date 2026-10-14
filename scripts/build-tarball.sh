#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(<"$PROJECT_DIR/VERSION")"
DIST_DIR="$PROJECT_DIR/dist"
STAGE_DIR="$PROJECT_DIR/build/shell-color-$VERSION"

rm -rf -- "$STAGE_DIR"
mkdir -p "$STAGE_DIR"
# Use only files physically present in the reviewed source tree. The public
# export is intentionally narrower than the private development checkout.
for item in bin ci docs install packaging profile.d scripts src tests windows \
  README.md README.de.md README.fr.md README.es.md README.ru.md README.pl.md \
  README.cn.md CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md \
  LICENCE.md SECURITY.md SUPPORT.md Makefile flake.nix VERSION
do
  [ ! -e "$PROJECT_DIR/$item" ] || cp -R "$PROJECT_DIR/$item" "$STAGE_DIR/"
done
mkdir -p "$DIST_DIR"
tar -C "$PROJECT_DIR/build" -czf "$DIST_DIR/shell-color-$VERSION.tar.gz" "shell-color-$VERSION"
printf '%s\n' "$DIST_DIR/shell-color-$VERSION.tar.gz"
