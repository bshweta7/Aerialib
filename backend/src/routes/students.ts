import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { sql } from "drizzle-orm";

const studentRouter = Router();

/// Get all student for the user (and admin)
studentRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        const result = await db.execute(sql`SELECT * FROM student`);
        res.json(result.rows);
    } catch (e) {
        console.error(e);
        res.status(500).json({ error: e });
    }
});

// TODO make a "base router" for multiple tables?