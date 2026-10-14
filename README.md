# Shell-Color

Open-source terminal prompt colour toolkit for **Linux, Windows, NetBSD and FreeBSD**. This public distribution is exported from a separate private development repository using an explicit allowlist, secret scanner and tests. It contains no private Git history or machine-specific configuration.

## Installation

| Platform | Shell | Installation |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh`, or use the recipe under `packaging/` |
| NetBSD | Native `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | Native `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD / NetBSD with Bash available | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+ / 7+ or cmd.exe | `windows/install.ps1` or `windows/install.cmd` |

```sh
# NetBSD
sh install/install-netbsd.sh
shell-color-netbsd --set 85
shell-color-netbsd --style brackets

# FreeBSD
sh install/install-freebsd.sh
shell-color-freebsd --set 85
shell-color-freebsd --style brackets
```

The next login/interactive shell activates the prompt. The user installers preserve existing startup files and do not change your login shell. NetBSD uses its documented `promptcmds` mechanism; FreeBSD uses its native PS1 escape sequences. The BSD prompts do not perform network requests. For extra Bash capabilities, install and use the Bash runtime.

Documentation: [FreeBSD](docs/FREEBSD.md), [NetBSD](docs/NETBSD.md), [Windows](docs/WINDOWS.md), [packaging](docs/PACKAGING.md).

## Reproducible public releases

The `v*` public release workflow builds Linux packages when supported, a Windows ZIP, and **portable source tarballs for NetBSD and FreeBSD**, with SHA-256 checksums. No cross-built native BSD binary is claimed. Public CI uses free standard hosted runners in this public repository only; the private release does not require paid infrastructure.

License: [MIT](LICENCE.md).
