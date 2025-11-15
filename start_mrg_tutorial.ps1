param(
    [string]$ContainerName = "mrg_tutorial"
)

# Directory where this script lives (like dirname "$0" in bash)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Paths to compose files
$ComposeFileNvidia = Join-Path $ScriptDir "docker-compose_nvidia.yml"
$ComposeFileCpu    = Join-Path $ScriptDir "docker-compose.yml"

$ComposeFile = $ComposeFileCpu

# ------------------------------------------------------------
# Try to detect if an NVIDIA runtime is available (best-effort)
# ------------------------------------------------------------
try {
    $dockerInfo = docker info 2>$null
    $hasNvidia  = $dockerInfo -match "nvidia"
} catch {
    $hasNvidia = $false
}

if ($hasNvidia -and (Test-Path $ComposeFileNvidia)) {
    Write-Host "nvidia runtime detected, using docker-compose_nvidia.yml" -ForegroundColor Green
    $ComposeFile = $ComposeFileNvidia
} else {
    Write-Host "Using non-GPU docker-compose.yml" -ForegroundColor Yellow
}

# ------------------------------------------------------------
# If container not running, start it
# ------------------------------------------------------------
$psOutput = docker compose -f $ComposeFile ps 2>$null

$containerIsUp = $false
if ($psOutput) {
    $containerIsUp = $psOutput -match $ContainerName -and $psOutput -match "Up"
}

if (-not $containerIsUp) {
    Write-Host "Starting container $ContainerName..." -ForegroundColor Cyan
    docker compose -f $ComposeFile up -d
}

# ------------------------------------------------------------
# Start interactive bash session in the container
# ------------------------------------------------------------
docker exec -it $ContainerName /bin/bash -s "MRG Tutorial Session"

# ------------------------------------------------------------
# After the shell exits, check if any tutorial sessions remain
# ------------------------------------------------------------
$topOutput = docker compose -f $ComposeFile top 2>$null

if (-not ($topOutput -match "/bin/bash -s MRG Tutorial Session")) {
    Write-Host "No active MRG sessions left; stopping container..." -ForegroundColor Cyan
    docker compose -f $ComposeFile stop
}
