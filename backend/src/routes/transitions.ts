import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { transitionsTable, NewTransition } from "../db/schema";
import { eq, sql } from "drizzle-orm";

const transitionRouter = Router();

/// Create a new transition
transitionRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[TransitionRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const newTransition: NewTransition = {
            ...req.body,
            createdAt: new Date(req.body.createdAt),
            updatedAt: new Date(req.body.updatedAt),
        }
        console.log(newTransition);

        const [transition] = await db.insert(transitionsTable).values(newTransition).returning();

        // Verify transition was added
        if (transition) {
            res.status(201).json(transition);
        } else {
            res.status(500).json({ error: "Transition not created" });
        }

    } catch (e) {
        console.error("[TransitionRouter] Post error", e);
        res.status(500).json({ error: e });
    }
});

/// Get all transitions for user and admin
transitionRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[TransitionRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const adminId = process.env.ADMIN_USER_ID;

        const query = sql`
            SELECT
                transitions.*,
                media.media_path AS primary_media_path
            FROM transitions
            LEFT JOIN media
                AS media
                ON transitions.primary_media_id = media.id
            WHERE transitions.created_by = ${userId}
               OR transitions.created_by = ${adminId};
        `;

        const result = await db.execute(query);
        res.json(result.rows);
    } catch (e) {
        console.error("[TransitionRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});

/// Delete transition
transitionRouter.delete("/delete/:id", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[TransitionRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const transitionId = req.params.id;

        const [transition] = await db
            .select()
            .from(transitionsTable)
            .where(eq(transitionsTable.id, transitionId));

        // Verify the transition exists
        if (!transition) {
            console.log('[TransitionRouter] Delete attempt for transition that does not exist');
            res.status(404).json({ error: "Transition not found" });
            return;
        }

        // Verify the transition belongs to the user
        if (transition.createdBy !== req.user) {
            console.log('[TransitionRouter] Delete attempt by user who does not own the transition');
            res.status(403).json({ error: "Forbidden: You do not own this transition" });
            return;
        }

        // Attempt deletion and return deleted rows
        const deleted = await db
            .delete(transitionsTable)
            .where(eq(transitionsTable.id, transitionId))
            .returning();

        if (deleted.length === 0) {
            console.log('[TransitionRouter] Transition was not found');
            res.status(404).json({ error: "Transition not found" });
            return;
        }

        res.json(true);
    } catch (e) {
        console.error("[TransitionRouter] Delete error", e);
        res.status(500).json({ error: e });
    }
});

/// Sync transitions
transitionRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[TransitionRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const transitionsList = req.body;

        console.log(`[TransitionRouter] Received ${transitionsList.length} transitions for sync.`);

        // Ensure audit fields are set correctly
        const normalized: NewTransition[] = transitionsList.map((t: any) => ({
            ...t,
            createdBy: t.createdBy ?? userId,
            updatedBy: userId,
            createdAt: new Date(t.createdAt),
            updatedAt: new Date(t.updatedAt),
        }));

        const pushedTransitions = await db
            .insert(transitionsTable)
            .values(normalized)
            .onConflictDoUpdate({
                target: transitionsTable.id,
                set: buildTransitionUpsertSet()
            })
            .returning();

        console.log(`[TransitionRouter] ${pushedTransitions.length} transitions inserted or updated.`);

        res.status(201).json(pushedTransitions);
    } catch (e) {
        console.error("[TransitionRouter] Sync error", e);
        res.status(500).json({ error: "[TransitionRouter] Failed to sync transitions" });
    }
});

export default transitionRouter;

function buildTransitionUpsertSet() {
    return {
        fromPoseId: sql`excluded.from_pose_id`,
        toPoseId: sql`excluded.to_pose_id`,
        name: sql`excluded.name`,

        apparatus: sql`excluded.apparatus`,
        level: sql`excluded.level`,
        transitionType: sql`excluded.transition_type`,

        description: sql`excluded.description`,
        teachingCues: sql`excluded.teaching_cues`,
        safetyCues: sql`excluded.safety_cues`,
        progressions: sql`excluded.progressions`,
        modifications: sql`excluded.modifications`,
        commonErrors: sql`excluded.common_errors`,

        primaryMediaId: sql`excluded.primary_media_id`,

        updatedBy: sql`excluded.updated_by`,
        updatedAt: sql`excluded.updated_at`,
    };
}
