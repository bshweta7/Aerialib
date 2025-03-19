import express, { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewMedia, mediaTable } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";
import path from "path";

const mediaRouter = Router();

// Serve static files related to poses from a 'pose-images' directory
const imagesDirectory = path.join(__dirname, "../../data"); 
console.log("Images directory:", imagesDirectory);

mediaRouter.use('/data', express.static(imagesDirectory));

mediaRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        // TODO: check that the values were actually provided because it error if you dont
        //creates new media in db 
        req.body = { ...req.body, uid: req.user };
        
        // TODO try const NewMedia, catch if format doesnt match return 400 class error
        const NewMedia: NewMedia = req.body;
        console.log(NewMedia);

        const [media] = await db.insert(mediaTable).values(NewMedia).returning();

        res.status(201).json(media);

        // TODO generate Thumbnail 
        // TODO update the poses db with thumbnail URL

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
})

mediaRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allMedia = await db.select().from(mediaTable);
        // const allMedia = await db.select().from(mediaTable).where(eq(mediaTable.createdBy, req.user!));

        res.json(allMedia); // TODO filter by permissions

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

mediaRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { mediaID }: { mediaID: string } = req.body;
        await db.delete(mediaTable).where(eq(mediaTable.id, mediaID));

        res.json(true);

    } catch (e) {
        res.status(500).json({ error: e })
    }
})

// mediaRouter.post("/sync", auth, async (req: AuthRequest, res) => {
//     try {
//       const mediaList = req.body;
//       const filteredMedia: NewMedia[] = [];
  
//       for (let t of mediaList) {
//         t = {
//           ...t,
//           createdAt: new Date(t.createdAt),
//           updatedAt: new Date(t.updatedAt),
//           createdBy: req.user, // TODO Double check if this is right 
//         };
//         filteredMedia.push(t);
//       }
  
//       const pushedMedia = await db
//         .insert(mediaTable)
//         .values(mediaList)
//         .returning();
  
//       res.status(201).json(pushedMedia);
//     } catch (e) {
//       console.log(e);
//       res.status(500).json({ error: e });
//     }
//   });
  
export default mediaRouter;
