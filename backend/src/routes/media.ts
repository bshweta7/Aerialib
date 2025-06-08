import express, { Router, Request, Response } from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import { auth, AuthRequest } from "../middleware/auth";
import {NewMedia, mediaTable} from "../db/schema";
import { db } from "../db";
import {eq, sql} from "drizzle-orm";

const mediaRouter = Router();

// Serve static files
const imagesDirectory = path.join(__dirname, "../../data");
console.log("Images directory:", imagesDirectory);
mediaRouter.use('/data', express.static(imagesDirectory));

// Multer storage setup with per-user subdirectories
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const user = (req as AuthRequest).user;

        if (!user || typeof user !== "string") {
            return cb(new Error("User not authenticated or invalid"), "");
        }

        const userDir = path.join(imagesDirectory, "uploads", user);
        fs.mkdirSync(userDir, { recursive: true });
        cb(null, userDir);
    },

    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({ storage });

// TODO upload
// TODO upload should also autogenerate thumbnail
// Upload endpoint
// mediaRouter.post(
//     "/upload",
//     auth,
//     upload.single("media"),
//     async (req: AuthRequest, res: Response) => {
//         const user = req.user;
//
//         if (!req.file) {
//             res.status(400).json({ error: "No file uploaded" });
//             return;
//         }
//
//         try {
//             const mediaPath = `uploads/${user}/${req.file.filename}`; // no "/data" prefix in DB
//             const now = new Date();
//
//             // Collect metadata from the frontend (FormData fields)
//             const {
//                 media_type,
//                 file_size,
//                 name,
//                 description,
//                 apparatus,
//                 origin,
//                 taken_time,
//                 taken_location,
//             } = req.body;
//
//             const newMedia = {
//                 mediaPath,
//                 mediaType: media_type,
//                 fileSize: parseInt(file_size), // ensure number
//                 name,
//                 description,
//                 apparatus,
//                 origin,
//                 takenTime: taken_time ? new Date(taken_time) : null,
//                 takenLocation: taken_location,
//                 createdBy: user,
//                 createdAt: now,
//                 updatedBy: user,
//                 updatedAt: now,
//             };
//
//             const [insertedMedia] = await db
//                 .insert(mediaTable)
//                 .values(newMedia)
//                 .returning();
//
//             res.status(201).json(insertedMedia);
//         } catch (e) {
//             console.error(e);
//             res.status(500).json({ error: "Failed to save media" });
//         }
//     }
// );
//
// mediaRouter.post("/", auth, async (req: AuthRequest, res) => {
//     try {
//         req.body = { ...req.body, uid: req.user };
//         const NewMedia: NewMedia = req.body;
//         console.log(NewMedia);
//
//         const [media] = await db.insert(mediaTable).values(NewMedia).returning();
//
//         res.status(201).json(media);
//     } catch (e) {
//         console.log(e);
//         res.status(500).json({ error: e });
//     }
// });

/// Get media from remote db
mediaRouter.get("/", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[MediaRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    try {
        const userId = req.user;
        const adminId = process.env.ADMIN_USER_ID;

        const query = sql`
            SELECT *
            FROM media
            WHERE media.created_by = ${userId}
               OR media.created_by = ${adminId}
            ORDER BY created_at DESC;
        `;

        // Execute the raw SQL query using db.execute()
        const result = await db.execute(query);

        // Access the rows from the result
        const allMedia = result.rows;

        res.json(allMedia);

    } catch (e) {
        console.log('[MediaRouter] Get -', e);
        res.status(500).json({ error: e })
    }
});

// TODO test this
mediaRouter.delete("/delete/:id", auth, async (req: AuthRequest, res) => {
    // Verify user
    if (!req.user) {
        console.log('[MediaRouter] Unauthorized user');
        res.status(401).json({ error: "Unauthorized" });
        return;
    }

    try {

        const mediaId = req.params.id;

        const [media] = await db
            .select()
            .from(mediaTable)
            .where(eq(mediaTable.id, mediaId));

        // Verify the media exists
        if (!media) {
            console.log('[MediaRouter] Delete attempt for media that does not exist');
            res.status(404).json({ error: "Media not found" });
            return;
        }

        // Verify the media belongs to the user
        if (media.createdBy !== req.user) {
            console.log('[MediaRouter] Delete attempt by user who does not own the media');
            res.status(403).json({ error: "Forbidden: You do not own this media" });
            return;
        }

        // Attempt deletion and return deleted rows
        const deleted = await db.delete(mediaTable)
            .where(eq(mediaTable.id, mediaId))
            .returning();

        if (deleted.length === 0) {
            console.log('[MediaRouter] Media was not found');
            res.status(404).json({ error: "Media not found" });
            return;
        }

        res.json(true);
    } catch (e) {
        console.log('[MediaRouter] Delete error', e);
        res.status(500).json({ error: e })
    }
})

mediaRouter.post("/sync", auth, async (req: AuthRequest, res) => {
    try {
        if (!req.user) {
            console.log("[MediaRouter] Unauthorized user");
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

        const userId = req.user;
        const mediaList = req.body;

        console.log(`[MediaRouter] Received ${mediaList.length} media items for sync.`);

        const normalized: NewMedia[] = mediaList.map((media: any) => ({
            ...media,
            // id: media.id,
            // mediaPath: media.media_path,
            // mediaType: media.media_type,
            // fileSize: media.file_size,
            // name: media.name,
            // description: media.description,
            // apparatus: media.apparatus,
            // origin: media.origin,
            // takenTime: media.taken_time ? new Date(media.taken_time) : undefined,
            // takenLocation: media.taken_location,
            createdBy: media.createdBy ?? userId,
            updatedBy: userId,
            createdAt: new Date(media.created_at),
            updatedAt: new Date(media.updated_at),
        }));

        const pushedMedia = await db
            .insert(mediaTable)
            .values(normalized)
            .onConflictDoUpdate({
                target: mediaTable.id,
                set: buildMediaUpsertSet(),
            })
            .returning();

        console.log(`[MediaRouter] ${pushedMedia.length} media inserted or updated.`);

        res.status(201).json(pushedMedia);
    } catch (e) {
        console.error("[MediaRouter] Sync -", e);
        res.status(500).json({ error: "Failed to sync media" });
    }
});

function buildMediaUpsertSet() {
    return {
        mediaPath: sql`excluded.media_path`,
        hasThumbnail: sql`excluded.has_thumbnail`,
        mediaType: sql`excluded.media_type`,
        fileSize: sql`excluded.file_size`,
        durationSeconds: sql`excluded.duration_seconds`,
        name: sql`excluded.name`,
        description: sql`excluded.description`,
        apparatus: sql`excluded.apparatus`,
        origin: sql`excluded.origin`,
        takenTime: sql`excluded.taken_time`,
        takenLocation: sql`excluded.taken_location`,
        updatedBy: sql`excluded.updated_by`,
        updatedAt: sql`excluded.updated_at`,
    };
}

export default mediaRouter;
