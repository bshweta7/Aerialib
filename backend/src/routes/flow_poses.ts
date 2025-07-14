// src/routes/flow_poses.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import {NewFlowPose, flowPosesTable} from "../db/schema";
import { db } from "../db";
import {eq, sql} from "drizzle-orm";

const flowPoseRouter = Router();

/// Create a new flowPose
// flowPoseRouter.post("/", auth, async (req: AuthRequest, res) => {
//     try {
//         // Verify user
//         if (!req.user) {
//             console.log('[FlowPoseRouter] Unauthorized user');
//             res.status(401).json({ error: "Unauthorized" });
//             return;
//         }
//
//         const newFlowPose: NewFlowPose = {...req.body,}
//         console.log(newFlowPose);
//
//         const [flowPose] = await db.insert(flowPosesTable).values(newFlowPose).returning();
//
//         // Verify flowPose was added
//         if (flowPose) {
//             res.status(201).json(flowPose);
//         } else {
//             res.status(500).json({ error: "FlowPose not created" });
//         }
//
//     } catch (e) {
//         console.error("[FlowPoseRouter] Post error", e);
//         res.status(500).json({ error: e });
//     }
// });

/// Create multiple flow poses
flowPoseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user
        if (!req.user) {
            console.log('[FlowPoseRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const flowPoseList = req.body;
        console.log(`[FlowPoseRouter] Received ${flowPoseList.length} flow poses to add`);

        if (!Array.isArray(flowPoseList) || flowPoseList.length === 0) {
            res.status(400).json({ error: "Empty flowPose list" });
            return;
        }

        const normalized = flowPoseList.map((pose: any) => ({...pose}));

        const inserted = await db
            .insert(flowPosesTable)
            .values(normalized)
            .returning();

        // Verify flowPose was added
        if (inserted) {
            res.status(201).json(inserted);
        } else {
            res.status(500).json({ error: "FlowPose not created" });
        }

    } catch (e) {
        console.error("[FlowPoseRouter] Bulk insert error:", e);
        res.status(500).json({ error: "Failed to insert flow poses" });
    }
});


/// Get poses for all flows for a given user
flowPoseRouter.get("/", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[FlowPoseRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    const userId = req.user;
    const adminId = process.env.ADMIN_USER_ID;

    try {
        // TODO need to verify that this works
        const query = sql`
            SELECT flow_poses.*
            FROM flow_poses
                     INNER JOIN flows ON flows.id = flow_poses.flow_id
            WHERE flows.created_by = ${userId}
               OR flows.created_by = ${adminId}
            ORDER BY flow_poses.flow_id, flow_poses.pose_order ASC;
        `;

        const result = await db.execute(query);
        res.json(result.rows);
    } catch (e) {
        console.error("[FlowPoseRouter] Get error:", e);
        res.status(500).json({ error: e });
    }
});

/// Delete multiple flow_poses given a list of flow_pose_ids
flowPoseRouter.delete("/", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[FlowPoseRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    const userId = req.user;
    const { ids } = req.body;

    if (!Array.isArray(ids) || ids.length === 0) {
        res.status(400).json({ error: "Missing or invalid 'ids' in request body" });
        return;
    }

    try {
        const idList = sql.join(ids.map(id => sql`${id}`), sql`, `);

        const query = sql`
            DELETE FROM flow_poses
            WHERE id IN (${idList})
              AND flow_id IN (
                  SELECT id FROM flows
                  WHERE created_by = ${userId}
              )
            RETURNING *;
        `;

        const result = await db.execute(query);
        console.log(`[FlowPoseRouter] Deleted ${result.rows.length} flow poses`);
        res.json({ deletedCount: result.rows.length, deleted: result.rows });

    } catch (e) {
        console.error("[FlowPoseRouter] Bulk delete error", e);
        res.status(500).json({ error: "Failed to delete flow poses" });
    }
});


/// Delete all flow_poses for a given flowId
// TODO change the route (maybe just deleteFlow/:flowId)
flowPoseRouter.delete("/delete/flow/:flowId", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[FlowPoseRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    const flowId = req.params.flowId;

    try {
        const deleted = await db
            .delete(flowPosesTable)
            .where(eq(flowPosesTable.flowId, flowId))
            .returning();

        if (deleted.length === 0) {
            console.log(`[FlowPoseRouter] No flow poses found for flow ${flowId}`);
            res.status(200).json([]); // ✅ not 404
            return;
        }

        res.json(true);
    } catch (e) {
        console.error("[FlowPoseRouter] Delete error", e);
        res.status(500).json({ error: "Failed to delete flow poses" });
    }
});


/// Delete flow_pose for given id
// TODO remove this, just use default delete / function
flowPoseRouter.delete("/delete/pose/:flowPoseId", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[FlowPoseRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    const flowPoseId = req.params.flowPoseId;

    try {
        const deleted = await db
            .delete(flowPosesTable)
            .where(eq(flowPosesTable.id, flowPoseId))
            .returning();

        if (deleted.length === 0) {
            console.log('[FlowPoseRouter] FlowPose was not found');
            res.status(404).json({ error: "FlowPose not found" });
            return;
        }

        res.json(true);
    } catch (e) {
        console.error("[FlowPoseRouter] Delete error", e);
        res.status(500).json({ error: "Failed to delete flow pose" });
    }
});

export default flowPoseRouter;
