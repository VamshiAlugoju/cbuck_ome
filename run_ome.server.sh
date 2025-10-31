#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

# Load environment variables from .env if it exists
if [ -f "$SCRIPT_DIR/.env.server" ]; then
  echo "Loading environment variables from .env.server..."
  set -a
  source "$SCRIPT_DIR/.env.server"
  set +a
else
  echo "⚠️  No .env file found in $SCRIPT_DIR"
fi

# Ensure required vars are set
if [ -z "$OME_HOST_IP" ] || [ -z "$OME_API_HOST" ]; then
  echo "❌ Missing OME_HOST_IP or OME_API_HOST. Please set them in .env"
  exit 1
fi

# Stop and remove existing container if running
if [ "$(docker ps -aq -f name=ome)" ]; then
  echo "Stopping and removing existing 'ome' container..."
  docker stop ome >/dev/null 2>&1
  docker rm ome >/dev/null 2>&1
fi

# Run OvenMediaEngine container
echo "🚀 Starting OvenMediaEngine..."
docker run \
  --name ome \
  -e OME_HOST_IP="$OME_HOST_IP" \
  -e OME_API_HOST="$OME_API_HOST" \
  -v "$SCRIPT_DIR/conf:/opt/ovenmediaengine/bin/origin_conf" \
  -p 1935:1935 \
  -p 3333:3333 \
  -p 3478:3478 \
  -p 8089:8089 \
  -p 9000:9000 \
  -p 9999:9999/udp \
  -p 10000-10009:10000-10009/udp \
  -d airensoft/ovenmediaengine:v0.19.0

echo "✅ OME running at $OME_API_HOST"
