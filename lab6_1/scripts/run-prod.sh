#!/bin/bash
echo "🚀 Iniciando Flask en modo PRODUCCIÓN..."

# Detener contenedor si existe
docker stop flask-prod 2>/dev/null || true
docker rm flask-prod 2>/dev/null || true
HOST_PATH=$(pwd -W)/env/.env.prod
# Ejecutar en modo production
docker run -d \
  --name flask-prod \
  -p 8081:5000 \
  -v "${HOST_PATH}:/app/.env:ro" \
  --restart unless-stopped \
  flask-docker-app:1.1

echo "✅ Flask PROD ejecutándose en http://localhost:8081"
echo "📋 Para ver logs: docker logs -f flask-prod"
echo "🛑 Para detener: docker stop flask-prod"