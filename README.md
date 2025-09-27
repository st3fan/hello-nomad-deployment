# Hello Nomad Deployment

A minimal Go web server that serves "Hello, Nomad!" with complete deployment automation using Docker, GitHub Actions, and HashiCorp Nomad.

## Features

- 🚀 Minimal Go web server serving "Hello, Nomad!" message
- 🐳 Multi-stage Docker build targeting x86_64 architecture
- 🔄 Automated CI/CD with GitHub Actions
- 📦 Container registry integration with GitHub Container Registry (GHCR)
- 🎯 HashiCorp Nomad deployment automation
- ❤️ Health check endpoint at `/health`

## API Endpoints

- `GET /` - Returns "Hello, Nomad!" message
- `GET /health` - Health check endpoint (returns "OK")

## Local Development

### Run with Go
```bash
go run main.go
# Server starts on http://localhost:8080
```

### Run with Docker
```bash
docker build -t hello-nomad .
docker run -p 8080:8080 hello-nomad
```

## Deployment

### Continuous Integration
The `.github/workflows/build.yml` workflow automatically:
- Builds and pushes Docker images to GHCR on every commit to main
- Tags images with branch names and commit SHAs

### Production Deployment
The `.github/workflows/deploy.yml` workflow automatically:
- Triggers when a GitHub Release is created
- Builds and pushes a tagged Docker image
- Deploys the application to Nomad at https://nomad.sateh.com

### Nomad Configuration
The `hello-nomad.nomad` file defines:
- Service-type job with 2 replicas
- Health checks on the `/health` endpoint
- Resource allocation (100 CPU, 64MB memory)
- Service discovery registration

## Environment Variables

- `PORT` - Server port (default: 8080)

## Architecture

- **Language**: Go 1.24
- **Container**: Multi-stage Docker build with scratch base image
- **Orchestration**: HashiCorp Nomad
- **CI/CD**: GitHub Actions
- **Registry**: GitHub Container Registry (GHCR)
