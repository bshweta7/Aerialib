import express, { Router, Request, Response } from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import { auth, AuthRequest } from "../middleware/auth";
import { NewMedia, mediaTable } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

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

// Upload endpoint
mediaRouter.post("/upload", auth, upload.single("image"), async (req: Request, res: Response): Promise<void> => {
    const user = (req as AuthRequest).user;

    if (!req.file) {
        res.status(400).json({ error: "No file uploaded" });
        return;
    }

    const relativePath = `/data/uploads/${user}/${req.file.filename}`;
    console.log("Uploaded by user:", user);
    res.status(200).json({ path: relativePath });
});

mediaRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        req.body = { ...req.body, uid: req.user };
        const NewMedia: NewMedia = req.body;
        console.log(NewMedia);

        const [media] = await db.insert(mediaTable).values(NewMedia).returning();

        res.status(201).json(media);
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: e });
    }
});

mediaRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const allMedia = await db.select().from(mediaTable);
        res.json(allMedia);
    } catch (e) {
        res.status(500).json({ error: e });
    }
});

mediaRouter.delete("/", auth, async (req: AuthRequest, res) => {
    try {
        const { mediaID }: { mediaID: string } = req.body;
        await db.delete(mediaTable).where(eq(mediaTable.id, mediaID));
        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e });
    }
});

export default mediaRouter;
