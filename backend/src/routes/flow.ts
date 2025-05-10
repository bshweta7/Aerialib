// flow.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";

import { NewFlow, flowsTable, flowPosesTable, posesTable, mediaTable } from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";

const flowRouter = Router();

flowRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        const t = req.body;

        const newFlow: NewFlow = {
            name: t.name,
            thumbnailImageId: t.thumbnail_image_id,
            apparatus: t.apparatus,
            level: t.level,
            description: t.description,
            teachingCues: t.teaching_cues,
            safetyCues: t.safety_cues,
            progressions: t.progressions,
            createdBy: t.created_by ?? req.user, // fallback to authenticated user
            updatedBy: req.user,
            createdAt: new Date(),
            updatedAt: new Date(),
        };

        console.log("[FlowRouter] Inserting new flow:", newFlow);

        const [flow] = await db.insert(flowsTable).values(newFlow).returning();

        res.status(201).json(flow);
    } catch (e) {
        console.error("[FlowRouter] Error inserting flow:", e);
        res.status(500).json({ error: e });
    }
});


flowRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const query = sql`
            SELECT
                flows.*,
                media.media_path AS thumbnail_image_path
            FROM
                flows
                    JOIN
                media ON flows.thumbnail_image_id = media.id
            WHERE
                flows.created_by = ${req.user};
        `;

      // Execute the raw SQL query using db.execute()
      const result = await db.execute(query);

      // Access the rows from the result
      const allFlows = result.rows;

      res.json(allFlows);

    } catch (e) {
        console.error("[FlowRouter] Error getting flows:", e);
        res.status(500).json({ error: e });
    }
});

flowRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { flowId }: { flowId: string } = req.body;
        await db.delete(flowsTable).where(eq(flowsTable.id, flowId));

        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e })
    }
});

// TODO enable sync
// flowRouter.post("/sync", auth, async (req: AuthRequest, res) => {
//   try {
//     const flowsList = req.body;
//     const filteredFlows: NewFlow[] = [];

//     for (let t of flowsList) {
//       t = {
//         ...t,
//         createdAt: new Date(t.createdAt),
//         updatedAt: new Date(t.updatedAt),
//         createdBy: req.user, // TODO Double check if this is right
//       };
//       filteredFlows.push(t);
//     }

//     const pushedFlows = await db
//       .insert(flowsTable)
//       .values(flowsList)
//       .returning();

//     res.status(201).json(pushedFlows);
//   } catch (e) {
//     console.log(e);
//     res.status(500).json({ error: e });
//   }
// });
flowRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        const flowsList = req.body;
        const filteredFlows: NewFlow[] = [];

        flowsList.forEach((flow: { thumbnail_image_id: any; }) => {
            console.log('[FlowRouter] Received thumbnail_image_id:', flow.thumbnail_image_id);
        });

        console.log(req.body);

        // Clean and transform incoming flow objects
        for (let t of flowsList) {
            t = {
                id: t.id,
                name: t.name,
                thumbnailImageId: t.thumbnail_image_id,
                apparatus: t.apparatus,
                level: t.level,
                description: t.description,
                teachingCues: t.teaching_cues,
                safetyCues: t.safety_cues,
                progressions: t.progressions,
                createdBy: t.created_by, // TODO check
                updatedBy: req.user,
                createdAt: new Date(t.created_at),
                updatedAt: new Date(t.updated_at),
            };

            filteredFlows.push(t);
        }

        // Debug logs (optional)
        filteredFlows.forEach((flow, i) => {
            console.log(`[FlowRouter] Flow ${i + 1}:`, flow);
        });

        const pushedFlows = await db
            .insert(flowsTable)
            .values(filteredFlows)
            .onConflictDoNothing() // Optional: handle duplicates
            .returning();

        res.status(201).json(pushedFlows);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});



flowRouter.put("/update/:id", auth, async (req: AuthRequest, res) => {
    try {
        const flowId = req.params.id; // Get the flow ID from the URL
        req.body = { ...req.body, uid: req.user };

        const updatedFlow: NewFlow = {
            name: req.body.name,
            thumbnailImageId: req.body.thumbnailImageId ?? req.body.thumbnail_image_id,
            apparatus: req.body.apparatus,
            level: req.body.level,
            description: req.body.description,
            teachingCues: req.body.teachingCues ?? req.body.teaching_cues,
            safetyCues: req.body.safetyCues ?? req.body.safety_cues,
            progressions: req.body.progressions,
            updatedBy: req.user,
            updatedAt: new Date(),
            createdBy: req.body.createdBy ?? req.body.created_by,
            createdAt: new Date(req.body.createdAt ?? req.body.created_at),
        };



        console.log("Updating Flow:", updatedFlow);

        const [flow] = await db
            .update(flowsTable)
            .set(updatedFlow)
            .where(eq(flowsTable.id, flowId))
            .returning();

        if (!flow) {
            res.status(404).json({ error: "Flow not found" });
            return;
        }

        res.status(200).json(flow);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});



export default flowRouter;
