# NetBSD 11 native shell-color adapter

Status: native NetBSD 11 installation and isolated adapter tests verified on 14 October 2026.

The standard Bash runtime is for Bash 4+ and must not be sourced from NetBSD
`/bin/sh`. The native POSIX adapter is `src/shell-color-netbsd.sh`; it
integrates with NetBSD sh's `promptcmds` option and editline's `PSlit`
nonprinting delimiters. It does not change a user's shell, the system's
`/etc/profile`, routing, firewall, package database, or terminal-global palette.

## Native NetBSD /bin/sh installation

Use a reviewed checkout of this branch; never run a shell installer piped
directly from an unaudited URL.

```sh
cd /path/to/shell-color
sh -n src/shell-color-netbsd.sh bin/shell-color-netbsd install/install-netbsd.sh
sh tests/test-netbsd.sh
sh install/install-netbsd.sh
. "$HOME/.shrc"
```

The installer copies the runtime into
`~/.local/share/shell-color/shell-color-netbsd.sh`, the management
command to `~/.local/bin/shell-color-netbsd`, and creates
`~/.local/bin/shell-color` only if there is no existing command there.
It appends an idempotent, isolated marked block to `~/.shrc`, backs up
the original, and preserves other startup/profile files and installed
UpdateWulf workers. No root access is required. A new interactive
`/bin/sh` naturally loads `~/.shrc` when the user's normal shell
startup configuration does so.

Use `shell-color --set 85`, `shell-color --style brackets` and
`shell-color --current`. Supported native layouts are
`compact`, `brackets`, `arrow`, `keep`; `keep` leaves the
original `PS1` intact. Native sh support implements numeric xterm
0–255 accents and prompt layouts, not the full Bash command surface.

## Show UpdateWulf above native NetBSD prompt

The optional cache-only status integration uses the existing agent's
`fleet-prompt.netbsd.WIDTH`, not a network request or process watcher.

```sh
# Use the actual verified state path on HP if available:
SHELL_COLOR_NETBSD_UPDATEWULF=1
SHELL_COLOR_NETBSD_STATE=/var/db/pc-mesh
export SHELL_COLOR_NETBSD_UPDATEWULF SHELL_COLOR_NETBSD_STATE
```

The new UpdateWulf daemon generates width-specific single-line files with `PSlit`
nonprinting wrappers around ANSI sequences; its status comes from the cached
authenticated fleet snapshot, not from a shell command or Tailscale query.
Legacy UpdateWulf workers do not create it, so upgrade the worker before
enabling this optional extension.

Place these settings *before* the shell-color NetBSD managed block in
the interactive owner's `~/.shrc`, only after checking that the file is
readable and contains the existing fleet status. The adapter renders
that cached line as part of the prompt, never by `printf` outside it.
No update count is fabricated for stale/offline nodes.

## Acceptance criteria

1. `uname -s` reports NetBSD, `echo "$0"` confirms the target shell;
   original dotfiles, PATH, PS1 backup and `PROMPT_COMMAND` recorded
   before changes.
2. `sh tests/test-netbsd.sh` passes, `PS1` is nonempty, path segments
   track directory changes, and color rendering does not break editline.
3. Interactive and SSH owner shells preserve working keyboard editing,
   command-history navigation and line wrapping; UpdateWulf appears only
   inside the prompt when opted in.
4. Existing UpdateWulf worker PID and heartbeat remain intact; no
   new daemon, cron supervisor, sudo action or reboot.
5. Native uninstall/rollback consists of restoring the saved `~/.shrc`
   and previous `PS1` in a new interactive shell. Never remove unrelated
   shell-color installations or global files.

The portability smoke test can run on Linux; it does not establish
live NetBSD 11 editline acceptance. Real HP verification is required.
