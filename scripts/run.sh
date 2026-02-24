#!/usr/bin env /bash
set -euo pipefail

echo "Starting stack..."
docker compose -f compose/docker-compose.yml up -d --build

echo "Done."
echo "Try: bash scripts/verify.sh"

