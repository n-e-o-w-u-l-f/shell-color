[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$parseFailures = New-Object System.Collections.Generic.List[string]

Push-Location $projectRoot
try {
    $powershellFiles = @(
        Get-ChildItem -LiteralPath (Join-Path $projectRoot 'ci') -File |
            Where-Object { $_.Extension -in @('.ps1', '.psd1', '.psm1') }
        Get-ChildItem -LiteralPath (Join-Path $projectRoot 'tests') -File |
            Where-Object { $_.Extension -in @('.ps1', '.psd1', '.psm1') }
        Get-ChildItem -LiteralPath (Join-Path $projectRoot 'windows') -Recurse -File |
            Where-Object { $_.Extension -in @('.ps1', '.psd1', '.psm1') }
    )

    foreach ($file in $powershellFiles) {
        $tokens = $null
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile(
            $file.FullName,
            [ref]$tokens,
            [ref]$errors
        )
        foreach ($parseError in $errors) {
            $relativePath = $file.FullName.Substring($projectRoot.Length + 1)
            $parseFailures.Add("${relativePath}: $($parseError.Message)")
        }
    }

    if ($parseFailures.Count -gt 0) {
        throw "PowerShell syntax validation failed:`n$($parseFailures -join "`n")"
    }

    $manifest = Join-Path $projectRoot 'windows\ShellColor\ShellColor.psd1'
    $null = Test-ModuleManifest -Path $manifest -ErrorAction Stop
    & (Join-Path $projectRoot 'tests\test-windows.ps1')
    Write-Host 'Local Windows CI passed.'
}
finally {
    Pop-Location
}
