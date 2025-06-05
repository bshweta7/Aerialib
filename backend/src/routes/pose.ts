import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import {mediaTable, NewFlow, NewPose, posesTable} from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";
import mediaRouter from "./media";

const poseRouter = Router();

/// Create new pose in db
poseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[PoseRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        // Prevent duplicate slug
        const existing = await db
            .select()
            .from(posesTable)
            .where(eq(posesTable.slug, req.body.slug));

        if (existing.length > 0) {
            res.status(409).json({ error: "duplicate" });
            return; // TODO - cleaner to update AuthRequest and return every res.status - i.e. return res.status... instead of res.status; return;
        }

        const newPose: NewPose = req.body;
        console.log(newPose);

        const [pose] = await db.insert(posesTable).values(newPose).returning();

        // Verify pose was added
        if (pose) {
            res.status(201).json(pose);
        } else {
            res.status(500).json({ error: "Pose not created" });
        }

    } catch (e) {
        console.log('[PoseRouter] Post error', e);
        res.status(500).json({ error: e })
    }
})

poseRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[PoseRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const adminId = process.env.ADMIN_USER_ID;

        const query = sql`
          SELECT 
            poses.*,
            thumbnail_media.media_path AS thumbnail_path,
            full_media.media_path AS media_path
          FROM poses
            LEFT JOIN media 
                AS thumbnail_media 
                ON poses.thumbnail_media_id = thumbnail_media.id
            LEFT JOIN media 
                AS full_media 
                ON poses.media_id = full_media.id
            WHERE poses.created_by = ${userId}
                OR poses.created_by = ${adminId};
        `;

        // Execute the raw SQL query using db.execute()
        const result = await db.execute(query);

        // Access the rows from the result
        const allPoses = result.rows;

        res.json(allPoses);

    } catch (e) {
        console.log('[PoseRouter] Get error', e);
        res.status(500).json({ error: e })
    }
})

poseRouter.delete("/delete/:id", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[PoseRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const poseId = req.params.id;

        const [pose] = await db
            .select()
            .from(posesTable)
            .where(eq(posesTable.id, poseId));

        // Verify the pose exists
        if (!pose) {
            console.log('[PoseRouter] Delete attempt for pose that does not exist');
            res.status(404).json({ error: "Pose not found" });
            return;
        }

        // Verify the pose belongs to the user
        if (pose.createdBy !== req.user) {
            console.log('[PoseRouter] Delete attempt by user who does not own the pose');
            res.status(403).json({ error: "Forbidden: You do not own this pose" });
            return;
        }

        // Attempt deletion and return deleted rows
        const deleted = await db.delete(posesTable)
            .where(eq(posesTable.id, poseId))
            .returning();

        if (deleted.length === 0) {
            console.log('[PoseRouter] Pose was not found');
            res.status(404).json({ error: "Pose not found" });
            return;
        }

        res.json(true);
    } catch (e) {
        console.log('[PoseRouter] Delete error', e);
        res.status(500).json({ error: e })
    }
})

/// Sync poses from frontend
poseRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
          console.log('[PoseRouter] Unauthorized user');
          res.status(401).json({ error: "Unauthorized" });
          return;
        }

        const userId = req.user;
        const posesList = req.body;

        console.log(`[PoseRouter] Received ${posesList.length} poses for sync.`);

        // Ensure audit fields are set correctly
        const normalized: NewPose[] = posesList.map((pose: any) => ({
            ...pose,
            createdBy: pose.createdBy ?? userId,
            updatedBy: userId,
            createdAt: new Date(pose.createdAt),
            updatedAt: new Date(pose.updatedAt),
        }));

        const pushedPoses = await db
            .insert(posesTable)
            .values(normalized)
            .onConflictDoUpdate({
                target: posesTable.id,
                set: buildPoseUpsertSet()
            })
            .returning();

        console.log(`[PoseRouter] ${pushedPoses.length} poses inserted or updated.`);
        pushedPoses.forEach(p => {
            console.log(`[PoseRouter] Upserted pose: ${p.slug}`);
        });

        res.status(201).json(pushedPoses);
    } catch (e) {
        console.error("[PoseRouter] Sync error:", e);
        res.status(500).json({ error: "Failed to sync poses" });
    }
});


export default poseRouter;

function buildPoseUpsertSet() {
    return {
        slug: sql`excluded.slug`,
        displayName: sql`excluded.display_name`,
        altName: sql`excluded.alt_name`,
        baseName: sql`excluded.base_name`,
        prefix: sql`excluded.prefix`,
        suffix: sql`excluded.suffix`,
        gripPosition: sql`excluded.grip_position`,
        legPosition: sql`excluded.leg_position`,
        positionInBar: sql`excluded.position_in_bar`,
        apparatus: sql`excluded.apparatus`,
        level: sql`excluded.level`,
        poseType: sql`excluded.pose_type`,
        description: sql`excluded.description`,
        teachingCues: sql`excluded.teaching_cues`,
        safetyCues: sql`excluded.safety_cues`,
        progressions: sql`excluded.progressions`,
        modifications: sql`excluded.modifications`,
        commonErrors: sql`excluded.common_errors`,
        thumbnailId: sql`excluded.thumbnail_media_id`,
        mediaId: sql`excluded.media_id`,
        createdBy: sql`excluded.created_by`,
        updatedBy: sql`excluded.updated_by`,
        updatedAt: sql`excluded.updated_at`,
    };
}
