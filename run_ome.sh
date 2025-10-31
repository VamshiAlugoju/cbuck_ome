#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR

# Run OvenMediaEngine Docker container
OME_HOST_IP=10.20.20.47
OME_API_HOST=http://10.20.20.47:8086

docker run \
  --name ome \
  -e OME_HOST_IP=$OME_HOST_IP \
  -e OME_API_HOST=$OME_API_HOST \
  -v "$SCRIPT_DIR/conf:/opt/ovenmediaengine/bin/origin_conf" \
  -p 1935:1935 \
  -p 3333:3333 \
  -p 3478:3478 \
  -p 8089:8089 \
  -p 9000:9000 \
  -p 9999:9999/udp \
  -p 10000-10009:10000-10009/udp \
  -d airensoft/ovenmediaengine:v0.19.0
