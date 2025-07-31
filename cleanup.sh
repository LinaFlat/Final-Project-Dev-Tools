#!/bin/bash

# Configuration
PROJECT_NAME="joomla-devtools"
DB_CONTAINER="mysql-db"
DB_IMAGE="mysql:latest"
APP_CONTAINER="joomla-app"
APP_IMAGE="joomla:latest"
DOCKER_NET="dev-tools-net"
DOCKER_IMAGES=("$DB_IMAGE" "$APP_IMAGE")

VOLUMES_TO_CLEAN=true

echo ""
echo "=== [$PROJECT_NAME] Cleaning Environment ==="

# Stop running containers
for c in "$DB_CONTAINER" "$APP_CONTAINER"; do
    echo "--> Stopping container: $c"
    docker stop "$c" &>/dev/null || echo "   (already stopped)"
done

# Remove containers
for c in "$DB_CONTAINER" "$APP_CONTAINER"; do
    echo "--> Removing container: $c"
    docker rm "$c" &>/dev/null || echo "   (already removed)"
done

# Remove images
for img in "${DOCKER_IMAGES[@]}"; do
    echo "--> Removing image: $img"
    docker rmi "$img" &>/dev/null || echo "   (image not found or in use)"
done

# Remove network
echo "--> Deleting network: $DOCKER_NET"
docker network rm "$DOCKER_NET" &>/dev/null || echo "   (network not found)"

# Prune volumes
if [ "$VOLUMES_TO_CLEAN" = true ]; then
    echo "--> Pruning unused Docker volumes..."
    docker volume prune -f
fi

# System cleanup
echo "--> Cleaning system resources..."
docker system prune -f --volumes

# Summary
echo ""
echo "Docker cleanup summary:"
docker ps -a | grep -E "$DB_CONTAINER|$APP_CONTAINER" || echo "No remaining containers."
docker volume ls | grep joomla || echo "No joomla-related volumes."
docker network ls | grep "$DOCKER_NET" || echo "No matching network."

echo ""
echo "[$PROJECT_NAME] Cleanup complete."
echo ""
