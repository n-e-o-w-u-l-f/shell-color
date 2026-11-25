# Shell-Color

[English](../Readme.md) · [Deutsch](Readme.de.md) · [Français](Readme.fr.md) · [Español](Readme.es.md) · [Русский](Readme.ru.md) · [Polski](Readme.pl.md)

Shell-Color ist ein quelloffenes Werkzeug für farbige Eingabeaufforderungen unter **Linux, Windows, NetBSD und FreeBSD**.

## Installation

| Plattform | Shell | Installation |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh` oder ein Paketrezept unter `packaging/` |
| NetBSD | System-Shell `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | System-Shell `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD und NetBSD mit installiertem Bash | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+, PowerShell 7+ oder cmd.exe | `windows/install.ps1` oder `windows/install.cmd` |

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

Die Eingabeaufforderung wird bei der nächsten interaktiven Shell oder Anmeldung aktiviert. Die Benutzerinstaller erhalten vorhandene Startdateien und ändern die Anmeldeshell nicht. NetBSD verwendet `promptcmds`, FreeBSD verwendet seine eigenen PS1-Escapesequenzen. Die BSD-Varianten führen keine Netzwerkanfragen aus. Für die zusätzlichen Bash-Funktionen installieren und verwenden Sie die Bash-Variante.

Dokumentation zu [FreeBSD](FREEBSD.md), [NetBSD](NETBSD.md), [Windows](WINDOWS.md) und [Paketierung](PACKAGING.md).

## Öffentliche Releases

Der Release-Workflow für Tags mit dem Präfix `v` erstellt Linux-Pakete für unterstützte Systeme, ein Windows-ZIP und portable Quellarchive für NetBSD und FreeBSD. Er erzeugt SHA-256-Prüfsummen für die Dateien. Die BSD-Archive enthalten Quellcode und keine nativen BSD-Binärpakete.

Lizenz [MIT](../LICENCE.md).
