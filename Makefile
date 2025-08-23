# Makefile para Spark Streaming con Kafka

# Variables configurables
COMPOSE_PROD = docker-compose -f docker-compose.prod.yml
COMPOSE_DEV = docker-compose -f docker-compose.dev.yml
SHELL := /bin/bash

.PHONY: build build-nocache up down logs clean deploy healthcheck dev stop-dev restart status

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
	docker images prune -a --filter "until=24h"
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

# Help
help:
	@echo "📋 Comandos disponibles:"
	@echo "  make build      - Build imágenes de producción"
	@echo "  make up         - Levantar servicios producción"
	@echo "  make deploy     - Deploy sin downtime"
	@echo "  make logs       - Ver logs producción"
	@echo "  make healthcheck- Health check de servicios"
	@echo "  make dev        - Levantar desarrollo"
	@echo "  make stop-dev   - Detener desarrollo"
	@echo "  make clean      - Limpieza segura"