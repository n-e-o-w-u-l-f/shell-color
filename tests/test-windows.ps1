$ErrorActionPreference = 'Stop'
$module = Join-Path $PSScriptRoot '..\windows\ShellColor\ShellColor.psd1'
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("shell-color-test-" + [guid]::NewGuid())
$oldLocalAppData = $env:LOCALAPPDATA

try {
    $env:LOCALAPPDATA = $testRoot
    Import-Module $module -Force
    Set-ShellColor -Color mint -Style Windows -Label Bracketed -Path Full -User Off -Computer Off | Out-Null
    $current = Get-ShellColor
    if ($current.Color -ne 85) { throw 'Color was not persisted.' }
    if ($current.Label -ne 'Bracketed') { throw 'Label was not persisted.' }
    if ($current.TextColor -ne 250) { throw 'Text color was not reported.' }
    if ($current.NumberColor -ne 15) { throw 'Number color was not reported.' }
    if (-not $current.BoldNumbers) { throw 'Bold-number state was not reported.' }
    $promptText = Get-ShellColorPrompt -Location 'C:\Users\example'
    $plainPrompt = $promptText -replace "$([char]27)\[[0-9;]*m", ''
    if ($plainPrompt -notmatch '^\[PS\]') { throw 'Bracketed PS label is missing.' }
    if ($plainPrompt -notmatch 'C:\\Users\\megal>') { throw 'Path is missing.' }

    Set-ShellColor -Label Full | Out-Null
    $fullLabelPrompt = Get-ShellColorPrompt -Location 'C:\Users\example'
    $fullLabelPlain = $fullLabelPrompt -replace "$([char]27)\[[0-9;]*m", ''
    if ($fullLabelPlain -notmatch '^PowerShell ') { throw 'Full PowerShell label is missing.' }

    Set-ShellColor -Label None | Out-Null
    $noLabelPrompt = Get-ShellColorPrompt -Location 'C:\Users\example'
    $noLabelPlain = $noLabelPrompt -replace "$([char]27)\[[0-9;]*m", ''
    if ($noLabelPlain -match '^(PS|\[PS\]|PowerShell) ') { throw 'PowerShell label was not hidden.' }

    Set-ShellColor -Label Bracketed | Out-Null
    $specialPrompt = Get-ShellColorPrompt -Location 'C:\Users\example1.one-two_three (a)[b]{c}@#$%&+~!'
    $accent = "$([char]27)[38;5;85m"
    foreach ($character in @(':', '\', '.', '-', '_', ' ', '(', ')', '[', ']', '{', '}', '@', '#', '$', '%', '&', '+', '~', '!', '>')) {
        if (-not $specialPrompt.Contains("$accent$character")) {
            throw "Special path or prompt character '$character' did not receive the accent color."
        }
    }
    $brightNumber = "$([char]27)[1;38;5;15m1"
    if (-not $specialPrompt.Contains($brightNumber)) {
        throw 'Path digits were not rendered with the bold number color.'
    }

    Set-ShellColor -Color 39 -Label Full -SessionOnly | Out-Null
    $session = Get-ShellColor
    if ($session.Color -ne 39 -or $session.Label -ne 'Full') {
        throw 'SessionOnly settings were not active in the current session.'
    }
    Remove-Module ShellColor -Force
    Import-Module $module -Force
    $persisted = Get-ShellColor
    if ($persisted.Color -ne 85 -or $persisted.Label -ne 'Bracketed') {
        throw 'SessionOnly settings changed the persisted configuration.'
    }

    # Preserve the user's colored prompt while showing the separate UpdateWulf
    # cache header. The module must not add a second header on repeated render.
    $global:ShellColorPrePromptProvider = { '[ UpdateWulf ::: test.local 0 Update(s) ]' }
    try {
        Enable-ShellColorPrompt
        $composed = prompt
        if (-not $composed.StartsWith('[ UpdateWulf ::: test.local 0 Update(s) ]' + [Environment]::NewLine)) {
            throw 'UpdateWulf preprompt provider not preserved by Shell-Color'
        }
        if (@($composed -split '\[ UpdateWulf :::').Count -ne 2) {
            throw 'UpdateWulf preprompt duplicated'
        }
    } finally {
        Disable-ShellColorPrompt
        Remove-Variable ShellColorPrePromptProvider -Scope Global -ErrorAction SilentlyContinue
    }

    if ((shell-color --version) -ne 'shell-color v1.33.7a') { throw 'Version command failed.' }
    Write-Host 'Windows tests passed.'
}
finally {
    $env:LOCALAPPDATA = $oldLocalAppData
    Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
}
