# DevOps CI/CD Production Deployment Pipeline Project

## Project Overview
This project demonstrates a complete CI/CD pipeline using Jenkins, Docker, DockerHub, and AWS EC2.

The pipeline automatically buils a Docker image, pushes it to DockerHub, and deploys it to an EC2 server.

A deployment metadata page ('/Version.html') proves that the deployment was successful by displaying the build number, commit hash, and build timestamp.

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
#Example:
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

