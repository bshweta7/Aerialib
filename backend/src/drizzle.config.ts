import { defineConfig } from "drizzle-kit";

export default defineConfig({
    dialect: "postgresql",
    schema: "./db/schema.ts",
    out: "./drizzle",
    dbCredentials: {
        host: "localhost",
        port: 5432,
        database: "aerialib",
        user: "postgres",
        password: "aerialib_postgres_secret_password",
        ssl: false, // TODO only for debug need to update for production
    }
})
