// src/routes/users.ts
/// Managing a specific user's data (especially the current user), and limited access to other users based on roles

import {auth, AuthRequest} from "../middleware/auth";
import { eq } from "drizzle-orm";
import { Router } from "express";
import { usersTable } from "../db/schema";
import { db } from "../db";
import { isInstructorOrAdmin } from "../utils/rbac";

const userRouter = Router();

// TODO may be able to remove this altogether
/// Get current user's information
userRouter.get("/me", auth, async (req: AuthRequest, res) => {
    if (!req.user) {
        res.status(401).json({ error: "User not found." });
        return;
    }

    const [user] = await db.select().from(usersTable).where(eq(usersTable.id, req.user));

    if (!user) {
        res.status(404).json({ error: "User not found." });
        return;
    }

    res.json({ ...user, token: req.token });
});

/// Get user info by user ID
userRouter.get("/:id", auth, async (req: AuthRequest, res) => {
    const { id } = req.params;

    // Allow if the user is viewing their own profile
    const isSelf = req.user === id;

    // Allow if the user is admin or instructor
    const isStaff = await isInstructorOrAdmin(req.user!);

    if (!isSelf && !isStaff) {
        res.status(403).json({ error: "Unauthorized to view this profile." });
        return;
    }

    const [user] = await db.select().from(usersTable).where(eq(usersTable.id, id));

    if (!user) {
        res.status(404).json({ error: "User not found." });
        return;
    }

    res.json(user);
});

export default userRouter;

