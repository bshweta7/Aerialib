# TODO IMPLEMENT PROPERLY
#!/bin/bash
# PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t your_table -Fc -f /backups/your_table_$(date +%Y%m%d_%H%M%S).dump