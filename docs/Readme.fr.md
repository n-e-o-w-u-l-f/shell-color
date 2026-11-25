# Shell-Color

[English](../Readme.md) · [Deutsch](Readme.de.md) · [Français](Readme.fr.md) · [Español](Readme.es.md) · [Русский](Readme.ru.md) · [Polski](Readme.pl.md)

Shell-Color est un outil libre de personnalisation des couleurs de l’invite de commande sous **Linux, Windows, NetBSD et FreeBSD**.

## Installation

| Plateforme | Shell | Installation |
|---|---|---|
| Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora, Alpine, Void, Gentoo, NixOS | Bash | `bash install/install.sh` ou une recette de paquet dans `packaging/` |
| NetBSD | Shell système `/bin/sh` | `sh install/install-netbsd.sh` |
| FreeBSD | Shell système `/bin/sh` | `sh install/install-freebsd.sh` |
| FreeBSD et NetBSD avec Bash installé | Bash | `bash install/install.sh` |
| Windows 10/11 | PowerShell 5.1+, PowerShell 7+ ou cmd.exe | `windows/install.ps1` ou `windows/install.cmd` |

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

L’invite s’active à la prochaine ouverture d’un shell interactif ou de connexion. Les scripts d’installation préservent les fichiers de démarrage existants et ne modifient pas le shell de connexion. NetBSD utilise `promptcmds` et FreeBSD ses propres séquences d’échappement pour PS1. Les invites BSD n’effectuent aucune requête réseau. Pour accéder aux fonctions supplémentaires de Bash, installez et utilisez la version Bash.

Documentation pour [FreeBSD](FREEBSD.md), [NetBSD](NETBSD.md), [Windows](WINDOWS.md) et la [création de paquets](PACKAGING.md).

## Versions publiques

Le workflow de publication associé aux tags commençant par `v` crée des paquets Linux lorsque la plateforme est prise en charge, une archive ZIP pour Windows et des archives source portables pour NetBSD et FreeBSD. Il produit des sommes de contrôle SHA-256 pour ces fichiers. Les archives BSD contiennent le code source et aucun paquet binaire natif.

Licence [MIT](../LICENCE.md).
