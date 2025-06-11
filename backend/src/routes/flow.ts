// src/routes/flow.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import {NewFlow, flowsTable} from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";

const flowRouter = Router();

flowRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[FlowRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const newFlow: NewFlow = {
            ...req.body,
            createdAt: new Date(req.body.createdAt),
            updatedAt: new Date(req.body.updatedAt),
        }
        console.log(newFlow);

        const [flow] = await db.insert(flowsTable).values(newFlow).returning();

        // Verify flow was added
        if (flow) {
            res.status(201).json(flow);
        } else {
            res.status(500).json({ error: "Flow not created" });
        }

    } catch (e) {
        console.error("[FlowRouter] Post error", e);
        res.status(500).json({ error: e });
    }
});


/// Get all flows for user and admin
flowRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[FlowRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const adminId = process.env.ADMIN_USER_ID;

        const query = sql`
            SELECT
                flows.*,
                media.media_path AS primary_media_path
            FROM flows
            LEFT JOIN media
                AS media
                ON flows.primary_media_id = media.id
            WHERE flows.created_by = ${userId}
               OR flows.created_by = ${adminId};
        `;

        const result = await db.execute(query);
        res.json(result.rows);
    } catch (e) {
        console.error("[FlowRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});


/// Delete flow
flowRouter.delete("/delete/:id", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[FlowRouter] Unauthorized user');
            res.status(401).json({error: "Unauthorized"});
            return;
        }

        const flowId = req.params.id;

        const [flow] = await db
            .select()
            .from(flowsTable)
            .where(eq(flowsTable.id, flowId));

        // Verify the flow exists
        if (!flow) {
            console.log('[FlowRouter] Delete attempt for flow that does not exist');
            res.status(404).json({error: "Flow not found"});
            return;
        }

        // Verify the flow belongs to the user
        if (flow.createdBy !== req.user) {
            console.log('[FlowRouter] Delete attempt by user who does not own the flow');
            res.status(403).json({error: "Forbidden: You do not own this flow"});
            return;
        }

        // Attempt deletion and return deleted rows
        const deleted = await db
            .delete(flowsTable)
            .where(eq(flowsTable.id, flowId))
            .returning();

        if (deleted.length === 0) {
            console.log('[FlowRouter] Flow was not found');
            res.status(404).json({error: "Flow not found"});
            return;
        }

        res.json(true);
    } catch (e) {
        console.error("[FlowRouter] Delete error", e);
        res.status(500).json({error: e});
    }
});


/// Sync flows
flowRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[FlowRouter] Unauthorized user');
            res.status(401).json({error: "Unauthorized"});
            return;
        }

        const userId = req.user;
        const flowsList = req.body;

        console.log(`[FlowRouter] Received ${flowsList.length} flows for sync.`);

        // Ensure audit fields are set correctly
        const normalized: NewFlow[] = flowsList.map((t: any) => ({
            ...t,
            createdBy: t.createdBy ?? userId,
            updatedBy: userId,
            createdAt: new Date(t.createdAt),
            updatedAt: new Date(t.updatedAt),
        }));

        const pushedFlows = await db
            .insert(flowsTable)
            .values(normalized)
            .onConflictDoUpdate({
                target: flowsTable.id,
                set: buildFlowUpsertSet()
            })
            .returning();

        console.log(`[FlowRouter] ${pushedFlows.length} flows inserted or updated.`);

        res.status(201).json(pushedFlows);
    } catch (e) {
        console.error("[FlowRouter] Sync error", e);
        res.status(500).json({error: "[FlowRouter] Failed to sync flows"});
    }
});

export default flowRouter;

function buildFlowUpsertSet() {
    return {
        name: sql`excluded.name`,
        apparatus: sql`excluded.apparatus`,
        level: sql`excluded.level`,

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