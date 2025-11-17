# Get the directory of this script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "Script directory: $ScriptDir"

# Load environment variables from .env
$EnvFile = Join-Path $ScriptDir ".env"
if (Test-Path $EnvFile) {
    Write-Host "Loading environment variables from .env..."
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value)
        }
    }
} else {
    Write-Host "⚠️  No .env file found in $ScriptDir"
}

# Check required vars
if (-not $env:OME_HOST_IP -or -not $env:OME_API_HOST) {
    Write-Host "❌ Missing OME_HOST_IP or OME_API_HOST. Please set them in .env"
    exit 1
}
if (-not $env:SERVER_ADDR -or -not $env:REDIS_HOST_ADDR) {
    Write-Host "❌ Missing SERVER_ADDR or REDIS_HOST_ADDR. Please set them in .env"
    exit 1
}

# Stop and remove existing container if running
$existing = docker ps -aq -f "name=ome"
if ($existing) {
    Write-Host "Stopping and removing existing 'ome' container..."
    docker stop ome | Out-Null
    docker rm ome | Out-Null
}

# Run OvenMediaEngine container
Write-Host "🚀 Starting OvenMediaEngine..."
docker run `
  --name ome `
  -e "OME_HOST_IP=$($env:OME_HOST_IP)" `
  -e "OME_API_HOST=$($env:OME_API_HOST)" `
  -e "SERVER_ADDR=$($env:SERVER_ADDR)" `
  -e "REDIS_HOST_ADDR=$($env:REDIS_HOST_ADDR)" `
  -v "${ScriptDir}\conf:/opt/ovenmediaengine/bin/origin_conf" `
  -p 1935:1935 `
  -p 8089:8089 `
  -p 3333:3333 `
  -p 9000:9000 `
  -d airensoft/ovenmediaengine:v0.19.0

Write-Host "✅ OME running at $($env:OME_API_HOST)"
