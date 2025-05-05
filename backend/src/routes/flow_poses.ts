import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewFlowPose, flowPosesTable } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";


// TODO THIS MIGHT NOT BE NECESSARY (MERGE INTO FLOW.TS)

const flowPoseRouter = Router();

flowPoseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        //create new flow in db 

        req.body = { ...req.body, uid: req.user }; 
        const NewFlowPose: NewFlowPose = req.body;
        console.log(NewFlowPose);

        const [flowPose] = await db.insert(flowPosesTable).values(NewFlowPose).returning();

        res.status(201).json(flowPose);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
})

flowPoseRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allFlowPoses = await db.select().from(flowPosesTable);
        // const allMedia = await db.select().from(mediaTable).where(eq(mediaTable.createdBy, req.user!));

        res.json(allFlowPoses); // TODO filter by permissions

    } catch (e) {
        res.status(500).json({ error: e })
    }
})


flowPoseRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { flowPoseId }: { flowPoseId: string } = req.body;
        await db.delete(flowPosesTable).where(eq(flowPosesTable.id, flowPoseId));

        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})


flowPoseRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        const flowPosesList = req.body;
        const filteredFlowPoses: NewFlowPose[] = [];

        flowPosesList.forEach((flowPose: { pose_id: any; }) => {
            console.log('[FlowPoseRouter] Received pose_id:', flowPose.pose_id);
        });

        for (let t of flowPosesList) {
            const cleaned = {
                id: t.id,
                flowId: t.flow_id,
                poseId: t.pose_id,
                poseOrder: t.pose_order,
                // TODO Add transition ID
                // created_by: t.created_by ?? req.user,
                // updated_by: req.user,
                // created_at: new Date(t.created_at),
                // updated_at: new Date(t.updated_at),
            };

            filteredFlowPoses.push(cleaned);
        }

        console.log("[FlowPoseRouter] Syncing", filteredFlowPoses.length, "flow poses");

        const pushedFlowPoses = await db
            .insert(flowPosesTable)
            .values(filteredFlowPoses)
            .onConflictDoNothing() // Prevent duplicate inserts on retry
            .returning();

        res.status(201).json(pushedFlowPoses);
    } catch (e) {
        console.error("[FlowPoseRouter] Sync error:", e);
        res.status(500).json({ error: e });
    }
});


// TODO Enable sync
// flowRouter.post("/sync", auth, async (req: AuthRequest, res) => {
//   try {
//     const flowPosesList = req.body;
//     const filteredFlowPoses: NewFlowPose[] = [];

//     for (let t of flowPosesList) {
//       t = {
//         ...t,
//         createdAt: new Date(t.createdAt),
//         updatedAt: new Date(t.updatedAt),
//         createdBy: req.user, // TODO Double check if this is right 
//       };
//       filteredFlowPoses.push(t);
//     }

//     const pushedFlowPoses = await db
//       .insert(flowPosesTable)
//       .values(flowPosesList)
//       .returning();

//     res.status(201).json(pushedFlowPoses);
//   } catch (e) {
//     console.log(e);
//     res.status(500).json({ error: e });
//   }
// });
  

// TODO enable update
// flowRouter.put("/update/:id", auth, async (req: AuthRequest, res) => {
//   try {
//     const poseId = req.params.id; // Get the pose ID from the URL
//     req.body = { ...req.body, uid: req.user };
//     const updatedPose: NewPose = req.body;
//     console.log("Updating Pose:", updatedPose);

//     const [pose] = await db
//       .update(posesTable)
//       .set(updatedPose) // Use set to update the values
//       .where(eq(posesTable.id, poseId)) // Use where to target the pose
//       .returning();

//     if (!pose) {
//         res.status(404).json({error: "Pose not found"});
//         return;
//     }

//     res.status(200).json(pose); // Change status to 200 (OK)

//   } catch (e) {
//     console.log(e);
//     res.status(500).json({ error: e });
//   }
// });


export default flowPoseRouter;
