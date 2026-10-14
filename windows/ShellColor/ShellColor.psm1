Set-StrictMode -Version 2.0

$script:ShellColorVersion = 'v1.33.7a'
$script:Esc = [char]27
$script:OriginalPrompt = $null
$script:SessionConfig = $null

function Get-ShellColorConfigPath {
    if ($env:LOCALAPPDATA) {
        $base = $env:LOCALAPPDATA
    }
    elseif ($env:XDG_CONFIG_HOME) {
        $base = $env:XDG_CONFIG_HOME
    }
    else {
        $base = Join-Path $HOME '.config'
    }
    Join-Path (Join-Path $base 'shell-color') 'config.json'
}

function New-ShellColorDefaultConfig {
    [pscustomobject]@{
        Color        = 85
        Style        = 'Windows'
        Label        = 'Short'
        Path         = 'Full'
        User         = 'Off'
        Computer     = 'Off'
        Ip           = 'None'
        IpAddress    = ''
        TextColor    = 250
        NumberColor  = 15
        BoldNumbers  = $true
    }
}

function Get-ShellColorConfig {
    if ($null -ne $script:SessionConfig) {
        return $script:SessionConfig
    }

    $defaults = New-ShellColorDefaultConfig
    $path = Get-ShellColorConfigPath
    if (-not (Test-Path -LiteralPath $path)) {
        return $defaults
    }

    try {
        $saved = Get-Content -LiteralPath $path -Raw -ErrorAction Stop | ConvertFrom-Json
        foreach ($property in $defaults.PSObject.Properties.Name) {
            if ($null -ne $saved.PSObject.Properties[$property]) {
                $defaults.$property = $saved.$property
            }
        }
    }
    catch {
        Write-Warning "Could not read shell-color configuration: $($_.Exception.Message)"
    }
    return $defaults
}

function Save-ShellColorConfig {
    param([Parameter(Mandatory)][psobject]$Config)
    $path = Get-ShellColorConfigPath
    $directory = Split-Path -Parent $path
    $null = New-Item -ItemType Directory -Path $directory -Force
    $Config | ConvertTo-Json | Set-Content -LiteralPath $path -Encoding UTF8
}

function Get-ShellColorAliases {
    @{
        black = 0; maroon = 1; green = 2; olive = 3; navy = 4; purple = 5
        teal = 6; silver = 7; grey = 8; gray = 8; red = 9; rot = 9
        lime = 10; yellow = 11; gelb = 11; blue = 12; blau = 12
        fuchsia = 13; cyan = 14; aqua = 14; white = 15; weiss = 15
        mint = 85; minz = 85; minze = 85; mintcyan = 50
        minztuerkis = 50; skyblue = 39; himmelblau = 39
        orange = 208; pink = 198; rosa = 205; violet = 177; lila = 129
        aquamarine1 = 86; aquamarine2 = 122; aquamarine3 = 79
    }
}

function Resolve-ShellColor {
    param([Parameter(Mandatory)][object]$Color)
    $text = [string]$Color
    $number = 0
    if ([int]::TryParse($text, [ref]$number)) {
        if ($number -ge 0 -and $number -le 255) { return $number }
        throw 'Color index must be between 0 and 255.'
    }

    $normalized = $text.ToLowerInvariant() -replace '[\s_.-]', ''
    $aliases = Get-ShellColorAliases
    if ($aliases.ContainsKey($normalized)) { return [int]$aliases[$normalized] }
    throw "Unknown color '$text'. Use shell-color --list or shell-color --aliases."
}

function Get-ShellColorEscape {
    param(
        [Parameter(Mandatory)][int]$Index,
        [switch]$Bold
    )
    $weight = if ($Bold) { '1;' } else { '' }
    "$script:Esc[$($weight)38;5;${Index}m"
}

