#!/bin/bash

set -e  # Exit on first error

echo "🔍 Starting comprehensive health check..."
echo "========================================"

# Configuración variables
SPARK_MASTER_URL="${SPARK_MASTER_URL:-http://localhost:8080}"
KAFKA_BROKER="${KAFKA_BROKER:-localhost:9092}"
CONTAINER_NAMESPACE="${COMPOSE_PROJECT_NAME:-spark-docker-lab}"

# Función para checks con reintentos
check_with_retry() {
    local command="$1"
    local description="$2"
    local max_retries=3
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if eval "$command"; then
            echo "✅ $description: Healthy"
            return 0
        fi
        echo "⏳ $description: Retrying... ($((retry_count+1))/$max_retries)"
        sleep 5
        ((retry_count++))
    done
    
    echo "❌ $description: Failed after $max_retries attempts"
    return 1
}

# Check Spark Master UI
check_with_retry \
    "curl -s -f $SPARK_MASTER_URL > /dev/null" \
    "Spark Master UI"

# Check Kafka broker
check_with_retry \
    "docker exec ${CONTAINER_NAMESPACE}-kafka-1 kafka-broker-api-versions --bootstrap-server $KAFKA_BROKER > /dev/null" \
    "Kafka Broker"

# Check Spark App (mejor approach)
check_with_retry \
    "docker ps --filter 'name=${CONTAINER_NAMESPACE}-spark-app' --filter 'status=running' | grep -q 'spark-app'" \
    "Spark App Container"

# Check Spark App via REST API (si está disponible)
check_with_retry \
    "curl -s http://localhost:4040/api/v1/applications | grep -q '\"name\"'" \
    "Spark Application API"

# Check topics existence (opcional)
check_with_retry \
    "docker exec ${CONTAINER_NAMESPACE}-kafka-1 kafka-topics --list --bootstrap-server $KAFKA_BROKER | grep -q 'input-topic'" \
    "Kafka Topics"

echo "========================================"
echo "📊 Health check summary:"
echo "• Spark Master: $(curl -s $SPARK_MASTER_URL >/dev/null && echo '✅' || echo '❌')"
echo "• Kafka: $(docker exec ${CONTAINER_NAMESPACE}-kafka-1 kafka-broker-api-versions --bootstrap-server $KAFKA_BROKER >/dev/null 2>&1 && echo '✅' || echo '❌')"
echo "• Spark App: $(docker ps --filter 'name=spark-app' --filter 'status=running' | grep -q 'spark-app' && echo '✅' || echo '❌')"

echo "🏁 Health check completed at $(date)"