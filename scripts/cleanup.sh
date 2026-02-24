#!/usr/bin/env bash
set -euo pipefail

echo "Stopping stack..."
docker compose -f compose/docker-compose.yml down -v

echo "Done."

