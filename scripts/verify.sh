#!/usr/bin/env bash
set -euo pipefail

echo "Services:"
docker compose -f compose/docker-compose.yml ps

echo
echo "Load-balancing check (10 requests):"
for i in {1..10}; do
  curl -s http://localhost:8081 || true
  echo
done
