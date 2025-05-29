# Database Migrations

## General Information
### Database Setup
* Database is managed by docker
* It is mounted to ./db_postgres:/var/lib/postgresql/data (see docker-compose.yml), so files are accessible in ./db_postgres
* Migrations are managed by Drizzle ORM (with drizzle-kit)

## Backup Prod Database
1. Exec into the container ```docker compose exec -it db /bin/bash```
2. Inside the container, run ```pg_dump -U postgres -d aerialib -F c -f /db_backups/prod_$(date +%Y%m%d_%H%M).dump```
3. Copy to local machine if needed (stored in db_backups on server)

## 