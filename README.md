# DevOps CI/CD Production Deployment Pipeline Project

## Project Overview
# DevOps Production Lab

A hands-on DevOps project demonstrating a full CI/CD pipeline with:

- Jenkins pipeline automation
- Docker container build and registry push
- AWS EC2 deployment
- Blue-Green deployment strategy
- Automatic rollback on failure
- NGINX load balancing
- Incident debugging and observability

This project simulates a production deployment workflow used in real DevOps environments.


---

Related projects in this portfolio:

- docker-mini-project --> Docker Compose + NGINX Reverse Proxy
- jenkins-cicd-lab --> Jenkins CI/CD experiments

---

## Architecture

GitHub --> Jenkins --> Docker Build --> DockerHub --> SSH --> EC2 --> Docker Container --> Nginx Website

---

## Tools Used

- Jenkins
- Docker
- DockerHub
- AWS EC2
- Nginx 
- GitHub
- Linux / WSL

---

## CI/CD Pipeline FLow

1. Developer pushes code to GitHub
2. Jenkins detects changes using Poll SCm
3. Jenkins builds Docker image
4. Image is tagged with build number
5. Image is pushed to DockerHub
6. Jenkins SSH connects to EC2
7. EC2 pulls latest image
8. Existing container is replaced
9. Website updates automatically

---

## Deployment Verification
Example:

Visit: http://EC2_PUBLIC_IP/version.html

Example output:

Build: 24

Commit: 5ff2ea0f6a3650366709aef43d13493826cffae2

Built at: 2026-03-05T10:42:17+00:00

This proves the deployment pipeline executed successfully.

---

## Repository Structure

devops-production-lab
├ Dockerfile
├ Jenkinsfile
├ site/
│ ├ index.html
│ └ version.html
└ README.md

---

## Key Learning Outcomes

- Jenkins Pipeline configuration
- Docker image build automation
- Secure credential handling in Jenkins
- Automated deployment to EC2 via SSH
- Deployment verification using build metadata
- Poll SCM triggers for CI/CD

---

## Future Improvements

- Zero-downtime deployment
- Reverse proxy with Nginx
- HTTPS with Let's Encrypt
- Monitoring and logging

---

## Deployment Safety Gate

The Jenkins pipeline deploys a candidate container on port 8081 and performs a health check before replacing the production container.

Flow: 
1. Pull latest Docker image
2. Start candidate container (8081)
3. Health check `/version.html`
4. If healthy -> replace production container
5. If unhealthy -> abort deployment 

This prevents broken releases from immediately affecting production.

---

## Load Balancing and Resilience Test

This project was extended with a NGINX load balancer in front of two backend containers:

- app-blue -> port 8081
- app-green -> port 8082

NGINX distributed traffic between both backends using round-robin.

### Failure simulation 
One backend container was intentionally stopped.

Result:
- The website remained available
- All requests were served by the remaining healthy backend

This demonstrated basic services resilience and load balancing behaviour.

---

## Rollback Strategy

The Jenkins pipeline deploys a candidate container and validates `/version.html`.

If the health check fails:
- candidate container is removed
- previous working image tag is pulled 
- production container is restored automatically 

This was tested by intentionally breaking the deployment and confirming automatic rollback to the previous version.

---

## Architecture

Developer → GitHub → Jenkins Pipeline → Docker Image → DockerHub → EC2 Deployment

Components used:

- **Jenkins** – CI/CD automation
- **Docker** – containerized application
- **DockerHub** – image registry
- **AWS EC2** – application host
- **NGINX** – load balancer / reverse proxy
- **Blue-Green containers** – zero downtime deployment

---

## Incident Simulation & Observability

This project also includes a simulated production incident and debugging workflow.

### Scenario 
The NGINX load balancer container was running, but users were receiving the default "Welcome to Nginx" page instead of the application.

### Investigation Steps
1. Verified container state using `docker ps`
2. Checked container resources usage with `docker stats`
3. Inspected logs with `docker logs nginx-lb`
4. Verified HTTP response using `curl`
5. Entered the container to inspect the active nginx configuration

### Root Cause
The container was loading the default nginx configuration instead of the intended reverse proxy configuration.

### Resolution
- Replaced the configuration file with the correct upstream proxy configuration 
- Recreated the load balancer container 
- Verified traffic distribution across backend containers

### Result 
Traffic was successfully load balanced across:

- BLUE backend container
- GREEN backend container
