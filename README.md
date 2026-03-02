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

## CI/CD (Jenkins)
This repo includes a 'JenkinsFile' that:
- Builds a Docker image
- Pushes a traceable tag: 'build-${BUILD_NUMBER}'
- Updates 'latest'
- Uses Jenkins Credentials ('dockerhub-cred') for Docker Hub authentication

See: 'docs/ci-cd.md'
Docker Hub: 'araheman/devops-prodcution-lab'

---

## Related CI/CD Showcase Repository 

This production lab is supported by a dedicated CI/CD implementation:

--> https://github.com/A-Raheman/jenkins-cicd-lab

That repository demonstrates:

- Jenkins Multibranch Pipeline
- GitHub Webhook Integration (Cloudflare Tunnel)
- Docker image build & push
- Parameterized builds
- Build retention strategy
- Production-style tagging
