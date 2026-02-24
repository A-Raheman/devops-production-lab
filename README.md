# DevOps Production Lab (Docker Compose + NGINX Reverse Proxy)

This repo demonstrates a production-style local setup using Docker Compose:
- Reverse proxy using NGINX
- Service discovery inside Docker network
- Scaling app replicas
- Load balancing verification via repeated curl requests

## Tech
- Linux / Bash
- Git
- Docker, Docker Compose
- NGINX reverse proxy

## Project Structure
- `compose/` -> compose file + nginx config
- `scripts/` -> run / verify / cleanup
- `screenshots/` -> proof
- `docs/` -> notes / architecture

## Quick Start

### 1) Start
```bash
bash scripts/run.sh
