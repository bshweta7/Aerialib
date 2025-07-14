import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import {musicTable, NewMusic} from "../db/schema";
import { eq, sql } from "drizzle-orm";

const musicRouter = Router();

/// Create a new music entry
musicRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        const newMusic: NewMusic = {
            ...req.body,
            userId: req.user,
            createdAt: new Date(),
            updatedAt: new Date(),
        };

        const [created] = await db.insert(musicTable).values(newMusic).returning();
        res.status(201).json(created);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});

/// Get all music for the user (and admin)
musicRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const userId = req.user;

        const result = await db.execute(sql`
      SELECT * FROM music
      WHERE user_id = ${userId}
    `);

        res.json(result.rows);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});

/// Delete a music entry
musicRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { musicId }: { musicId: string } = req.body;
        await db.delete(musicTable).where(eq(musicTable.id, musicId)).returning();

        // TODO add check that it did delete
        // const result = await db.delete(musicTable).where(eq(musicTable.id, musicId)).returning();
        // if (result.length === 0) {
        //     return res.status(404).json({ error: "Music entry not found" });
        // }

        res.json({ success: true });
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});

/// Update music by ID
musicRouter.put("/update/:id", auth, async (req: AuthRequest, res) => {
    try {
        const id = req.params.id;

        const updated = await db
            .update(musicTable)
            .set({
                ...req.body,
                updatedAt: new Date(),
            })
            .where(eq(musicTable.id, id))
            .returning();

        // if (updated.length === 0) {
        //     return res.status(404).json({ error: "Music not found" });
        // }

        res.json(updated[0]);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});

export default musicRouter;

// TODO
// Sync music
// musicRouter.post("/sync", auth, async (req: AuthRequest, res: Response): Promise<void> => {
//     try {
//         const musicList = req.body;
//         const filteredMusic: NewMusic[] = [];
//
//         for (let t of musicList) {
//             const cleaned: NewMusic = {
//                 id: t.id,
//                 name: t.name,
//                 artist: t.artist,
//                 mood: t.mood,
//                 link: t.link,
//                 performanceNotes: t.performance_notes,
//                 tempoBpm: t.tempo_bpm,
//                 durationSec: t.duration_sec,
//                 favorite: t.favorite ?? 0,
//                 userId: t.user_id ?? req.user,
//                 createdAt: new Date(t.created_at),
//                 updatedAt: new Date(t.updated_at),
//             };
//
//             filteredMusic.push(cleaned);
//         }
//
//         console.log(`[musicRouter] Syncing ${filteredMusic.length} music entries`);
//         filteredMusic.forEach(m => console.log(m.name, m.link));
//
//         const pushedMusic = await db
//             .insert(musicTable)
//             .values(filteredMusic)
//             .onConflictDoNothing()
//             .returning();
//
//         res.status(201).json(pushedMusic);
//     } catch (e) {
//         console.error("[musicRouter] Sync error:", e);
//         res.status(500).json({ error: e });
//     }
// });
