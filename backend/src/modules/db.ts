import pool from 'pg';
const { Pool } = pool;

const db = new Pool({
   host: process.env.DB_HOST,
   port: 5432,
   user: process.env.DB_USERNAME,
   database: process.env.DB_DATABASE,
   password: process.env.DB_PASSWORD
});

export default db;
