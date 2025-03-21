# TODO IMPLEMENT PROPERLY
# !/bin/bash

docker compose exec -it db /bin/pg_dump -U postgres -d aerialib -Fc -f /db_backups/db_$(date +%Y%m%d_%H%M%S).dump