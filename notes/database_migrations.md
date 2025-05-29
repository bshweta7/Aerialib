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
### Local Steps
1. Define New Table 
   1. Update schema.ts
   2. Create router
   3. Add router to index.ts
2. Generate a Migration
   1. cd to ```Aerialib/backend/src```
   2. Run ```npx drizzle-kit generate```
   3. Verify and rename the file in ```Aerialib/backend/src/drizzle```
   4. Update name in ```drizzle/meta/_journal.json```
3. Git commit all changes and push

3. Run the Migration on the Server
   Option A: If your app has drizzle connected to the Dockerized DB

Use your backend to apply the migrations programmatically:

import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { db } from './db'; // your Drizzle DB client instance

await migrate(db, { migrationsFolder: 'drizzle/migrations' });

Or use a migration script like:

NODE_ENV=production node scripts/migrate.js

    ⚠️ You’ll need your app running with DATABASE_URL pointing to the server DB (via Docker Compose or .env file).

Option B: Apply manually inside Docker (if you don’t use app-driven migration)

    docker exec -it your_db_container bash

    Inside the container:

    psql -U youruser -d yourdb -f /path/to/migration.sql

    (You’d have to copy the .sql file into the container or use docker cp.)

