[CmdletBinding()]
param(
    [ValidateSet('all', 'dotnet', 'godot')]
    [string]$Tool = 'all',
    [switch]$NoProxy
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$repoRoot = Split-Path $PSScriptRoot -Parent
$toolchain = Get-Content -LiteralPath (Join-Path $repoRoot 'toolchain.json') -Raw | ConvertFrom-Json
$toolsToInstall = if ($Tool -eq 'all') { @('dotnet', 'godot') } else { @($Tool) }
$downloadDir = Join-Path $repoRoot '.tools/downloads'
New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null

foreach ($toolName in $toolsToInstall) {
    $definition = $toolchain.$toolName
    $installDir = Join-Path $repoRoot $definition.directory
    $executable = Join-Path $installDir $definition.executable
    if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
        $archiveName = [System.IO.Path]::GetFileName(([uri]$definition.url).AbsolutePath)
        $archivePath = Join-Path $downloadDir $archiveName
        if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
            $partialPath = $archivePath + '.part'
            Write-Host "Downloading $toolName $($definition.version)..."
            $requestOptions = @{ Uri = $definition.url; OutFile = $partialPath; TimeoutSec = 300; UseBasicParsing = $true }
            if ($NoProxy) { $requestOptions.NoProxy = $true }
            Invoke-WebRequest @requestOptions
            $downloadHash = (Get-FileHash -LiteralPath $partialPath -Algorithm $definition.algorithm).Hash
            if ($downloadHash -ne $definition.hash) { throw "Checksum mismatch for $toolName. Partial archive retained for inspection." }
            Move-Item -LiteralPath $partialPath -Destination $archivePath
        }
        $archiveHash = (Get-FileHash -LiteralPath $archivePath -Algorithm $definition.algorithm).Hash
        if ($archiveHash -ne $definition.hash) { throw "Cached archive checksum mismatch: $archiveName" }
        if (Test-Path -LiteralPath $installDir) { throw "Incomplete installation already exists: $installDir. Inspect it before replacing files." }
        Write-Host "Extracting $toolName..."
        Expand-Archive -LiteralPath $archivePath -DestinationPath $installDir
    }
    if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) { throw "Expected executable missing for $toolName." }
    $versionOutput = & $executable --version
    if ($LASTEXITCODE -ne 0) { throw "$toolName version check failed." }
    if (($versionOutput -join ' ') -notmatch ('^' + [regex]::Escape($definition.version) + '(\.|\s|$)')) { throw "Unexpected $toolName version: $versionOutput" }
    Write-Host "$toolName verified: $versionOutput"
}
