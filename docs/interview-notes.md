# Interview Notes – Reverse Proxy + Scaling Lab

## 1. Why use a reverse proxy?
- Single entry point
- Centralized routing
- Load balancing
- SSL termination (in production)
- Hides internal services

## 2. How does service discovery work in Docker Compose?
- Each service gets a DNS name equal to its service name
- NGINX can use that name in upstream block
- Docker internal network handles resolution

## 3. How does scaling work?
Command:
docker compose up -d --scale app=3

- Compose creates multiple replicas
- NGINX distributes traffic across replicas

## 4. How did I verify load balancing?
Using:
for i in {1..10}; do curl -s http://localhost:8081; echo; done

Result:
Different container IDs appeared (served-by=...)

## 5. Common Issues
- Port already in use
- Wrong upstream service name
- Containers not healthy
- NGINX config not reloaded
