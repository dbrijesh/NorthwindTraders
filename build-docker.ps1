# PowerShell script to build and run Northwind Traders Docker container

param(
    [string]$Environment = "Development",
    [switch]$Build,
    [switch]$Run,
    [switch]$Stop,
    [switch]$Clean
)

$ImageName = "northwind-traders"
$ContainerName = "northwind-app"

Write-Host "Northwind Traders Docker Management Script" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

if ($Clean) {
    Write-Host "Cleaning up Docker resources..." -ForegroundColor Yellow
    
    # Stop and remove container
    docker stop $ContainerName 2>$null
    docker rm $ContainerName 2>$null
    
    # Remove image
    docker rmi $ImageName 2>$null
    
    # Clean up unused images and containers
    docker system prune -f
    
    Write-Host "Cleanup completed!" -ForegroundColor Green
    exit 0
}

if ($Stop) {
    Write-Host "Stopping Northwind Traders container..." -ForegroundColor Yellow
    docker stop $ContainerName
    Write-Host "Container stopped!" -ForegroundColor Green
    exit 0
}

if ($Build) {
    Write-Host "Building Northwind Traders Docker image..." -ForegroundColor Yellow
    
    # Build the Docker image
    docker build -t $ImageName .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker image built successfully!" -ForegroundColor Green
    } else {
        Write-Host "Docker build failed!" -ForegroundColor Red
        exit 1
    }
}

if ($Run) {
    Write-Host "Running Northwind Traders container..." -ForegroundColor Yellow
    
    # Stop existing container if running
    docker stop $ContainerName 2>$null
    docker rm $ContainerName 2>$null
    
    # Run the container
    if ($Environment -eq "Production") {
        docker run -d `
            --name $ContainerName `
            -p 8080:8080 `
            -e ASPNETCORE_ENVIRONMENT=Production `
            -e UseInMemoryDatabase=true `
            -e "JwtSettings__Secret=your-super-secret-jwt-key-here-make-it-long-and-secure" `
            $ImageName
    } else {
        docker run -d `
            --name $ContainerName `
            -p 8080:8080 `
            -e ASPNETCORE_ENVIRONMENT=Development `
            -e UseInMemoryDatabase=true `
            $ImageName
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Container started successfully!" -ForegroundColor Green
        Write-Host "Application is running at: http://localhost:8080" -ForegroundColor Cyan
        Write-Host "Health check: http://localhost:8080/health" -ForegroundColor Cyan
        
        # Show container logs
        Start-Sleep -Seconds 2
        Write-Host "`nContainer logs:" -ForegroundColor Yellow
        docker logs $ContainerName
    } else {
        Write-Host "Failed to start container!" -ForegroundColor Red
        exit 1
    }
}

if (-not $Build -and -not $Run -and -not $Stop -and -not $Clean) {
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  .\build-docker.ps1 -Build                    # Build Docker image" -ForegroundColor White
    Write-Host "  .\build-docker.ps1 -Run                     # Run container (Development)" -ForegroundColor White
    Write-Host "  .\build-docker.ps1 -Run -Environment Production  # Run container (Production)" -ForegroundColor White
    Write-Host "  .\build-docker.ps1 -Build -Run              # Build and run" -ForegroundColor White
    Write-Host "  .\build-docker.ps1 -Stop                    # Stop container" -ForegroundColor White
    Write-Host "  .\build-docker.ps1 -Clean                   # Clean up all resources" -ForegroundColor White
    Write-Host ""
    Write-Host "Docker Compose alternatives:" -ForegroundColor Cyan
    Write-Host "  docker-compose up --build                   # Development" -ForegroundColor White
    Write-Host "  docker-compose -f docker-compose.prod.yml up --build  # Production" -ForegroundColor White
}