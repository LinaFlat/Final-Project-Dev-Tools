#!/bin/bash

# === Configuration ===
DB_CONTAINER="mysql-db"
DB_NAME="our-app-db"
DB_USER="root"
DB_PASS="my-secret-pw"
DB_PORT="3307"
DB_HOST_PORT="3307"
NETWORK_NAME="dev-tools-net"
DB_IMAGE="mysql:latest"


BACKUPS_DIR="./backups"
LATEST_DB_BACKUP=$(ls -t "$BACKUPS_DIR"/*.sql.gz 2>/dev/null | head -n 1)

echo ""
echo "== DB Restore Script =="

echo "Pulling MySQL container..."
docker pull "$DB_IMAGE"

echo "Starting MySQL container..."
if [ "$(docker ps -q -f name=$DB_CONTAINER)" ]; then
    echo "Stopping and removing existing container..."
    docker stop "$DB_CONTAINER"
    docker rm "$DB_CONTAINER"
fi

docker run -d \
  --name "$DB_CONTAINER" \
  --network "$NETWORK_NAME" \
  -e MYSQL_ROOT_PASSWORD="$DB_PASS" \
  -e MYSQL_DATABASE="$DB_NAME" \
  -p "$DB_HOST_PORT:$DB_PORT" \
  "$DB_IMAGE"


echo "-- Dropping and recreating MySQL database..."
docker exec "$DB_CONTAINER" mysqladmin -u "$DB_USER" -p "$DB_PASS" -f drop "$DB_NAME"
echo "Database dropped"
docker exec "$DB_CONTAINER" mysqladmin -u "$DB_USER" -p "$DB_PASS" -f create "$DB_NAME"

echo "Database created"

echo "-- Restoring MySQL data..."
gunzip -c "$LATEST_DB_BACKUP" | docker exec -i "$DB_CONTAINER" \
    mysql -u $DB_USER -p$DB_PASS --force $DB_NAME

if [ $? -eq 0 ]; then
    echo "Database restored successfully"
else
    echo "Database restore failed"
    exit 1
fi


echo ""
echo "== Restore complete! =="
