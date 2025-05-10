#!/bin/bash

# Get the absolute path to the project root (one level up from this script)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Configurations
CONTAINER_NAME="db_container"
DB_NAME="aerialib"
DB_USER="postgres"
SQL_FILENAME="aerialib_2025-05-09.sql"
BACKUP_DIR="$PROJECT_ROOT/db_backups"
SQL_PATH_ON_HOST="$BACKUP_DIR/$SQL_FILENAME"
SQL_PATH_IN_CONTAINER="/tmp/$SQL_FILENAME"

# Step 1: Ensure backup directory exists and move .sql file there (if it's in project root)
if [ -f "$PROJECT_ROOT/$SQL_FILENAME" ]; then
  mkdir -p "$BACKUP_DIR"
  mv "$PROJECT_ROOT/$SQL_FILENAME" "$SQL_PATH_ON_HOST"
  echo "✅ Moved SQL file to: $SQL_PATH_ON_HOST"
fi

# Step 2: Copy file into Docker container
docker cp "$SQL_PATH_ON_HOST" "$CONTAINER_NAME:$SQL_PATH_IN_CONTAINER"
echo "📦 Copied SQL file into container: $SQL_PATH_IN_CONTAINER"

# Step 3: Run import inside the container
docker exec -u "$DB_USER" -i "$CONTAINER_NAME" \
  psql -d "$DB_NAME" -f "$SQL_PATH_IN_CONTAINER"

echo "🎉 Import complete: $SQL_FILENAME → $DB_NAME in container $CONTAINER_NAME"

