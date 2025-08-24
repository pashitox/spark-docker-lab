# Makefile para Spark Streaming con Kafka

# Variables configurables
COMPOSE_PROD = docker compose -f docker-compose.prod.yml
COMPOSE_DEV = docker compose -f docker-compose.dev.yml
SHELL := /bin/bash

.PHONY: build build-nocache up down logs clean deploy healthcheck dev stop-dev restart status \
        docker-login docker-build docker-push docker-hub-deploy railway-setup railway-deploy

# Producción
build:
	$(COMPOSE_PROD) build

build-nocache:
	$(COMPOSE_PROD) build --no-cache

up:
	$(COMPOSE_PROD) up -d

down:
	$(COMPOSE_PROD) down

restart:
	$(COMPOSE_PROD) restart

logs:
	$(COMPOSE_PROD) logs -f

# DEPLOY SIN DOWNTIME (CORREGIDO)
deploy:
	$(COMPOSE_PROD) build --no-cache
	$(COMPOSE_PROD) up -d --remove-orphans
	@echo "🚀 Deployment realizado sin downtime"

# CLEAN SEGURO (CORREGIDO)
clean:
	$(COMPOSE_PROD) down -v --remove-orphans
	@echo "🧹 Limpieza completada (volúmenes eliminados)"

# Clean más agresivo (solo cuando sea necesario)
deep-clean: down
	docker image prune -a --filter "until=24h"
	@echo "🔍 Deep clean completado"

healthcheck:
	bash scripts/healthcheck.sh

status:
	$(COMPOSE_PROD) ps

# Desarrollo
dev:
	$(COMPOSE_DEV) up -d

stop-dev:
	$(COMPOSE_DEV) down

dev-logs:
	$(COMPOSE_DEV) logs -f

# Docker Hub commands
docker-login:
	docker login -u pashitox

docker-build:
	docker build -t pashitox/spark-docker-lab:latest .

docker-push:
	docker push pashitox/spark-docker-lab:latest

docker-hub-deploy: docker-build docker-push
	@echo "✅ Image pushed to Docker Hub"



# Help
help:
	@echo "📋 Comandos disponibles:"
	@echo "  make build             - Build imágenes de producción"
	@echo "  make up                - Levantar servicios producción"
	@echo "  make deploy            - Deploy sin downtime"
	@echo "  make logs              - Ver logs producción"
	@echo "  make healthcheck       - Health check de servicios"
	@echo "  make dev               - Levantar desarrollo"
	@echo "  make stop-dev          - Detener desarrollo"
	@echo "  make clean             - Limpieza segura"
	@echo "  make docker-login      - Login a Docker Hub"
	@echo "  make docker-build      - Build imagen para Docker Hub"
	@echo "  make docker-push       - Push imagen a Docker Hub"
	@echo "  make docker-hub-deploy - Build + push a Docker Hub"
	@echo "  make railway-setup     - Configurar para Railway"
	@echo "  make railway-deploy    - Deploy a Railway (sube a GitHub)"