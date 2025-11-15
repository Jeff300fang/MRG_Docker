# setup-mrg.ps1
# PowerShell version of your Bash script
# Run this with:  pwsh ./setup-mrg.ps1

param(
    [string]$GH_USERNAME
)

# ============================================================
# Get GitHub username
# ============================================================
if (-not $GH_USERNAME) {
    $GH_USERNAME = Read-Host "Enter your GitHub username (for cloning your fork)"
}

# ============================================================
# Helper: Check if user has forked a repository
# ============================================================
function Test-GitHubFork {
    param(
        [Parameter(Mandatory)]
        [string]$Username,
        [Parameter(Mandatory)]
        [string]$Repo
    )

    $url = "https://github.com/$Username/$Repo"

    try {
        # HEAD request is enough to check existence
        Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "Fork of $Repo not found!" -ForegroundColor Red
        exit 1
    }
}

Test-GitHubFork -Username $GH_USERNAME -Repo "ROS_Tutorial"
Test-GitHubFork -Username $GH_USERNAME -Repo "stinger-software"

# ============================================================
# Make mrg directory structure
# ============================================================
$wsSrcPath = Join-Path $HOME "mrg/tutorial_ws/src"
New-Item -ItemType Directory -Path $wsSrcPath -Force | Out-Null

Set-Location $wsSrcPath

# Clone tutorial
git clone "https://github.com/$GH_USERNAME/ROS_Tutorial.git"

# Clone stinger-software
git clone "https://github.com/$GH_USERNAME/stinger-software.git"

# ============================================================
# Set up docker workspace
# ============================================================
$dockerWsPath = Join-Path $HOME "mrg/tutorial_docker_ws"
New-Item -ItemType Directory -Path $dockerWsPath -Force | Out-Null

Set-Location $dockerWsPath

# Clone docker tutorial branch
git clone -b tutorial "https://github.com/Jeff300fang/MRG_Docker.git"

Set-Location (Join-Path $dockerWsPath "MRG_Docker")

# ============================================================
# Create a PowerShell function instead of a Bash alias
# ============================================================
$sessionPsScript = Join-Path $HOME "mrg/tutorial_docker_ws/MRG_Docker/start_mrg_tutorial.ps1"

$profileLine = @"
function start_tutorial_docker {
    & '$sessionPsScript'
}
"@

# Ensure profile file exists
if (-not (Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

Add-Content -Path $PROFILE -Value $profileLine

Write-Host "Added Start-TutorialDocker function to your PowerShell profile." -ForegroundColor Green
Write-Host 'Reload your profile with:  . $PROFILE' -ForegroundColor Yellow

# ============================================================
# Pull Docker image
# ============================================================
docker pull jeff300fang/mrg:jazzy_tutorial

Write-Host "Setup complete!" -ForegroundColor Green
