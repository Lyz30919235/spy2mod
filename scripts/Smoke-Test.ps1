[CmdletBinding()]
param([ValidateRange(15, 60)][int]$TimeoutSeconds = 45)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$settings = Get-Content -LiteralPath (Join-Path $repoRoot '.local/settings.json') -Raw | ConvertFrom-Json
$gameExe = Join-Path $settings.GameDir 'SlayTheSpire2.exe'
$deployedDll = Join-Path $settings.GameDir 'mods/Spy2Mod/Spy2Mod.dll'
if (-not (Test-Path -LiteralPath $deployedDll)) { throw 'Deploy the mod with Build-Mod.ps1 -Deploy first.' }
if (Get-Process -Name 'SlayTheSpire2' -ErrorAction SilentlyContinue) { throw 'The game is already running. Close it before starting a separate smoke check.' }
$evidenceDir = Join-Path $repoRoot 'artifacts/smoke'
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null
$runId = Get-Date -Format 'yyyyMMdd-HHmmss'
$engineLog = Join-Path $evidenceDir "$runId-godot.log"
$stdoutLog = Join-Path $evidenceDir "$runId-stdout.log"
$stderrLog = Join-Path $evidenceDir "$runId-stderr.log"
$arguments = @('--headless', '--log', '--force-steam=off', '--max-fps', '60', '--quit-after', '600', '--log-file', ('"{0}"' -f $engineLog))
$process = Start-Process -FilePath $gameExe -WorkingDirectory $settings.GameDir -ArgumentList $arguments -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -WindowStyle Hidden -PassThru
if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
    Stop-Process -Id $process.Id -Force
    throw "Headless check timed out. Inspect artifacts/smoke/$runId logs."
}
$process.WaitForExit()
$combinedLog = ''
foreach ($logPath in @($engineLog, $stdoutLog, $stderrLog)) {
    if (Test-Path -LiteralPath $logPath) {
        $stream = [System.IO.File]::Open($logPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        $reader = [System.IO.StreamReader]::new($stream)
        try { $combinedLog += $reader.ReadToEnd() + [Environment]::NewLine } finally { $reader.Dispose() }
    }
}
$initializerObserved = $combinedLog.Contains('[Spy2Mod] initialized;')
$version = (Get-Content -LiteralPath (Join-Path $settings.GameDir 'release_info.json') -Raw | ConvertFrom-Json).version
$evidence = [ordered]@{
    recorded_at_utc = [DateTimeOffset]::UtcNow.ToString('O')
    game_version = $version
    mode = 'headless, Steam disabled, no run started'
    exit_code = $process.ExitCode
    initializer_observed = $initializerObserved
    engine_error_line_count = @($combinedLog -split '\r?\n' | Where-Object { $_ -match '^ERROR:' }).Count
    deployed_dll_sha256 = (Get-FileHash -LiteralPath $deployedDll -Algorithm SHA256).Hash.ToLowerInvariant()
}
$evidencePath = Join-Path $evidenceDir "$runId-result.json"
[System.IO.File]::WriteAllText($evidencePath, (($evidence | ConvertTo-Json) + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
if (-not $initializerObserved) { throw "Mod initializer was not observed. Inspect artifacts/smoke/$runId logs; mod consent or compatibility may require attention." }
if ($process.ExitCode -ne 0) { throw "Initializer ran, but the game exited with code $($process.ExitCode). Inspect the smoke logs." }
Write-Host 'PASS: the actual game executed Spy2Mod.Init; headless startup exited successfully.'
