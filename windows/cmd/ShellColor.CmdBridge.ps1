param(
    [Parameter(Mandatory = $true)][string]$ModulePath,
    [Parameter(Mandatory = $true)][string]$Action,
    [string]$Value
)

$ErrorActionPreference = 'Stop'
Import-Module $ModulePath -Force

switch ($Action.ToLowerInvariant()) {
    '--set'      { Set-ShellColor -Color $Value | Format-List }
    '--style'    { Set-ShellColor -Style $Value | Format-List }
    '--label'    { Set-ShellColor -Label $Value | Format-List }
    '--path'     { Set-ShellColor -Path $Value | Format-List }
    '--user'     { Set-ShellColor -User $Value | Format-List }
    '--computer' { Set-ShellColor -Computer $Value | Format-List }
    '--ip'       { Set-ShellColor -Ip $Value | Format-List }
    '--current'  { Get-ShellColor | Format-List }
    '--list'     { Show-ShellColorPalette }
    '--aliases'  { Show-ShellColorAliases }
    '--apply'    { Get-ShellColor | Format-List }
    '--reset'    { Reset-ShellColor -Confirm:$false | Format-List }
    '--version'  { shell-color --version }
    '--help'     { shell-color --help }
    default      { shell-color $Action }
}
