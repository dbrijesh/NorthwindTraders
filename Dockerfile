# Multi-stage Dockerfile for Northwind Traders .NET 8 + Angular 19

# Stage 1: Build Angular frontend
FROM node:20-alpine AS angular-build
WORKDIR /app/ClientApp

# Copy package files
COPY Src/WebUI/ClientApp/package*.json ./

# Install dependencies (including dev dependencies needed for build)
RUN npm ci --legacy-peer-deps

# Copy Angular source code
COPY Src/WebUI/ClientApp/ ./

# Build Angular app for production
RUN npm run build -- --configuration production

# Stage 2: Build .NET application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dotnet-build
WORKDIR /app

# Copy solution and project files
COPY *.sln ./
COPY Src/Domain/*.csproj ./Src/Domain/
COPY Src/Application/*.csproj ./Src/Application/
COPY Src/Infrastructure/*.csproj ./Src/Infrastructure/
COPY Src/Persistence/*.csproj ./Src/Persistence/
COPY Src/Common/*.csproj ./Src/Common/
COPY Src/WebUI/*.csproj ./Src/WebUI/
COPY Tests/Application.UnitTests/*.csproj ./Tests/Application.UnitTests/
COPY Tests/Domain.UnitTests/*.csproj ./Tests/Domain.UnitTests/

# Restore dependencies
RUN dotnet restore

# Copy source code
COPY Src/ ./Src/
COPY Tests/ ./Tests/

# Copy Angular build output from previous stage
COPY --from=angular-build /app/ClientApp/dist ./Src/WebUI/ClientApp/dist

# Build and publish the application
RUN dotnet publish Src/WebUI/WebUI.csproj -c Release -o /app/publish --no-restore

# Stage 3: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Copy published application
COPY --from=dotnet-build /app/publish .

# Expose port
EXPOSE 8080

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start the application
ENTRYPOINT ["dotnet", "Northwind.WebUI.dll"]