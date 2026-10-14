param(
    [Parameter(Mandatory = $true)][string]$ModulePath,
    [string]$Location = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
Import-Module $ModulePath -Force
[Console]::Out.Write((Get-ShellColorPrompt -Shell Cmd -Location $Location))
