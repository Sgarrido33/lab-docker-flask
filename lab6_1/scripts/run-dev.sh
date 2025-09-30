#!/bin/bash
echo "🚀 Iniciando Flask en modo DESARROLLO..."

# Detener contenedor si existe
docker stop flask-env 2>/dev/null || true
docker rm flask-env 2>/dev/null || true
HOST_PATH=$(pwd -W)/env/.env.dev
# Ejecutar en modo development
docker run -d \
  --name flask-dev \
  -p 8080:5000 \
  -v "${HOST_PATH}:/app/.env:ro" \
  --restart unless-stopped \
  flask-docker-app:1.1