function ConvertTo-ShellColorText {
    param(
        [AllowEmptyString()][string]$Text,
        [Parameter(Mandatory)][psobject]$Config
    )
    $builder = New-Object System.Text.StringBuilder
    foreach ($character in $Text.ToCharArray()) {
        if ([char]::IsDigit($character)) {
            $null = $builder.Append((Get-ShellColorEscape -Index ([int]$Config.NumberColor) -Bold:([bool]$Config.BoldNumbers)))
        }
        elseif (-not ([char]::IsLetterOrDigit($character))) {
            $null = $builder.Append((Get-ShellColorEscape -Index ([int]$Config.Color)))
        }
        else {
            $null = $builder.Append((Get-ShellColorEscape -Index ([int]$Config.TextColor)))
        }
        $null = $builder.Append($character)
    }
    $null = $builder.Append("$script:Esc[0m")
    $builder.ToString()
}

function Get-ShellColorPath {
    param(
        [Parameter(Mandatory)][string]$Mode,
        [string]$Location = (Get-Location).Path
    )
    switch ($Mode) {
        'Leaf' { return (Split-Path -Leaf $Location) }
        'HomeRelative' {
            if ($HOME -and $Location.StartsWith($HOME, [System.StringComparison]::OrdinalIgnoreCase)) {
                return '~' + $Location.Substring($HOME.Length)
            }
            return $Location
        }
        default { return $Location }
    }
}

function Get-ShellColorLocalIp {
    try {
        $address = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() |
            Where-Object { $_.OperationalStatus -eq 'Up' -and $_.NetworkInterfaceType -ne 'Loopback' } |
            ForEach-Object { $_.GetIPProperties().UnicastAddresses } |
            Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } |
            Select-Object -First 1
        if ($address) { return $address.Address.IPAddressToString }
    }
    catch { }
    return 'local'
}

function Get-ShellColorLabel {
    param([Parameter(Mandatory)][string]$Mode)
    switch ($Mode) {
        'Short' { 'PS' }
        'Bracketed' { '[PS]' }
        'Full' { 'PowerShell' }
        default { '' }
    }
}

function Get-ShellColorPrompt {
    [CmdletBinding()]
    param(
        [ValidateSet('PowerShell', 'Cmd')][string]$Shell = 'PowerShell',
        [string]$Location = (Get-Location).Path
    )

    $config = Get-ShellColorConfig
    $path = Get-ShellColorPath -Mode $config.Path -Location $Location
    $label = Get-ShellColorLabel -Mode $config.Label
    $user = [Environment]::UserName
    $computer = [Environment]::MachineName
    $ip = switch ($config.Ip) {
        'Local' { Get-ShellColorLocalIp }
        'Public' { [string]$config.IpAddress }
        default { '' }
    }

    switch ($config.Style) {
        'Compact' {
            $identity = @($user, $computer) -join '@'
            $plain = "($identity $path)> "
        }
        'CompactIp' {
            $identity = @($user, $computer) -join '@'
            $ipPart = if ($ip) { "[$ip]" } else { '' }
            $plain = "($identity$ipPart $path)> "
        }
        'Arrow' {
            $identity = @($user, $computer) -join '@'
            $plain = "$identity $path ❯ "
        }
        'Brackets' {
            $segments = @()
            if ($config.User -eq 'On') { $segments += $user }
            if ($config.Computer -eq 'On') { $segments += $computer }
            if ($ip) { $segments += $ip }
            $identity = if ($segments.Count) { '[' + ($segments -join '@') + '] ' } else { '' }
            $prefix = if ($label) { "$label " } else { '' }
            $plain = "$prefix$identity$path > "
        }
        default {
            $segments = @()
            if ($config.User -eq 'On') { $segments += $user }
            if ($config.Computer -eq 'On') { $segments += $computer }
            if ($ip) { $segments += $ip }
            $identity = if ($segments.Count) { ($segments -join '@') + ' ' } else { '' }
            $prefix = if ($label) { "$label " } else { '' }
            $plain = "$prefix$identity$path> "
        }
    }

    $rendered = ConvertTo-ShellColorText -Text $plain -Config $config
    if ($Shell -eq 'Cmd') {
        return $rendered.Replace('$', '$$')
    }
    return $rendered
}

