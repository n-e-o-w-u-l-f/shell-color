# Shell-Color

[English](../Readme.md) · [Deutsch](Readme.de.md) · [Français](Readme.fr.md) · [Español](Readme.es.md) · [Русский](Readme.ru.md) · [Polski](Readme.pl.md)

Shell-Color es una herramienta de código abierto para personalizar los colores del indicador de comandos en **Linux, Windows, NetBSD y FreeBSD**.

## Instalación

| Plataforma | Intérprete | Instalación |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh` o una receta de empaquetado de `packaging/` |
| NetBSD | Intérprete del sistema `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | Intérprete del sistema `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD y NetBSD con Bash instalado | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+, PowerShell 7+ o cmd.exe | `windows/install.ps1` o `windows/install.cmd` |

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

El indicador se activa al abrir la próxima sesión interactiva o de inicio. Los instaladores de usuario conservan los archivos de arranque existentes y no cambian el intérprete de inicio de sesión. NetBSD utiliza `promptcmds` y FreeBSD sus propias secuencias de escape para PS1. Los indicadores de BSD no realizan solicitudes de red. Para utilizar las funciones adicionales de Bash, instala y ejecuta la versión para Bash.

Documentación de [FreeBSD](FREEBSD.md), [NetBSD](NETBSD.md), [Windows](WINDOWS.md) y [empaquetado](PACKAGING.md).

## Versiones públicas

El flujo de publicación para las etiquetas que empiezan por `v` genera paquetes para los sistemas Linux compatibles, un ZIP para Windows y archivos portables con el código fuente para NetBSD y FreeBSD. También genera las sumas de comprobación SHA-256. Los archivos BSD contienen código fuente y no incluyen paquetes binarios nativos.

Licencia [MIT](../LICENCE.md).
