#!/bin/bash
set -e

tag=latest
if [[ "$1" != "" ]]; then
  tag="$1"
fi

# Build the image
echo "INFO: Building image: breqwatr/pip:$tag"
docker build -t breqwatr/pip:$tag .