function Enable-ShellColorPrompt {
    [CmdletBinding()]
    param()
    if ($null -eq $script:OriginalPrompt) {
        $current = Get-Command prompt -CommandType Function -ErrorAction SilentlyContinue
        if ($current) { $script:OriginalPrompt = $current.ScriptBlock }
    }
    # A user-scoped prefix provider composes with (rather than replaces)
    # the colored Shell-Color prompt. UpdateWulf contributes its cached header.
    function global:prompt {
        $savedExit=$global:LASTEXITCODE
        try {
            $owner=Get-ShellColorPrompt
            if ($global:ShellColorPrePromptProvider -is [scriptblock]) {
                $header=& $global:ShellColorPrePromptProvider
                if ($header) { return ($header + [Environment]::NewLine + $owner) }
            }
            return $owner
        } finally {
            $global:LASTEXITCODE=$savedExit
        }
    }
}

function Disable-ShellColorPrompt {
    [CmdletBinding()]
    param()
    if ($script:OriginalPrompt) {
        Set-Item -Path Function:\global:prompt -Value $script:OriginalPrompt
    }
    else {
        function global:prompt { "PS $($executionContext.SessionState.Path.CurrentLocation)> " }
    }
}

function Set-ShellColor {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][object]$Color,
        [ValidateSet('Keep', 'Windows', 'Compact', 'CompactIp', 'Arrow', 'Brackets')][string]$Style,
        [ValidateSet('Short', 'Bracketed', 'Full', 'None')][string]$Label,
        [ValidateSet('Full', 'HomeRelative', 'Leaf')][string]$Path,
        [ValidateSet('On', 'Off')][string]$User,
        [ValidateSet('On', 'Off')][string]$Computer,
        [ValidateSet('None', 'Local', 'Public')][string]$Ip,
        [switch]$SessionOnly
    )

    $config = Get-ShellColorConfig
    if ($PSBoundParameters.ContainsKey('Color')) { $config.Color = Resolve-ShellColor $Color }
    foreach ($name in @('Style', 'Label', 'Path', 'User', 'Computer', 'Ip')) {
        if ($PSBoundParameters.ContainsKey($name)) { $config.$name = $PSBoundParameters[$name] }
    }

    if ($PSBoundParameters.ContainsKey('Ip') -and $Ip -eq 'Public') {
        try {
            $config.IpAddress = (Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 3).ToString().Trim()
        }
        catch {
            throw "Public IP lookup failed: $($_.Exception.Message)"
        }
    }
    elseif ($PSBoundParameters.ContainsKey('Ip') -and $Ip -ne 'Public') {
        $config.IpAddress = ''
    }

    if ($SessionOnly) {
        $script:SessionConfig = $config
    }
    else {
        Save-ShellColorConfig -Config $config
        $script:SessionConfig = $null
    }
    if ($config.Style -eq 'Keep') { Disable-ShellColorPrompt } else { Enable-ShellColorPrompt }
    Get-ShellColor
}

function Get-ShellColor {
    [CmdletBinding()]
    param()
    $config = Get-ShellColorConfig
    [pscustomobject]@{
        Version      = $script:ShellColorVersion
        Color        = [int]$config.Color
        Style        = [string]$config.Style
        Label        = [string]$config.Label
        Path         = [string]$config.Path
        User         = [string]$config.User
        Computer     = [string]$config.Computer
        Ip           = [string]$config.Ip
        IpAddress    = [string]$config.IpAddress
        TextColor    = [int]$config.TextColor
        NumberColor  = [int]$config.NumberColor
        BoldNumbers  = [bool]$config.BoldNumbers
        Configuration = Get-ShellColorConfigPath
    }
}

function Reset-ShellColor {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    $path = Get-ShellColorConfigPath
    if ($PSCmdlet.ShouldProcess($path, 'Reset shell-color configuration')) {
        $script:SessionConfig = $null
        Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
        Enable-ShellColorPrompt
        Get-ShellColor
    }
}

function Show-ShellColorPalette {
    [CmdletBinding()]
    param()
    for ($index = 0; $index -le 255; $index++) {
        $sample = "$(Get-ShellColorEscape -Index $index)$($index.ToString().PadLeft(3)) sample$script:Esc[0m"
        Write-Host $sample
    }
}

