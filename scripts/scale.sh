#!/usr/bin/env bash
set -euo pipefail

COUNT="${1:-3}"
echo "Scaling flask-app to ${COUNT} replicas..."
docker compose -f compose/docker-compose.yml up -d --scale flask-app="$COUNT"
docker compose -f compose/docker-compose.yml ps

