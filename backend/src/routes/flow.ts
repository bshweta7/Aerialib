import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewFlow, flowsTable } from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";

const flowRouter = Router();

flowRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        //create new flow in db 

        req.body = { ...req.body, uid: req.user }; 
        const NewFlow: NewFlow = req.body;
        console.log(NewFlow);

        const [flow] = await db.insert(flowsTable).values(NewFlow).returning();

        res.status(201).json(flow);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
})

flowRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allFlows = await db.select().from(flowsTable);
        // const allMedia = await db.select().from(mediaTable).where(eq(mediaTable.createdBy, req.user!));

        res.json(allFlows); // TODO filter by permissions

    } catch (e) {
        res.status(500).json({ error: e })
    }
})


flowRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { flowId }: { flowId: string } = req.body;
        await db.delete(flowsTable).where(eq(flowsTable.id, flowId));

        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

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


export default flowRouter;
