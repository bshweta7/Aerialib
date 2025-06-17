import fs from "fs";
import path from "path";
import { parse } from "csv-parse/sync";
import { db } from "../../src/db";
import { eq } from "drizzle-orm";
import { posesTable } from "../../src/db/schema";
import { dataPath, normalizeValue, printDiff } from "../../src/seed_utils";

// Load and parse CSV
const csvPath = path.join(__dirname, `${dataPath}/poses.csv`);
const csvData = fs.readFileSync(csvPath, "utf8");
const rows = parse(csvData, { columns: true, skip_empty_lines: true });

function castPoseRow(row: any) {
    return {
        id: row.id,
        slug: row.slug,
        displayName: row.display_name,
        altName: normalizeValue(row.alt_name),
        baseName: row.base_name,
        prefix: normalizeValue(row.prefix),
        suffix: normalizeValue(row.suffix),
        handPosition: normalizeValue(row.hand_position),
        legPosition: normalizeValue(row.leg_position),
        positionInBar: normalizeValue(row.position_in_bar),
        apparatus: row.apparatus,
        level: parseInt(row.level || "-1"),
        poseType: row.pose_type,
        description: normalizeValue(row.description),
        teachingCues: normalizeValue(row.teaching_cues),
        safetyCues: normalizeValue(row.safety_cues),
        progressions: normalizeValue(row.progressions),
        modifications: normalizeValue(row.modifications),
        commonErrors: normalizeValue(row.common_errors),
        primaryMediaId: row.primary_media_id,
        createdBy: row.created_by,
        updatedBy: row.updated_by,
        createdAt: row.created_at ? new Date(row.created_at) : new Date(),
        updatedAt: row.updated_at ? new Date(row.updated_at) : new Date(),
    };
}

async function seedPoses() {
    for (const row of rows) {
        const parsedRow = castPoseRow(row);
        const existing = await db
            .select()
            .from(posesTable)
            .where(eq(posesTable.id, parsedRow.id))
            .limit(1);

        if (existing.length > 0) {
            const existingRow = existing[0];
            const hasChanged = JSON.stringify({ ...existingRow, createdAt: null, updatedAt: null }) !==
                JSON.stringify({ ...parsedRow, createdAt: null, updatedAt: null });

            if (hasChanged) {
                await db.update(posesTable).set(parsedRow).where(eq(posesTable.id, parsedRow.id));
                console.log(`🔄 Updated pose: ${parsedRow.id}`);
                printDiff(existingRow, parsedRow);
            } else {
                console.log(`➖ No change in pose: ${parsedRow.id}`);
            }
        } else {
            await db.insert(posesTable).values(parsedRow);
            console.log(`➕ Inserted pose: ${parsedRow.id}`);
        }
    }

    console.log("🌱 Pose seeding complete.");
}

seedPoses().catch(err => {
    console.error("❌ Pose seeding failed:", err);
    process.exit(1);
});
