#!/usr/bin/env bash
set -e

echo "Deploying application..."
docker compose pull || true
docker compose up -d --build
echo "Application deployed and running on port 80."
