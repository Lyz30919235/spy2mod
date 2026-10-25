[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$settings = Get-Content -LiteralPath (Join-Path $repoRoot '.local/settings.json') -Raw | ConvertFrom-Json
$env:DOTNET_ROOT = Split-Path $settings.DotNetExe -Parent
$env:PATH = $env:DOTNET_ROOT + [System.IO.Path]::PathSeparator + $env:PATH
$env:DOTNET_CLI_HOME = Join-Path $repoRoot '.local/dotnet-home'
$env:NUGET_PACKAGES = Join-Path $repoRoot '.tools/nuget-packages'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_GENERATE_ASPNET_CERTIFICATE = 'false'
$editorExe = $settings.GodotExe -replace '_console\.exe$', '.exe'
if (-not (Test-Path -LiteralPath $editorExe -PathType Leaf)) { throw 'Configured Godot editor does not exist.' }
$projectDir = Join-Path $repoRoot 'src/Spy2Mod'
Start-Process -FilePath $editorExe -ArgumentList @('--editor', '--path', ('"{0}"' -f $projectDir)) -WorkingDirectory $projectDir
