$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Find-ToolchainBin {
    $existing = Get-Command g++ -ErrorAction SilentlyContinue
    if ($existing) {
        return (Split-Path -Parent $existing.Source)
    }

    $roots = @(
        "C:\Program Files\WinLibs",
        (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages")
    )

    foreach ($root in $roots) {
        if (-not (Test-Path $root)) {
            continue
        }
        $hit = Get-ChildItem -Path $root -Filter "g++.exe" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($hit) {
            return $hit.DirectoryName
        }
    }

    throw "g++ was not found. Install WinLibs (BrechtSanders.WinLibs.POSIX.UCRT)."
}

$bin = Find-ToolchainBin
$env:Path = "$bin;$env:Path"

cmake --preset windows
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

cmake --build --preset windows
exit $LASTEXITCODE
