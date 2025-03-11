import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

// TODO - move pg and entire db folder from src to db folder ???
const pool = new Pool({
    connectionString: "postgresql://postgres:aerialib_postgres_secret_password@db:5432/aerialib"      
});

export const db = drizzle(pool);