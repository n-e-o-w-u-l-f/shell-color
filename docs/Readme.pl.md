# Shell-Color

[English](../Readme.md) · [Deutsch](Readme.de.md) · [Français](Readme.fr.md) · [Español](Readme.es.md) · [Русский](Readme.ru.md) · [Polski](Readme.pl.md)

Shell-Color to narzędzie o otwartym kodzie źródłowym do zmiany kolorów znaku zachęty w systemach **Linux, Windows, NetBSD i FreeBSD**.

## Instalacja

| Platforma | Powłoka | Instalacja |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh` lub receptura pakietu z katalogu `packaging/` |
| NetBSD | Powłoka systemowa `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | Powłoka systemowa `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD i NetBSD z zainstalowanym Bashem | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+, PowerShell 7+ lub cmd.exe | `windows/install.ps1` lub `windows/install.cmd` |

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

Znak zachęty włącza się przy następnym uruchomieniu powłoki interaktywnej lub logowania. Instalatory użytkownika zachowują istniejące pliki startowe i nie zmieniają powłoki logowania. NetBSD korzysta z mechanizmu `promptcmds`, a FreeBSD z własnych sekwencji sterujących PS1. Warianty BSD nie wysyłają żądań sieciowych. Dodatkowe funkcje Basha są dostępne po zainstalowaniu i uruchomieniu wersji dla Basha.

Dokumentacja dla [FreeBSD](FREEBSD.md), [NetBSD](NETBSD.md), [Windows](WINDOWS.md) i [budowania pakietów](PACKAGING.md).

## Wydania publiczne

Proces publikacji dla tagów zaczynających się od `v` tworzy pakiety dla obsługiwanych systemów Linux, archiwum ZIP dla Windows oraz przenośne archiwa z kodem źródłowym dla NetBSD i FreeBSD. Dla plików tworzone są sumy kontrolne SHA-256. Archiwa BSD zawierają kod źródłowy i nie zawierają natywnych pakietów binarnych.

Licencja [MIT](../LICENCE.md).
