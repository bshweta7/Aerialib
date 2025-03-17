import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewPose, poses } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const poseRouter = Router();

poseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // TODO: check that the values were actually provided because it error if you dont
        //create new pose in db 
        req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
        const NewPose: NewPose = req.body;

        const [pose] = await db.insert(poses).values(NewPose).returning();

        res.status(201).json(pose);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
})

poseRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allPoses = await db.select().from(poses);
        // const allPoses = await db.select().from(poses).where(eq(poses.createdBy, req.user!));

        res.json(allPoses);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

poseRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { poseId }: { poseId: string } = req.body;
        await db.delete(poses).where(eq(poses.id, poseId));

        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

poseRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
      const posesList = req.body;
      const filteredPoses: NewPose[] = [];
  
      for (let t of posesList) {
        t = {
          ...t,
          createdAt: new Date(t.createdAt),
          updatedAt: new Date(t.updatedAt),
          createdBy: req.user, // TODO Double check if this is right 
        };
        filteredPoses.push(t);
      }
  
      const pushedPoses = await db
        .insert(poses)
        .values(posesList)
        .returning();
  
      res.status(201).json(pushedPoses);
    } catch (e) {
      console.log(e);
      res.status(500).json({ error: e });
    }
  });
  
export default poseRouter;
