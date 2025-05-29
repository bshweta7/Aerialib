// scripts/migrate.ts
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { db } from '../src/db'; // adjust to your drizzle db instance
import path from 'path';

async function runMigration() {
    try {
        await migrate(db, {
            migrationsFolder: path.resolve(__dirname, '../src/drizzle'),
        });
        // await migrate(db, { migrationsFolder: 'drizzle/migrations' });
        console.log('✅ Migration completed successfully!');
        process.exit(0);
    } catch (err) {
        console.error('❌ Migration failed:', err);
        process.exit(1);
    }
}

runMigration();
