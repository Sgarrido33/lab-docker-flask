#!/bin/bash

case "$1" in
  "dev")
    echo "🔧 Iniciando entorno de desarrollo..."
    ./scripts/run-dev.sh
    ;;
  "prod")
    echo "🏭 Iniciando entorno de producción..."
    ./scripts/run-prod.sh
    ;;
  "status")
    echo "📊 Estado de contenedores Flask:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter name=flask
    ;;
  "stop")
    echo "🛑 Deteniendo todos los contenedores Flask..."
    docker stop flask-dev flask-prod 2>/dev/null || true
    docker rm flask-dev flask-prod 2>/dev/null || true
    echo "✅ Contenedores detenidos"
    ;;
  "logs")
    if [ "$2" = "dev" ]; then
      docker logs -f flask-dev
    elif [ "$2" = "prod" ]; then
      docker logs -f flask-prod
    else
      echo "Uso: $0 logs [dev|prod]"
    fi
    ;;
  *)
    echo "Uso: $0 {dev|prod|status|stop|logs [dev|prod]}"
    echo ""
    echo "Comandos:"
    echo "  dev     - Iniciar entorno de desarrollo (puerto 8080)"
    echo "  prod    - Iniciar entorno de producción (puerto 8081)"
    echo "  status  - Ver estado de contenedores"
    echo "  stop    - Detener todos los contenedores"
    echo "  logs    - Ver logs (especificar dev o prod)"
    exit 1
    ;;
esac
