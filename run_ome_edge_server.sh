#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

# Load environment variables from .env if it exists
if [ -f "$SCRIPT_DIR/.env.edge.server" ]; then
  echo "Loading environment variables from .env.edge..."
  set -a
  source "$SCRIPT_DIR/.env.edge.server"
  set +a
else
  echo "⚠️  No .env.edge.server file found in $SCRIPT_DIR"
fi

# Ensure required vars are set
if [ -z "$EDGE_HOST_IP" ] || [ -z "$EDGE_API_HOST" ]; then
  echo "❌ Missing EDGE_HOST_IP or EDGE_API_HOST. Please set them in .env.edge.server"
  exit 1
fi

# Stop and remove existing container if running
if [ "$(docker ps -aq -f name=ome-edge)" ]; then
  echo "Stopping and removing existing 'ome-edge' container..."
  docker stop ome-edge >/dev/null 2>&1
  docker rm ome-edge >/dev/null 2>&1
fi

# Run OvenMediaEngine container for Edge
echo "🚀 Starting OvenMediaEngine Edge..."
docker run \
  --name ome-edge \
  -e OME_HOST_IP="$EDGE_HOST_IP" \
  -e OME_API_HOST="$EDGE_API_HOST" \
  -v "$SCRIPT_DIR/edge_conf:/opt/ovenmediaengine/bin/edge_conf" \
  -p 3333:3333 \
  -p 8089:8089 \
  -p 9000:9000 \
  -p 13333:13333 \
  -p 9999:9999/udp \
  -p 10000-10009:10000-10009/udp \
  -d airensoft/ovenmediaengine:v0.19.0

echo "✅ OME Edge running at $EDGE_API_HOST"
