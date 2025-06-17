import fs from "fs";
import path from "path";
import { parse } from "csv-parse/sync";
import { db } from "../../src/db";
import { eq } from "drizzle-orm";
import { transitionsTable } from "../../src/db/schema";
import { dataPath, normalizeValue, printDiff } from "../../src/seed_utils";

// Load and parse CSV
const csvPath = path.join(__dirname, `${dataPath}/transitions.csv`);
const csvData = fs.readFileSync(csvPath, "utf8");
const rows = parse(csvData, {
    columns: true,
    skip_empty_lines: true,
});

function castTransitionRow(row: any) {
    return {
        id: row.id,
        fromPoseId: row.from_pose_id,
        toPoseId: row.to_pose_id,
        name: normalizeValue(row.name),
        apparatus: row.apparatus,
        level: parseInt(row.level || "0"),
        transitionType: normalizeValue(row.transition_type),
        description: normalizeValue(row.description),
        teachingCues: normalizeValue(row.teaching_cues),
        safetyCues: normalizeValue(row.safety_cues),
        progressions: normalizeValue(row.progressions),
        modifications: normalizeValue(row.modifications),
        commonErrors: normalizeValue(row.common_errors),
        primaryMediaId: normalizeValue(row.primary_media_id),
        createdBy: row.created_by,
        updatedBy: row.updated_by,
        createdAt: row.created_at ? new Date(row.created_at) : new Date(),
        updatedAt: row.updated_at ? new Date(row.updated_at) : new Date(),
    };
}

async function seedTransitions() {
    for (const row of rows) {
        const parsedRow = castTransitionRow(row);
        const existing = await db
            .select()
            .from(transitionsTable)
            .where(eq(transitionsTable.id, parsedRow.id))
            .limit(1);

        if (existing.length > 0) {
            const existingRow = existing[0];
            const hasChanged = JSON.stringify({ ...existingRow, createdAt: null, updatedAt: null }) !==
                JSON.stringify({ ...parsedRow, createdAt: null, updatedAt: null });

            if (hasChanged) {
                await db.update(transitionsTable).set(parsedRow).where(eq(transitionsTable.id, parsedRow.id));
                console.log(`🔄 Updated transition: ${parsedRow.id}`);
                printDiff(existingRow, parsedRow);
            } else {
                console.log(`➖ No change in transition: ${parsedRow.id}`);
            }
        } else {
            await db.insert(transitionsTable).values(parsedRow);
            console.log(`➕ Inserted transition: ${parsedRow.id}`);
        }
    }

    console.log("🌱 Transition seeding complete.");
}

seedTransitions().catch((err) => {
    console.error("❌ Transition seeding failed:", err);
    process.exit(1);
});
