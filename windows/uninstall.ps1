[CmdletBinding()]
param(
    [string]$InstallRoot = (Join-Path $env:LOCALAPPDATA 'Programs\shell-color'),
    [switch]$RemoveConfiguration
)

$ErrorActionPreference = 'Stop'
$beginMarker = '# >>> shell-color setup >>>'
$endMarker = '# <<< shell-color setup <<<'
$documents = [Environment]::GetFolderPath('MyDocuments')
$profiles = @(
    (Join-Path $documents 'PowerShell\profile.ps1'),
    (Join-Path $documents 'WindowsPowerShell\profile.ps1'),
    $PROFILE.CurrentUserAllHosts
) | Select-Object -Unique

foreach ($profilePath in $profiles) {
    if (Test-Path -LiteralPath $profilePath) {
        $content = Get-Content -LiteralPath $profilePath -Raw
        $pattern = '(?ms)^' + [regex]::Escape($beginMarker) + '.*?^' + [regex]::Escape($endMarker) + '\r?\n?'
        $updated = [regex]::Replace($content, $pattern, '')
        Set-Content -LiteralPath $profilePath -Value $updated -Encoding UTF8
    }
}

$commandProcessor = 'HKCU:\Software\Microsoft\Command Processor'
$backupKey = 'HKCU:\Software\shell-color'
$backup = Get-ItemProperty -Path $backupKey -ErrorAction SilentlyContinue
if ($backup -and $backup.AutoRunBackedUp) {
    if ([string]::IsNullOrEmpty([string]$backup.AutoRunBackup)) {
        Remove-ItemProperty -Path $commandProcessor -Name AutoRun -ErrorAction SilentlyContinue
    }
    else {
        Set-ItemProperty -Path $commandProcessor -Name AutoRun -Value ([string]$backup.AutoRunBackup)
    }
    Remove-Item -Path $backupKey -Recurse -Force -ErrorAction SilentlyContinue
}

Remove-Item -LiteralPath $InstallRoot -Recurse -Force -ErrorAction SilentlyContinue

if ($RemoveConfiguration) {
    $configRoot = if ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'shell-color' } else { Join-Path $HOME '.config\shell-color' }
    Remove-Item -LiteralPath $configRoot -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host 'shell-color was removed. Open a new terminal window.'
