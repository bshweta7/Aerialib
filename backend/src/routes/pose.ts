import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewPose, posesTable } from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";

const poseRouter = Router();

poseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
      // TODO make sure the pose doesn't exist already? 
        // TODO: check that the values were actually provided because it error if you dont
        //create new pose in db 
        req.body = { ...req.body, uid: req.user }; 
        const NewPose: NewPose = req.body;
        console.log(NewPose);

        const [pose] = await db.insert(posesTable).values(NewPose).returning();

        res.status(201).json(pose);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
})

poseRouter.get("/", auth, async (req: AuthRequest, res) => {
    
  try {
    const query = sql`
      SELECT 
        poses.*, 
        media.media_url AS primary_image_url
      FROM 
        poses
      JOIN 
        media ON poses.primary_image_id = media.id;
      `;

    // Execute the raw SQL query using db.execute()
    const result = await db.execute(query); 

    // Access the rows from the result
    const allPoses = result.rows; 

    res.json(allPoses);

    
    // const allPoses = await db.select().from(posesTable);
    // // const allPoses = await db.select().from(posesTable).where(eq(posesTable.createdBy, req.user!));

    // res.json(allPoses);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

poseRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { poseId }: { poseId: string } = req.body;
        await db.delete(posesTable).where(eq(posesTable.id, poseId));

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
        .insert(posesTable)
        .values(posesList)
        .returning();
  
      res.status(201).json(pushedPoses);
    } catch (e) {
      console.log(e);
      res.status(500).json({ error: e });
    }
  });
  
export default poseRouter;
