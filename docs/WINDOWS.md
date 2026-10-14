# Windows implementation notes

The Windows implementation has one configuration source and two renderers.
PowerShell calls `Get-ShellColorPrompt` directly before every command. CMD asks
the same module to render a prompt and stores the result in `%PROMPT%`.

## PowerShell profile

The installer adds a marked block to current-user profiles for Windows PowerShell
and PowerShell. The block imports `ShellColor.psd1` and calls
`Enable-ShellColorPrompt`. Uninstallation removes only this marked block.

## Command Prompt AutoRun

The installer stores any existing `HKCU\Software\Microsoft\Command Processor`
`AutoRun` value below `HKCU\Software\shell-color`, then appends a guarded call to
`shell-color.cmd --autorun`. The uninstaller restores the original value.

CMD cannot execute a callback before every prompt. DOSKEY macros therefore
refresh the prompt after directory-changing built-ins. Child processes cannot
change their parent CMD working directory, so these built-ins cover normal
interactive directory changes. A manual `shell-color --apply` also refreshes it.

## Character rendering

The renderer classifies each Unicode character independently:

- letters use xterm color 250;
- digits use bold xterm color 15;
- every other character uses the selected accent index.

This includes drive colons, backslashes, spaces, dots, hyphens, underscores,
brackets, `@`, arrows, and the final prompt symbol. CMD dollar signs are escaped
after rendering so `%PROMPT%` does not treat them as prompt control sequences.
