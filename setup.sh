#!/bin/bash

# Configuration
NETWORK_NAME="dev-tools-net"

# Database (MySQL)
DB_IMAGE="mysql:latest"
DB_CONTAINER="mysql-db"
DB_PORT="3306"
DB_HOST_PORT="3306"
DB_NAME="our-app-db"
DB_USER="root"
DB_PASS="my-secret-pw"

# Application (Joomla)
APP_IMAGE="joomla:latest"
APP_CONTAINER="joomla-app"
APP_PORT="80"
APP_HOST_PORT="8080"

echo ""
echo "Setting up Docker environment for Joomla + MySQL..."

# Create Docker network (if doesn't exist)
docker network create "$NETWORK_NAME" 2>/dev/null && echo "Network created: $NETWORK_NAME"

# Pull latest images
docker pull "$DB_IMAGE"
docker pull "$APP_IMAGE"

# Start MySQL container
echo "Starting MySQL container..."
docker run -d \
  --name "$DB_CONTAINER" \
  --network "$NETWORK_NAME" \
  -e MYSQL_ROOT_PASSWORD="$DB_PASS" \
  -e MYSQL_DATABASE="$DB_NAME" \
  -p "$DB_HOST_PORT:$DB_PORT" \
  "$DB_IMAGE"

# Start Joomla container
echo "Starting Joomla container..."
docker run -d \
  --name "$APP_CONTAINER" \
  --network "$NETWORK_NAME" \
  -e JOOMLA_DB_HOST="$DB_CONTAINER" \
  -e JOOMLA_DB_USER="$DB_USER" \
  -e JOOMLA_DB_PASSWORD="$DB_PASS" \
  -e JOOMLA_DB_NAME="$DB_NAME" \
  -p "$APP_HOST_PORT:$APP_PORT" \
  "$APP_IMAGE"

echo ""
echo "All services are up!"
echo "Access Joomla: http://localhost:$APP_HOST_PORT"
echo ""
