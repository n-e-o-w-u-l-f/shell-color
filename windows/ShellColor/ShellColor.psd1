@{
    RootModule = 'ShellColor.psm1'
    # PowerShell requires a numeric System.Version here. The public release
    # identifier remains v1.33.7a via the prerelease metadata below.
    ModuleVersion = '1.33.7'
    GUID = 'ff839f59-0d39-4f33-bb8e-e4cb46f471d2'
    Author = 'Neowulf'
    CompanyName = 'Community'
    Copyright = '(c) 2026 Neowulf. MIT License.'
    Description = 'Customizable 256-color prompts for PowerShell and cmd.exe.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'shell-color',
        'Set-ShellColor',
        'Get-ShellColor',
        'Reset-ShellColor',
        'Enable-ShellColorPrompt',
        'Disable-ShellColorPrompt',
        'Get-ShellColorPrompt',
        'Show-ShellColorPalette',
        'Show-ShellColorAliases'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Prerelease = 'a'
            Tags = @('prompt', 'terminal', 'color', 'powershell', 'cmd')
            LicenseUri = 'https://github.com/n-e-o-w-u-l-f/shell-color/blob/main/LICENCE.md'
            ProjectUri = 'https://github.com/n-e-o-w-u-l-f/shell-color'
        }
    }
}
