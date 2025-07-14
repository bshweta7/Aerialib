import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import {
    tagsTable,
    poseTagsTable,
    flowTagsTable,
    NewTag,
    NewPoseTag,
    NewFlowTag,
} from "../db/schema";
import { eq, and, sql } from "drizzle-orm";

const tagRouter = Router();

// ------------------------------
// Create a new tag
tagRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        const newTag: NewTag = {
            ...req.body,
            userId: req.user,
            createdAt: new Date(),
            updatedAt: new Date(),
        };

        const [created] = await db.insert(tagsTable).values(newTag).returning();
        res.status(201).json(created);
    } catch (e) {
        console.error("[tagRouter] Create error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Get all tags for the user (and admin)
tagRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const userId = req.user;
        const adminId = process.env.ADMIN_USER_ID;

        const result = await db.execute(sql`
      SELECT * FROM tags
      WHERE user_id = ${userId}
         OR user_id = ${adminId}
    `);

        res.json(result.rows);
    } catch (e) {
        console.error("[tagRouter] Get error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Delete a tag
tagRouter.delete("/:id", auth, async (req: AuthRequest, res) => {
    try {
        const { tagId }: { tagId: string } = req.body;
        await db.delete(tagsTable).where(eq(tagsTable.id, tagId)).returning();
        res.json({ success: true });
    } catch (e) {
        console.error("[tagRouter] Delete error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Update a tag
tagRouter.put("/update/:id", auth, async (req: AuthRequest, res) => {
    try {
        const id = req.params.id;

        const updated = await db
            .update(tagsTable)
            .set({
                ...req.body,
                updatedAt: new Date(),
            })
            .where(eq(tagsTable.id, id))
            .returning();

        res.json(updated[0]);
    } catch (e) {
        console.error("[tagRouter] Update error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Assign tag to pose
// TODO move to pose route?
tagRouter.post("/pose", auth, async (req: AuthRequest, res) => {
    try {
        const { poseId, tagId }: { poseId: string; tagId: string } = req.body;

        const newTagLink: NewPoseTag = {
            poseId,
            tagId,
            userId: req.user!,
        };

        const [created] = await db.insert(poseTagsTable).values(newTagLink).returning();
        res.status(201).json(created);
    } catch (e) {
        console.error("[tagRouter] Assign tag to pose error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Remove tag from pose
// TODO move to pose route?
tagRouter.delete("/pose", auth, async (req: AuthRequest, res) => {
    try {
        const { poseId, tagId }: { poseId: string; tagId: string } = req.body;

        const deleted = await db.execute(sql`
          DELETE FROM pose_tags
          WHERE pose_id = ${poseId}
            AND tag_id = ${tagId}
            AND user_id = ${req.user}
          RETURNING *
        `);

        res.json({ success: true, deleted });
    } catch (e) {
        console.error("[tagRouter] Remove tag from pose error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Assign tag to flow
// TODO move to flow route?
tagRouter.post("/flow", auth, async (req: AuthRequest, res) => {
    try {
        const { flowId, tagId }: { flowId: string; tagId: string } = req.body;

        const newTagLink: NewFlowTag = {
            flowId,
            tagId,
            userId: req.user!,
        };

        const [created] = await db.insert(flowTagsTable).values(newTagLink).returning();
        res.status(201).json(created);
    } catch (e) {
        console.error("[tagRouter] Assign tag to flow error:", e);
        res.status(500).json({ error: e });
    }
});

// ------------------------------
// Remove tag from flow
// TODO move to flow route?
tagRouter.delete("/flow", auth, async (req: AuthRequest, res) => {
    try {
        const { flowId, tagId }: { flowId: string; tagId: string } = req.body;

        const deleted = await db.execute(sql`
          DELETE FROM flow_tags
          WHERE flow_id = ${flowId}
            AND tag_id = ${tagId}
            AND user_id = ${req.user}
          RETURNING *
        `);

        res.json({ success: true, deleted });
    } catch (e) {
        console.error("[tagRouter] Remove tag from flow error:", e);
        res.status(500).json({ error: e });
    }
});

export default tagRouter;
