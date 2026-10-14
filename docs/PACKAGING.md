# Packaging guide

Package metadata is stored in `VERSION` without the tag prefix (`1.33.7a`). The
public release and CLI version is `v1.33.7a`. Before a release, update the runtime
version, PowerShell manifest/module versions, packaging recipes, README examples,
and `CHANGELOG.md` in one commit.

## Build targets

| Target | Tool | Output |
|---|---|---|
| `make tarball` | `tar`, `gzip` | portable `.tar.gz` |
| `make deb` | `dpkg-deb` | Debian/Ubuntu `.deb` |
| `make rpm` | `rpmbuild` | Fedora/RHEL/openSUSE `.rpm` |
| `make arch` | `tar`, `zstd` | `.pkg.tar.zst` and legacy `.pkg.tar.gz` |
| `make packages` | all available tools | all targets above |

## Local CI entry points

Run `./ci/linux.sh` to execute Linux tests, Markdown-link validation, ShellCheck,
and the portable/deb package builds. It requires Bash, GNU Make, `ripgrep`,
ShellCheck, `tar`, `gzip`, and `dpkg-deb`.

Run `pwsh -NoProfile -File ./ci/windows.ps1` to parse every PowerShell source
file, validate the module manifest, and execute the Windows regression tests.
The same script supports Windows PowerShell 5.1 and PowerShell 7+. The GitHub
Actions workflow calls these checked-in entry points directly.

Recipes for official ecosystem build tools are kept in `packaging/arch`,
`packaging/alpine`, `packaging/void`, `packaging/gentoo`, and `packaging/nix`.
The Nix flake is at the repository root so it can be consumed directly.

The `SKIP` checksums in source recipes are development placeholders. Before
submitting a recipe to an official distribution repository, replace them with
the checksums of the immutable signed release archive.

## Release automation

Push the signed release tag `v1.33.7a`. The release workflow runs
tests, builds artifacts, generates SHA-256 checksums, and publishes them to the
corresponding GitHub release. Do not commit generated packages to `main`.
