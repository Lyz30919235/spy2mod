[CmdletBinding()]
param(
    [switch]$Deploy,
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Debug'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$settingsPath = Join-Path $repoRoot '.local/settings.json'
if (-not (Test-Path -LiteralPath $settingsPath)) { throw 'Run scripts/Configure-Local.ps1 first.' }
$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
$projectDir = Join-Path $repoRoot 'src/Spy2Mod'
$projectPath = Join-Path $projectDir 'Spy2Mod.csproj'
$manifestPath = Join-Path $projectDir 'Spy2Mod.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($manifest.id -ne 'Spy2Mod' -or $manifest.has_pck -or -not $manifest.has_dll) { throw 'Manifest does not match this DLL-only starter project.' }
if (-not (Test-Path -LiteralPath $settings.DotNetExe -PathType Leaf)) { throw 'Configured dotnet executable does not exist.' }
if (-not (Test-Path -LiteralPath (Join-Path $settings.GameDir 'data_sts2_windows_x86_64/sts2.dll'))) { throw 'Configured game installation does not exist.' }
$env:DOTNET_ROOT = Split-Path $settings.DotNetExe -Parent
$env:DOTNET_CLI_HOME = Join-Path $repoRoot '.local/dotnet-home'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_NOLOGO = '1'
$env:DOTNET_GENERATE_ASPNET_CERTIFICATE = 'false'
$env:NUGET_PACKAGES = Join-Path $repoRoot '.tools/nuget-packages'
$buildDir = Join-Path $repoRoot "artifacts/build/$Configuration"
Push-Location $repoRoot
try {
    & $settings.DotNetExe build $projectPath --configuration $Configuration --output $buildDir "-p:Sts2Dir=$($settings.GameDir)" "-p:Version=$($manifest.version)" --nologo
    if ($LASTEXITCODE -ne 0) { throw "dotnet build failed (exit $LASTEXITCODE)." }
} finally { Pop-Location }
$packageDir = Join-Path $repoRoot 'artifacts/Spy2Mod'
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $buildDir 'Spy2Mod.dll') -Destination (Join-Path $packageDir 'Spy2Mod.dll') -Force
Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $packageDir 'Spy2Mod.json') -Force
Write-Host 'Package ready: artifacts/Spy2Mod (DLL + JSON).'
if ($Deploy) {
    $destination = Join-Path $settings.GameDir 'mods/Spy2Mod'
    if (Test-Path -LiteralPath $destination) {
        $existingManifest = Join-Path $destination 'Spy2Mod.json'
        if (-not (Test-Path -LiteralPath $existingManifest)) { throw 'Existing deployment folder has no Spy2Mod manifest; refusing to overwrite it.' }
        $existingId = (Get-Content -LiteralPath $existingManifest -Raw | ConvertFrom-Json).id
        if ($existingId -ne 'Spy2Mod') { throw 'Existing deployment belongs to a different mod.' }
    }
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    foreach ($fileName in @('Spy2Mod.dll', 'Spy2Mod.json')) {
        $sourceFile = Join-Path $packageDir $fileName
        $destinationFile = Join-Path $destination $fileName
        Copy-Item -LiteralPath $sourceFile -Destination $destinationFile -Force
        if ((Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $destinationFile -Algorithm SHA256).Hash) { throw "Deployment hash mismatch: $fileName" }
    }
    Write-Host 'Deployment verified: mods/Spy2Mod (both SHA256 values match).'
}
