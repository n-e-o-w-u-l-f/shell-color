# Shell-Color on FreeBSD

Shell-Color supports the FreeBSD native `/bin/sh` prompt and the full Bash runtime when Bash is installed.

## Native /bin/sh installation

```sh
sh install/install-freebsd.sh
# Open a new login/interactive sh session to activate.
shell-color-freebsd --set 85
shell-color-freebsd --style brackets
shell-color-freebsd --current
```

A user install writes only dedicated guarded blocks to `~/.shrc` and `~/.profile`, makes backups, leaves the login shell untouched and does not replace an existing `shell-color` executable. Run `sh install/install-freebsd.sh --no-modify-rc` to install without modifying startup files. An explicit custom prefix must be absolute.

FreeBSD sh supports native `PS1` tokens `\\u`, `\\h`, `\\w`, `\\$` and nonprinting sequences `\\[` / `\\]`; this adapter uses those without executing code or network queries per prompt. Changes take effect in a **new** shell session. NetBSD is different: its native sh uses `promptcmds` for live rendering; do not source the NetBSD adapter on FreeBSD.

The adapter accepts `compact`, `brackets`, `arrow` and `keep`. The original prompt is preserved when `keep` is selected or the adapter is disabled. `NO_COLOR` and `TERM=dumb` suppress ANSI escape codes.

## Bash on FreeBSD

If installed through FreeBSD packages (`/usr/local/bin/bash`), the existing `src/shell-color.sh` and `install/install.sh` implement the richer Bash palette and all layouts. Install with the Bash installer and source it from `~/.bashrc` (the native sh adapter will skip Bash).
