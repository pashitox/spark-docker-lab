#!/bin/bash

set -e

echo "🚀 Starting production deployment..."

# Build with no cache for clean production images
echo "📦 Building fresh Docker images..."
docker-compose -f docker-compose.prod.yml build --no-cache

# Deploy with zero downtime
echo "🔄 Deploying new version..."
docker-compose -f docker-compose.prod.yml up -d --remove-orphans

# Health check verification (optional)
echo "⏳ Verifying services health..."
sleep 20

# Check if Spark master is responsive
if curl -f http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Spark Master is healthy"
else
    echo "❌ Spark Master health check failed"
    exit 1
fi

echo "🎉 Deployment completed successfully!"
echo "📊 Spark UI: http://localhost:8080"
echo "🔗 Kafka: localhost:9092"
echo "📝 View logs: docker-compose -f docker-compose.prod.yml logs -f"