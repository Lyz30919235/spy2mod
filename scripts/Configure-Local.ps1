[CmdletBinding()]
param([string]$GameDir)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$settingsPath = Join-Path $repoRoot '.local/settings.json'
$toolchain = Get-Content -LiteralPath (Join-Path $repoRoot 'toolchain.json') -Raw | ConvertFrom-Json
if (-not $GameDir -and (Test-Path -LiteralPath $settingsPath)) {
    $existingSettings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
    $GameDir = $existingSettings.GameDir
}
if (-not $GameDir) {
    $steamSettings = Get-ItemProperty -LiteralPath 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue
    $steamRoot = $steamSettings.SteamPath
    if (-not $steamRoot) { throw 'Steam location not found. Pass -GameDir explicitly.' }
    $libraries = @($steamRoot)
    $libraryFile = Join-Path $steamRoot 'steamapps/libraryfolders.vdf'
    if (Test-Path -LiteralPath $libraryFile) {
        $libraryText = Get-Content -LiteralPath $libraryFile -Raw
        $libraries += [regex]::Matches($libraryText, '"path"\s+"([^"]+)"') | ForEach-Object { $_.Groups[1].Value.Replace('\\', '\') }
    }
    foreach ($library in ($libraries | Select-Object -Unique)) {
        $manifestPath = Join-Path $library 'steamapps/appmanifest_2868840.acf'
        if (-not (Test-Path -LiteralPath $manifestPath)) { continue }
        $manifestText = Get-Content -LiteralPath $manifestPath -Raw
        $installName = [regex]::Match($manifestText, '"installdir"\s+"([^"]+)"').Groups[1].Value
        if ($installName) {
            $candidate = Join-Path (Join-Path $library 'steamapps/common') $installName
            if (Test-Path -LiteralPath (Join-Path $candidate 'data_sts2_windows_x86_64/sts2.dll')) { $GameDir = $candidate; break }
        }
    }
}
if (-not $GameDir) { throw 'Slay the Spire 2 installation not found. Pass -GameDir explicitly.' }
$GameDir = (Resolve-Path -LiteralPath $GameDir).Path
foreach ($assembly in @('sts2.dll', '0Harmony.dll', 'GodotSharp.dll')) {
    if (-not (Test-Path -LiteralPath (Join-Path $GameDir "data_sts2_windows_x86_64/$assembly"))) { throw "Game assembly missing: $assembly" }
}
$settings = [ordered]@{ GameDir = $GameDir }
foreach ($pair in @(@('dotnet', 'DotNetExe'), @('godot', 'GodotExe'))) {
    $definition = $toolchain.($pair[0])
    $exePath = Join-Path (Join-Path $repoRoot $definition.directory) $definition.executable
    if (-not (Test-Path -LiteralPath $exePath -PathType Leaf)) { throw "Tool not installed: $($pair[0]). Run Install-Tools.ps1 first." }
    $settings[$pair[1]] = $exePath
}
$bundledPackages = Join-Path (Split-Path $settings.GodotExe -Parent) 'GodotSharp/Tools/nupkgs'
if (-not (Test-Path -LiteralPath $bundledPackages -PathType Container)) { throw 'Godot bundled NuGet packages are missing.' }
$localFeed = Join-Path $repoRoot '.tools/nuget-feed'
New-Item -ItemType Directory -Path $localFeed -Force | Out-Null
Get-ChildItem -LiteralPath $bundledPackages -Filter '*.nupkg' -File | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $localFeed $_.Name) -Force }
New-Item -ItemType Directory -Path (Split-Path $settingsPath -Parent) -Force | Out-Null
[System.IO.File]::WriteAllText($settingsPath, (($settings | ConvertTo-Json) + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
Write-Host 'Local settings saved under .local/ (excluded from Git).'
Write-Host 'Godot NuGet packages copied to the local feed (excluded from Git).'
