#!/bin/bash
set -e

# Variables de configuración
APP_NAME="flask-docker-app"
VERSION="1.0"
DOCKERHUB_USER="sgarrido3"
AWS_REGION="us-east-2"
AWS_ACCOUNT_ID="183295430759"

echo "🏗️  Construyendo imagen Docker..."
docker build -t $APP_NAME:$VERSION .

echo "🐳 Publicando en Docker Hub..."
docker tag $APP_NAME:$VERSION $DOCKERHUB_USER/$APP_NAME:$VERSION
docker tag $APP_NAME:$VERSION $DOCKERHUB_USER/$APP_NAME:latest
docker push $DOCKERHUB_USER/$APP_NAME:$VERSION
docker push $DOCKERHUB_USER/$APP_NAME:latest

echo "☁️  Publicando en AWS ECR..."
# Login en ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Crear repositorio si no existe
aws ecr create-repository --repository-name $APP_NAME --region $AWS_REGION 2>/dev/null || true

# Etiquetar y subir a ECR
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME"
docker tag $APP_NAME:$VERSION $ECR_URI:$VERSION
docker tag $APP_NAME:$VERSION $ECR_URI:latest
docker push $ECR_URI:$VERSION
docker push $ECR_URI:latest

echo "✅ ¡Despliegue completado!"
echo "Docker Hub: https://hub.docker.com/r/$DOCKERHUB_USER/$APP_NAME"
echo "AWS ECR: $ECR_URI"