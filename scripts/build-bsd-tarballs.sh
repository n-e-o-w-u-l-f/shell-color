#!/bin/sh
# Portable self-contained BSD shell archives. No root, network, or cross-compilers.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
version=$(cat "$root/VERSION")
mkdir -p "$root/dist"
for os in netbsd freebsd; do
    tmp=$(mktemp -d)
    pkg="shell-color-$version-$os"
    mkdir -p "$tmp/$pkg/src" "$tmp/$pkg/bin" "$tmp/$pkg/install" "$tmp/$pkg/docs"
    cp "$root/src/shell-color-$os.sh" "$tmp/$pkg/src/"
    cp "$root/bin/shell-color-$os" "$tmp/$pkg/bin/"
    cp "$root/install/install-$os.sh" "$tmp/$pkg/install/"
    doc=$(printf '%s' "$os" | tr '[:lower:]' '[:upper:]')
    cp "$root/docs/$doc.md" "$tmp/$pkg/docs/"
    cp "$root/VERSION" "$root/LICENCE.md" "$tmp/$pkg/"
    tar -C "$tmp" -czf "$root/dist/$pkg.tar.gz" "$pkg"
    rm -rf "$tmp"
    printf 'BSD_ARCHIVE_OK %s\n' "$root/dist/$pkg.tar.gz"
done