function Show-ShellColorAliases {
    [CmdletBinding()]
    param()
    (Get-ShellColorAliases).GetEnumerator() |
        Sort-Object Name |
        ForEach-Object { '{0,-18} -> {1}' -f $_.Name, $_.Value }
}

function Show-ShellColorPreview {
    param([Parameter(Mandatory)][object]$Color)
    $config = Get-ShellColorConfig
    $config.Color = Resolve-ShellColor $Color
    ConvertTo-ShellColorText -Text "PS C:\Users\example> shell-color $Color" -Config $config
}

function Show-ShellColorHelp {
    @'
shell-color for PowerShell

Portable syntax:
  shell-color --set <0-255|alias>
  shell-color <0-255|alias>
  shell-color --style <Keep|Windows|Compact|CompactIp|Arrow|Brackets>
  shell-color --label <Short|Bracketed|Full|None>
  shell-color --path <Full|HomeRelative|Leaf>
  shell-color --user <On|Off>
  shell-color --computer <On|Off>
  shell-color --ip <None|Local|Public>
  shell-color --current | --list | --aliases | --apply | --reset | --version

Native PowerShell cmdlets:
  Set-ShellColor, Get-ShellColor, Reset-ShellColor,
  Enable-ShellColorPrompt, Disable-ShellColorPrompt, Get-ShellColorPrompt,
  Show-ShellColorPalette, Show-ShellColorAliases
'@
}

function shell-color {
    $tokens = @($args)
    if ($tokens.Count -eq 0) { Show-ShellColorHelp; return }
    $action = ([string]$tokens[0]).ToLowerInvariant()
    $value = if ($tokens.Count -gt 1) { $tokens[1] } else { $null }

    switch ($action) {
        { $_ -in @('--set', '-s', 'set') } {
            if ($null -eq $value) { throw 'A color value is required.' }
            Set-ShellColor -Color $value
        }
        { $_ -in @('--style', 'style') } {
            if ($value -eq 'list') { 'Keep'; 'Windows'; 'Compact'; 'CompactIp'; 'Arrow'; 'Brackets' }
            elseif ($null -eq $value) { throw 'A style is required.' }
            else { Set-ShellColor -Style $value }
        }
        { $_ -in @('--label', 'label') } {
            if ($null -eq $value) { throw 'A label mode is required.' }
            Set-ShellColor -Label $value
        }
        { $_ -in @('--path', 'path') } {
            if ($null -eq $value) { throw 'A path mode is required.' }
            Set-ShellColor -Path $value
        }
        { $_ -in @('--user', 'user') } {
            if ($null -eq $value) { throw 'On or Off is required.' }
            Set-ShellColor -User $value
        }
        { $_ -in @('--computer', 'computer') } {
            if ($null -eq $value) { throw 'On or Off is required.' }
            Set-ShellColor -Computer $value
        }
        { $_ -in @('--ip', 'ip') } {
            if ($null -eq $value) { throw 'None, Local or Public is required.' }
            Set-ShellColor -Ip $value
        }
        { $_ -in @('--current', 'current', 'show') } { Get-ShellColor }
        { $_ -in @('--list', '-l', 'list') } { Show-ShellColorPalette }
        { $_ -in @('--aliases', 'aliases') } { Show-ShellColorAliases }
        { $_ -in @('--apply', 'apply') } {
            if ((Get-ShellColor).Style -eq 'Keep') { Disable-ShellColorPrompt }
            else { Enable-ShellColorPrompt }
            Get-ShellColor
        }
        { $_ -in @('--reset', 'reset') } { Reset-ShellColor -Confirm:$false }
        { $_ -in @('--version', '-v', 'version') } { "shell-color $script:ShellColorVersion" }
        { $_ -in @('--help', '-h', 'help') } { Show-ShellColorHelp }
        default { Show-ShellColorPreview -Color $tokens[0] }
    }
}

Export-ModuleMember -Function @(
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
