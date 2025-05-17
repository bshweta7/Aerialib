import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import {mediaTable, NewFlow, NewPose, posesTable} from "../db/schema";
import { db } from "../db";
import { eq, sql } from "drizzle-orm";
import mediaRouter from "./media";

const poseRouter = Router();

poseRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
      // TODO make sure the pose doesn't exist already?
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

    const currentUserId = req.user;
    // console.log('[PoseRouter] Current user:', currentUserId);
    const adminId = process.env.ADMIN_USER_ID;

      // TODO use drizzle ORM instead of sql query
    const query = sql`
      SELECT 
        poses.*, 
        media.media_path AS primary_media_path
      FROM poses
      JOIN media ON poses.primary_media_id = media.id
      WHERE poses.created_by = ${currentUserId}
         OR poses.created_by = ${adminId};
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
      // TODO
      // for (let t of posesList) {
      //     // 👇 Strip frontend camelCase keys and normalize
      //     const cleaned = {
      //         id: t.id,
      //         name: t.name,
      //         primary_media_id: t.primary_media_id,
      //         apparatus: t.apparatus,
      //         level: t.level,
      //         description: t.description,
      //         teaching_cues: t.teaching_cues,
      //         safety_cues: t.safety_cues,
      //         progressions: t.progressions,
      //         created_by: t.created_by ?? req.user,
      //         updated_by: t.updated_by ?? req.user,
      //         created_at: new Date(t.created_at),
      //         updated_at: new Date(t.updated_at),
      //     };
      //
      //     filteredPoses.push(cleaned);
      // }

      posesList.forEach((pose: { primary_media_id: any; }) => {
          console.log('[PoseRouter] Received primary_media_id:', pose.primary_media_id);
      });

      console.log(req.body);

      for (let t of posesList) {
      t = {
        // ...t,
        id: t.id,
        name: t.name,
        primaryMediaId: t.primary_media_id,
        apparatus: t.apparatus,
        level: t.level,
        description: t.description,
        teachingCues: t.teaching_cues,
        safetyCues: t.safety_cues,
        progressions: t.progressions,
        createdBy: t.created_by,
        updatedBy: req.user,
        createdAt: new Date(t.created_at),
        updatedAt: new Date(t.updated_at),
      };
      filteredPoses.push(t);
    }

      filteredPoses.forEach(pose => {
          console.log('[PoseRouter] Received primary_media_id (AFTER FILTERING):', pose.primaryMediaId);
      });

    console.log('[PoseRouter] Inserting poses with keys:');
    filteredPoses.forEach(p => console.log(Object.keys(p)));
    filteredPoses.forEach(p => console.log(Object.values(p)));

    const pushedPoses = await db
      .insert(posesTable)
      .values(filteredPoses)
      .onConflictDoNothing() // TODO verify if this can works
      .returning();

    res.status(201).json(pushedPoses);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});
  

poseRouter.put("/update/:id", auth, async (req: AuthRequest, res) => {
  try {
    const poseId = req.params.id; // Get the pose ID from the URL
    req.body = { ...req.body, uid: req.user };

    const updatedPose: NewPose = {
      name: req.body.name,
      primaryMediaId: req.body.primaryMediaId ?? req.body.primary_media_id,
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

    console.log("Updating Pose:", updatedPose);

    const [pose] = await db
      .update(posesTable)
      .set(updatedPose) // Use set to update the values
      .where(eq(posesTable.id, poseId)) // Use where to target the pose
      .returning();

    if (!pose) {
        res.status(404).json({error: "Pose not found"});
        return;
    }

    res.status(200).json(pose); // Change status to 200 (OK)

  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});


export default poseRouter;
