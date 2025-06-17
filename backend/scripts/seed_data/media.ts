import fs from "fs";
import path from "path";
import { parse } from "csv-parse/sync";
import { db } from "../../src/db";
import { eq } from "drizzle-orm";
import { mediaTable } from "../../src/db/schema";
import {isEqual} from "lodash";


// Load and parse CSV
const dataPath = "../../data/data_preparation/csv/"

const csvPath = path.join(__dirname, `${dataPath}/media.csv`);
const csvData = fs.readFileSync(csvPath, "utf8");
const rows = parse(csvData, {
    columns: true,
    skip_empty_lines: true,
});


function normalizeValue(value: any) {
    return typeof value === "string" && value.trim() === "" ? null : value;
}

function castRow(row: any) {
    return {
        id: row.id,
        mediaPath: row.media_path,
        hasThumbnail: null,
        mediaType: row.media_type,
        fileSize: parseInt(row.file_size || "0"),
        durationSeconds: parseInt(row.duration_seconds || "0"),
        name: normalizeValue(row.name),
        description: normalizeValue(row.description),
        apparatus: normalizeValue(row.apparatus),
        origin: normalizeValue(row.origin),
        takenTime: row.taken_time ? new Date(row.taken_time) : null,
        takenLocation: normalizeValue(row.taken_location),
        createdBy: row.created_by,
        updatedBy: row.updated_by,
        createdAt: row.created_at ? new Date(row.created_at) : new Date(),
        updatedAt: row.updated_at ? new Date(row.updated_at) : new Date(),
    };
}

function printDiff(oldRow: any, newRow: any) {
    for (const key in newRow) {
        const oldVal = oldRow[key];
        const newVal = newRow[key];
        if (String(oldVal) !== String(newVal)) {
            console.log(`  • ${key}:`);
            console.log(`    - before: ${oldVal}`);
            console.log(`    + after:  ${newVal}`);
        }
    }
}

async function seedMedia() {
    for (const row of rows) {
        const parsedRow = castRow(row);
        const existing = await db
            .select()
            .from(mediaTable)
            .where(eq(mediaTable.id, parsedRow.id))
            .limit(1);

        if (existing.length > 0) {
            const existingRow = existing[0];
            const hasChanged = !isEqual(
                { ...existingRow, createdAt: null, updatedAt: null },
                { ...parsedRow, createdAt: null, updatedAt: null }
            );

            if (hasChanged) {
                await db.update(mediaTable).set(parsedRow).where(eq(mediaTable.id, parsedRow.id));
                console.log(`🔄 Updated media: ${parsedRow.id}`);
                printDiff(existingRow, parsedRow);
            } else {
                console.log(`➖ No change in media: ${parsedRow.id}`);
            }
        } else {
            await db.insert(mediaTable).values(parsedRow);
            console.log(`➕ Inserted media: ${parsedRow.id}`);
        }
    }

    console.log("🌱 Media seeding complete.");
}

seedMedia().catch((err) => {
    console.error("❌ Seeding failed:", err);
    process.exit(1);
});
