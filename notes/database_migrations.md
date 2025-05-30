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

## Migration
### Local Set Up Steps
1. Define New Table 
   1. Update schema.ts
   2. Create router file
   3. Add router to index.ts
2. Generate a Migration
   1. cd to ```Aerialib/backend/src```
   2. Run ```npx drizzle-kit generate```
   3. Verify and rename the file in ```Aerialib/backend/src/drizzle```
   4. Update name in ```drizzle/meta/_journal.json```
3. Git commit all changes and push

### Local Testing Steps
1. cd to ```Aerialib/``` folder
2. Run ```docker compose exec backend npx ts-node scripts/migrate.ts```
3. Run ```docker compose exec -it db /bin/bash```
4. Inside the container, run ```psql -U postgres -d aerialib```
5. Verify that the migration ran successfully (with ```\dt``` or ```SELECT * FROM <table_name>;```)

### Production Steps
1. Git pull
2. Run ```docker compose up --build -d```
3. Run ```docker compose exec backend npx ts-node scripts/migrate.ts```
4. Run ```docker compose exec -it db /bin/bash```
5. Inside the container, run ```psql -U postgres -d aerialib```
6. Verify that the migration ran successfully (with ```\dt``` or ```SELECT * FROM <table_name>;```)
