#!/bin/bash

# Variables
DOCKER_USERNAME="pashitox"
IMAGE_NAME="spark-docker-lab"
TAG="latest"

echo "🔨 Building image..."
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$TAG .

echo "🔐 Logging in to Docker Hub..."
docker login -u $DOCKER_USERNAME

echo "🚀 Pushing image to Docker Hub..."
docker push $DOCKER_USERNAME/$IMAGE_NAME:$TAG

echo "✅ Image pushed successfully: $DOCKER_USERNAME/$IMAGE_NAME:$TAG"