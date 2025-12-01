#!/usr/bin/env bash
set -e

IMAGE="shyam302000/devops-build:dev"

echo "Building image $IMAGE ..."
docker build -t $IMAGE .
echo "Done building image."
