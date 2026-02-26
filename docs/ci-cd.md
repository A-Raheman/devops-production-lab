# CI/CD (Jenkins) - DevOps Production Lab

## What the pipeline does
1. Checks out 'main'
2. Builds Docker image tagged as 'build-${BUILD_NUMBER}'
3. Logs into Docker Hub using Jenkins credentials ('dockerhub-creds')
4. Pushes:
	- 'araheman/devops-production-lab:build-${BUILD_NUMBER}' (traceable)
	- 'araheman/devops-production-lab:latest' (devployment-friendly)
5. Cleans up local build tags and prunes dangling layers

## Why push both tags?
- 'latest': easy for deployments that always want the newest successful build
- 'build-*': enables rollback and auditing ("which build is running?")

## Security
- No passwords/tokens are stored in the repo
- Docker Hub token is stored in Jenkins Credentials with ID 'dockerhub-creds'.
