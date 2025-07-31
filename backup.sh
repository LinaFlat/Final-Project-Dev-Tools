#!/bin/bash

# Load configuration
MYSQL_CONTAINER="mysql-db"
# JOOMLA_CONTAINER="joomla-app"
DB_PASS="my-secret-pw"

BACKUP_PATH="backups"
DATE_TAG=$(date '+%Y-%m-%d_%H-%M-%S')
DB_DUMP="$BACKUP_PATH/db_$DATE_TAG.sql.gz"
JOOMLA_DUMP="$BACKUP_PATH/files_$DATE_TAG.tar.gz"

echo "==> Starting Joomla project backup..."

mkdir -p "$BACKUP_PATH"
    
echo "Saved: $JOOMLA_DUMP"

# Check MySQL container
if ! docker inspect -f '{{.State.Running}}' "$MYSQL_CONTAINER" &> /dev/null; then
    echo "[!] MySQL container not running. Aborting..."
    exit 1
fi

# Backup database
echo "-- Dumping MySQL data..."
docker exec "$MYSQL_CONTAINER" sh -c \
    "exec mysqldump -uroot -p$DB_PASS --all-databases" | gzip > "$DB_DUMP"

if [ -f "$DB_DUMP" ]; then
    echo "Database dump created: $DB_DUMP"
else
    echo "[X] Failed to create database dump!"
    exit 1
fi

echo "Backup complete!"
