# Complete command reference

This document is the precise reference for version `v1.33.7a`. Installation examples
and platform overviews are in the [README](../README.md).

## Linux function and CLI

The interactive Bash runtime defines `shell-color` as a function so a setting can
immediately update the current shell. The installed executable loads the same
runtime for commands that only need to read or write persistent configuration.

| Command | Arguments | Persistence | Exit behavior |
|---|---|---|---|
| `shell-color --set COLOR` | index, xterm name, or alias | writes `color` | `2` for invalid/missing color |
| `shell-color COLOR` | index, xterm name, or alias | none | previews or returns `2` |
| `shell-color --style STYLE` | numeric or named style | writes `ps1_style` | `2` for invalid style |
| `shell-color --path-position inside\|outside` | path placement | writes `path_position` | `2` for invalid position |
| `shell-color --preview-styles` | none | none | previews all styles |
| `shell-color --set local` | none | writes `ip_mode`; promotes the matching base style | local lookup falls back to `local` |
| `shell-color --set ip` | none | writes `ip_mode` and `public_ip`; promotes the matching base style | `1` if network lookup fails |
| `shell-color --unset local|ip` | one mode name | disables both modes; demotes the matching IP style | `2` for invalid target |
| `shell-color --current` | none | none | prints one machine-readable line |
| `shell-color --list` | none | none | prints 256 entries |
| `shell-color --aliases` | none | none | prints extra aliases |
| `shell-color --apply` | none | none | rebuilds prompt and terminal colors |
| `shell-color --reset-palette` | none | none | resets palette, cursor color, and cursor shape on a TTY |
| `shell-color --pacman-colorize` | stdin | none | colors a read-only pipeline |
| `shell-color --version` | none | none | prints version |
| `shell-color --help` | none | none | prints help |

### Linux prompt styles

The original numeric values `1`–`5` remain stable. IP-specific layouts are
available as the additive values `6` and `7`.

| Value | Style | Rendered shape |
|---:|---|---|
| `1` | `keep` | Preserve the current `PS1`; shell-color does not replace it. |
| `2` | `compact` | `(user@host ~/folder/file.type) $` |
| `3` | `compact-ip` | `(user@host[192.0.2.25] ~/folder/file.type) $` |
| `4` | `arrow` | `<user@host ~/folder/file.type> $` |
| `5` | `brackets` | `[user@host ~/folder/file.type] $` |
| `6` | `arrow-ip` | `<user@host(192.0.2.25) ~/folder/file.type> $` |
| `7` | `brackets-ip` | `[user@host(192.0.2.25) ~/folder/file.type] $` |

Base styles never inherit an IP segment merely because an IP mode remains
configured. Selecting any `*-ip` style enables local IP mode when no mode is
active. `--set local` and `--set ip` promote `compact`, `arrow`, or `brackets`
to its matching IP style; `--unset local|ip` reverses that promotion.

The default path position is `inside`. `--path-position outside` closes the
selected layout immediately after the identity—for example,
`(user@host[192.0.2.25]) ~/folder/file.type $`. Both modes use exactly one space
before the prompt `$`.

On compatible terminals, shell-color sets the cursor to the selected accent
color with OSC 12, explicitly enables blinking with DECSET 12, and requests a
blinking block with DECSCUSR 1. Set
`SHELL_COLOR_DISABLE_CURSOR=1` to suppress both operations. Resetting the palette
also emits OSC 112 and DECSCUSR 0 to restore the terminal defaults.

Environment overrides: `SHELL_COLOR`, `SHELL_COLOR_PS1_STYLE`,
`SHELL_COLOR_PATH_POSITION`, `SHELL_COLOR_IP_MODE`, `SHELL_COLOR_THEME_FILE`, `SHELL_COLOR_STYLE_FILE`,
`SHELL_COLOR_PATH_POSITION_FILE`,
`SHELL_COLOR_IP_MODE_FILE`, `SHELL_COLOR_PUBLIC_IP_FILE`,
`SHELL_COLOR_PUBLIC_IP_SERVICE`, `SHELL_COLOR_DEFAULT`,
`SHELL_COLOR_DEFAULT_STYLE`, `SHELL_COLOR_DEFAULT_PATH_POSITION`,
`SHELL_COLOR_TERMINAL_GLOBAL=1` explicitly enables terminal-wide OSC palette/cursor mutation. It is disabled by default to keep shell-color scoped to the current shell and prevent SSH sessions from leaking colors into the parent/local shell. When enabled, `SHELL_COLOR_DISABLE_OSC256` and `SHELL_COLOR_DISABLE_CURSOR` can suppress the individual operations.

## PowerShell

`Set-ShellColor` accepts independent parameters, so a call may update one field or
several fields atomically. Parameters not supplied retain their saved values.

| Parameter | Type | Values | Default behavior |
|---|---|---|---|
| `-Color` | object | 0–255 or alias | retains current color |
| `-Style` | string | Keep, Windows, Compact, CompactIp, Arrow, Brackets | retains layout |
| `-Label` | string | Short, Bracketed, Full, None | retains label |
| `-Path` | string | Full, HomeRelative, Leaf | retains path mode |
| `-User` | string | On, Off | retains user visibility |
| `-Computer` | string | On, Off | retains computer visibility |
| `-Ip` | string | None, Local, Public | retains IP mode |
| `-SessionOnly` | switch | present/absent | skips saving when present |

`Reset-ShellColor` supports standard `-WhatIf` and `-Confirm` semantics.
`Get-ShellColorPrompt` accepts `-Shell PowerShell|Cmd` and an optional `-Location`
for rendering or testing a prompt without changing the process location.

`-SessionOnly` keeps the modified configuration in module memory for the current
PowerShell session and does not rewrite `config.json`. A later persistent
`Set-ShellColor` call saves the active values; re-importing the module without a
persistent call restores the last on-disk configuration. `Get-ShellColor` reports
the active IP address, text color, number color, and bold-number state in addition
to the user-selectable fields.

The portable `shell-color` function maps its double-dash syntax to these native
cmdlets. Invalid values raise a PowerShell terminating error with a descriptive
message.

## CMD

`shell-color.cmd` passes management operations to the PowerShell module and then
refreshes `%PROMPT%`. Its AutoRun setup defines DOSKEY macros for `shell-color`,
`cd`, `chdir`, `pushd`, and `popd`. Native CMD batch files are not modified.
