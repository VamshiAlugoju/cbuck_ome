# Get the directory of this script
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "Script directory: $SCRIPT_DIR"

# Load environment variables from .env.edge if it exists
$envFile = Join-Path $SCRIPT_DIR ".env.edge"
if (Test-Path $envFile) {
    Write-Host "Loading environment variables from .env.edge..."
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]*)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value)
        }
    }
} else {
    Write-Warning "No .env.edge file found in $SCRIPT_DIR"
}

# Ensure required vars are set
if (-not $env:EDGE_HOST_IP -or -not $env:EDGE_API_HOST -or -not $env:DEFAULT_ORIGIN_SERVER) {
    Write-Error "Missing EDGE_HOST_IP or EDGE_API_HOST or DEFAULT_ORIGIN_SERVER. Please set them in .env.edge"
    exit 1
}

# Stop and remove existing container if running
$existingContainer = docker ps -aq -f "name=ome-edge"
if ($existingContainer) {
    Write-Host "Stopping and removing existing 'ome-edge' container..."
    docker stop ome-edge | Out-Null
    docker rm ome-edge | Out-Null
}

# Run OvenMediaEngine container for Edge
Write-Host "🚀 Starting OvenMediaEngine Edge..."
docker run `
    --name ome-edge `
    -e "OME_HOST_IP=$env:EDGE_HOST_IP" `
    -e "OME_API_HOST=$env:EDGE_API_HOST" `
    -e "DEFAULT_ORIGIN_SERVER=$env:DEFAULT_ORIGIN_SERVER" `
    -v "$SCRIPT_DIR\edge_conf\Server.xml:/opt/ovenmediaengine/bin/edge_conf/Server.xml" `
    -p 3333:3333 `
    -p 13333:13333 `
    -d airensoft/ovenmediaengine:v0.19.0 `
    /opt/ovenmediaengine/bin/OvenMediaEngine -c edge_conf

Write-Host "✅ OME Edge running at $env:EDGE_API_HOST"
