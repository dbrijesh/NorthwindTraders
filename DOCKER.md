# Docker Deployment Guide for Northwind Traders

This guide explains how to build and deploy the Northwind Traders application using Docker.

## Prerequisites

- Docker Desktop installed and running
- At least 4GB of available RAM
- Port 8080 available (or modify the port mapping)

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Development environment
docker-compose up --build

# Production environment with SQL Server
docker-compose -f docker-compose.prod.yml up --build
```

### Option 2: Using PowerShell Script

```powershell
# Build and run in development mode
.\build-docker.ps1 -Build -Run

# Build and run in production mode
.\build-docker.ps1 -Build -Run -Environment Production

# Stop the container
.\build-docker.ps1 -Stop

# Clean up all Docker resources
.\build-docker.ps1 -Clean
```

### Option 3: Manual Docker Commands

```bash
# Build the image
docker build -t northwind-traders .

# Run the container
docker run -d \
  --name northwind-app \
  -p 8080:8080 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e UseInMemoryDatabase=true \
  northwind-traders
```

## Application Access

Once running, the application will be available at:

- **Main Application**: http://localhost:8080
- **Health Check**: http://localhost:8080/health
- **API Documentation**: http://localhost:8080/swagger (if enabled)

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ASPNETCORE_ENVIRONMENT` | Application environment | `Production` |
| `ASPNETCORE_URLS` | URLs to bind to | `http://+:8080` |
| `UseInMemoryDatabase` | Use in-memory database | `true` |
| `ConnectionStrings__DefaultConnection` | Database connection string | - |
| `JwtSettings__Secret` | JWT signing secret | Required |
| `JwtSettings__Issuer` | JWT issuer | `NorthwindTraders` |
| `JwtSettings__Audience` | JWT audience | `NorthwindTradersUsers` |
| `JwtSettings__ExpiryMinutes` | JWT expiry time | `60` |

### Database Options

#### In-Memory Database (Default)
- Set `UseInMemoryDatabase=true`
- No additional setup required
- Data is lost when container restarts

#### SQL Server Database
- Set `UseInMemoryDatabase=false`
- Provide connection string via `ConnectionStrings__DefaultConnection`
- Use the production docker-compose file for automatic SQL Server setup

## Docker Images

The Dockerfile uses a multi-stage build process:

1. **Stage 1**: Build Angular frontend using Node.js 20
2. **Stage 2**: Build .NET 8 application and include Angular dist files
3. **Stage 3**: Create minimal runtime image with ASP.NET Core 8

### Image Optimization Features

- Multi-stage build reduces final image size
- Non-root user for security
- Health checks included
- Proper .dockerignore to exclude unnecessary files
- Alpine-based Node.js image for smaller footprint

## Production Deployment

### Security Considerations

1. **JWT Secret**: Use a strong, randomly generated secret
   ```bash
   export JWT_SECRET="your-256-bit-secret-key-here"
   ```

2. **Database**: Use a proper database server, not in-memory
3. **HTTPS**: Configure reverse proxy (nginx, traefik) for SSL termination
4. **Resource Limits**: Set appropriate memory and CPU limits

### Example Production Setup

```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  northwind-app:
    image: northwind-traders:latest
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - UseInMemoryDatabase=false
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=NorthwindTraders;...
      - JwtSettings__Secret=${JWT_SECRET}
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Change port mapping
   docker run -p 8081:8080 northwind-traders
   ```

2. **Out of Memory**
   ```bash
   # Increase Docker Desktop memory allocation
   # Or add memory limits to container
   docker run --memory=512m northwind-traders
   ```

3. **Build Failures**
   ```bash
   # Clean Docker cache
   docker system prune -a
   
   # Rebuild without cache
   docker build --no-cache -t northwind-traders .
   ```

### Viewing Logs

```bash
# View container logs
docker logs northwind-app

# Follow logs in real-time
docker logs -f northwind-app
```

### Container Shell Access

```bash
# Access running container
docker exec -it northwind-app /bin/bash
```

## Performance Tips

1. **Build Context**: Use .dockerignore to exclude unnecessary files
2. **Layer Caching**: Order Dockerfile commands from least to most frequently changing
3. **Multi-stage**: Separate build and runtime stages to reduce image size
4. **Resource Limits**: Set appropriate memory and CPU limits for containers

## Monitoring

The application includes health checks that can be used with:

- Docker health checks
- Kubernetes liveness/readiness probes
- Load balancer health checks
- Monitoring systems (Prometheus, etc.)

Health check endpoint: `GET /health`