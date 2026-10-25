[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$reference = (Get-Content -LiteralPath (Join-Path $repoRoot 'references.lock.json') -Raw | ConvertFrom-Json).tutorial
$destination = Join-Path $repoRoot $reference.directory
if (-not (Test-Path -LiteralPath $destination)) {
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    & git -C $destination init --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Reference repository initialization failed.' }
    & git -C $destination remote add origin $reference.repository
    if ($LASTEXITCODE -ne 0) { throw 'Reference remote configuration failed.' }
}
$actualOrigin = & git -C $destination remote get-url origin
if ($LASTEXITCODE -ne 0 -or $actualOrigin -ne $reference.repository) { throw 'Reference folder is not the expected tutorial repository.' }
$localChanges = & git -C $destination status --porcelain
if ($LASTEXITCODE -ne 0 -or $localChanges) { throw 'Reference folder contains local changes; inspect them before updating.' }
$currentCommit = & git -C $destination rev-parse --verify HEAD 2>$null
if ($currentCommit -ne $reference.commit) {
    & git -C $destination fetch --depth 1 origin $reference.commit
    if ($LASTEXITCODE -ne 0) { throw 'Tutorial fetch failed.' }
    & git -C $destination checkout --detach $reference.commit
    if ($LASTEXITCODE -ne 0) { throw 'Tutorial checkout failed.' }
}
Write-Host "Tutorial snapshot verified: $($reference.commit)"
