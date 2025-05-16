docker compose -f docker-compose.dev.yaml up --build  --> run docker

npm install {package} --> (in terminal) to install new package
may need to run "docker compose exec -it backend npm install" in terminal to make it work in docker. 

http.cat for status code reference

docker compose -f docker-compose.dev.yaml up --build --> run dev docker locally

docker compose exec -it db /bin/bash --> lets you write things into the Exec tab in the docker desktop interface for postgres_container. 
docker compose exec -it backend /bin/bash --> lets you write things into the Exec tab in the docker desktop interface for backend_container.

docker compose ps --> shows the containers. Service shows the name you would put into the command below. 

psql -U postgres -d aerialib --> To get database for sql queries
remember ; for sql

\dt shows all of the available tables in a postgres db 

run "npx drizzle-kit push" from src folder when you want to add a new database schema to the postgreSQL db (e.g. after adding a Tasks table)

GIT TAG:
git tag -a v1.0.0 -m "Release version 1.0.0"


SERVER STUFF:
locally:
docker compose exec -it db /bin/pg_dump -U postgres -d aerialib -Fc -f /db_backups/db_$(date +%Y%m%d_%H%M%S).dump --> make the dump file
put the dump file in db_backups (use sudo because its a docker mount)
git pull to the server
docker exec -it db_container psql -U postgres -c "DROP DATABASE IF EXISTS aerialib;" --> drops old table
docker exec -it db_container psql -U postgres -c "CREATE DATABASE aerialib;" --> create new table
docker exec -it db_container pg_restore -U postgres -d aerialib /db_backups/db_20250509_204029.dump --> restore with pg_restore
docker exec -it db_container psql -U postgres -d aerialib -c "\dt" --> lists tables

docker logs backend_container -f --> logs

ls db_backups/

docker compose exec -it db /bin/bash -c "pg_restore -U postgres -d aerialib /db_backups/db_20250321_194023.dump"





OTHER STUFF
ps aux | grep pacman --> check other pacman processes
processes are stored in lock file, can clear lock file with this command


GIT TAGS
# Step 1: Find the commit the old tag points to
git rev-parse v1.0
# Example output: abc123def456...

# Step 2: Delete the old tag
git tag -d v1.0

# Step 3: Create the new tag pointing to the same commit
git tag v1.0.0 abc123def456

# OR (preferred for releases): make it annotated
git tag -a v1.0.0 abc123def456^{} -m "Rename v1.0 to v1.0.0"

# Step 4: Push changes to remote
git push origin :refs/tags/v1.0   # delete old remote tag
git push origin v1.0.0            # push new tag
