# Shell-Color

[English](../Readme.md) · [Deutsch](Readme.de.md) · [Français](Readme.fr.md) · [Español](Readme.es.md) · [Русский](Readme.ru.md) · [Polski](Readme.pl.md)

Shell-Color — инструмент с открытым исходным кодом для настройки цветов приглашения командной строки в **Linux, Windows, NetBSD и FreeBSD**.

## Установка

| Платформа | Оболочка | Установка |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh` или рецепт сборки из каталога `packaging/` |
| NetBSD | Системная оболочка `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | Системная оболочка `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD и NetBSD с установленным Bash | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+, PowerShell 7+ или cmd.exe | `windows/install.ps1` или `windows/install.cmd` |

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

Приглашение активируется при следующем запуске интерактивной оболочки или оболочки входа. Пользовательские установщики сохраняют существующие файлы запуска и не меняют оболочку входа. NetBSD использует механизм `promptcmds`, а FreeBSD — собственные управляющие последовательности PS1. Приглашения BSD не отправляют сетевых запросов. Для дополнительных возможностей Bash установите и используйте версию для Bash.

Документация для [FreeBSD](FREEBSD.md), [NetBSD](NETBSD.md), [Windows](WINDOWS.md) и [сборки пакетов](PACKAGING.md).

## Публичные выпуски

Процесс публикации для тегов, начинающихся с `v`, собирает пакеты для поддерживаемых систем Linux, ZIP-архив для Windows и переносимые архивы с исходным кодом для NetBSD и FreeBSD. Для файлов вычисляются контрольные суммы SHA-256. Архивы BSD содержат исходный код и не включают готовые двоичные пакеты.

Лицензия [MIT](../LICENCE.md).
