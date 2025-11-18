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
  echo "⚠️  No .env.server file found in $SCRIPT_DIR"
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
  -e SERVER_ADDR="$SERVER_ADDR" \
  -e REDIS_HOST_ADDR="$REDIS_HOST_ADDR" \
  -v "$SCRIPT_DIR/conf:/opt/ovenmediaengine/bin/origin_conf" \
  -p 1935:1935 \
  -p 8089:8089 \
 -p 3333:3333 \
  -p 9000:9000 \
  -d airensoft/ovenmediaengine:v0.19.0

echo "✅ OME running at $OME_API_HOST"

  # -p 3478:3478 \
  # -p 13333:13333 \
  # -p 9999:9999/udp \
  # -p 10000-10009:10000-10009/udp \

  
echo "🚀 Starting testserver..."

cd "$SCRIPT_DIR/testserver"

# Build the Docker image from Dockerfile inside ./testserver
docker build -t testserver .

# Stop & remove old container (optional but safe)
existingTest=$(docker ps -aq -f "name=testserver")
if [ -n "$existingTest" ]; then
    echo "Stopping and removing existing 'testserver' container..."
    docker stop testserver >/dev/null 2>&1
    docker rm testserver >/dev/null 2>&1
fi

# Run the container
docker run \
  --name testserver \
  -p 3000:3000 \
  -d testserver

cd ..
