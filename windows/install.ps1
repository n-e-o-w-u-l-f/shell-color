[CmdletBinding()]
param(
    [string]$InstallRoot = (Join-Path $env:LOCALAPPDATA 'Programs\shell-color'),
    [bool]$EnableCmd = $true,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$sourceRoot = $PSScriptRoot
$moduleSource = Join-Path $sourceRoot 'ShellColor'
$cmdSource = Join-Path $sourceRoot 'cmd'
$moduleTarget = Join-Path $InstallRoot 'ShellColor'
$cmdTarget = Join-Path $InstallRoot 'cmd'
$moduleManifest = Join-Path $moduleTarget 'ShellColor.psd1'
$beginMarker = '# >>> shell-color setup >>>'
$endMarker = '# <<< shell-color setup <<<'

if ((Test-Path -LiteralPath $InstallRoot) -and $Force) {
    Remove-Item -LiteralPath $InstallRoot -Recurse -Force
}

$null = New-Item -ItemType Directory -Path $InstallRoot -Force
Copy-Item -LiteralPath $moduleSource -Destination $InstallRoot -Recurse -Force
Copy-Item -LiteralPath $cmdSource -Destination $InstallRoot -Recurse -Force

$documents = [Environment]::GetFolderPath('MyDocuments')
$profiles = @(
    (Join-Path $documents 'PowerShell\profile.ps1'),
    (Join-Path $documents 'WindowsPowerShell\profile.ps1'),
    $PROFILE.CurrentUserAllHosts
) | Select-Object -Unique

$escapedManifest = $moduleManifest.Replace("'", "''")
$block = @"
$beginMarker
Import-Module '$escapedManifest' -Force
if ((Get-ShellColor).Style -ne 'Keep') { Enable-ShellColorPrompt }
$endMarker
"@

foreach ($profilePath in $profiles) {
    $profileDirectory = Split-Path -Parent $profilePath
    $null = New-Item -ItemType Directory -Path $profileDirectory -Force
    if (-not (Test-Path -LiteralPath $profilePath)) {
        $null = New-Item -ItemType File -Path $profilePath -Force
    }
    $content = Get-Content -LiteralPath $profilePath -Raw -ErrorAction SilentlyContinue
    if ($content -notmatch [regex]::Escape($beginMarker)) {
        Add-Content -LiteralPath $profilePath -Value "`r`n$block" -Encoding UTF8
    }
}

if ($EnableCmd) {
    $commandProcessor = 'HKCU:\Software\Microsoft\Command Processor'
    $backupKey = 'HKCU:\Software\shell-color'
    $null = New-Item -Path $commandProcessor -Force
    $null = New-Item -Path $backupKey -Force
    $current = (Get-ItemProperty -Path $commandProcessor -Name AutoRun -ErrorAction SilentlyContinue).AutoRun
    if (-not (Get-ItemProperty -Path $backupKey -Name AutoRunBackedUp -ErrorAction SilentlyContinue)) {
        Set-ItemProperty -Path $backupKey -Name AutoRunBackup -Value ([string]$current)
        Set-ItemProperty -Path $backupKey -Name AutoRunBackedUp -Value 1 -Type DWord
    }
    $cmdEntry = 'call "' + (Join-Path $cmdTarget 'shell-color.cmd') + '" --autorun'
    if ([string]$current -notlike '*shell-color.cmd*') {
        $newValue = if ($current) { "$current & $cmdEntry" } else { $cmdEntry }
        Set-ItemProperty -Path $commandProcessor -Name AutoRun -Value $newValue
    }
}

Import-Module $moduleManifest -Force
if ((Get-ShellColor).Style -ne 'Keep') { Enable-ShellColorPrompt }

Write-Host "shell-color v1.33.7a installed in $InstallRoot"
Write-Host 'Open a new PowerShell or Command Prompt window to activate it.'
