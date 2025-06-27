// src/routes/transitions.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { usersTable, flowsTable, flowPosesTable } from "../db/schema";
import { eq, sql } from "drizzle-orm";

const adminRouter = Router();

/// Get user info
adminRouter.get("/users", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user is admin user
        if (req.user !== process.env.ADMIN_USER_ID) {
            console.log('[AdminRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }
        // TODO add "user_roles" and make a function in auth.ts that verifies if user is admin, instead of verifying against the one known admin

        // Get all users
        const allUsers = await db.select().from(usersTable);

        const usersFormatted = allUsers.map((user) => ({
            token: "",
            id: user.id,
            username: user.username,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            bio: user.bio,
        }));

        res.json(usersFormatted);

    } catch (e) {
        console.error("[AdminRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});



/// Get all flows
adminRouter.get("/flows", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user is admin user
        if (req.user !== process.env.ADMIN_USER_ID) {
            console.log('[AdminRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }
        // TODO add "user_roles" and make a function in auth.ts that verifies if user is admin, instead of verifying against the one known admin

        // Get all flows with pose count
        const query = sql`
            SELECT
                flows.id,
                flows.name,
                users.username AS created_by_username,
                flows.apparatus,
                flows.created_at,
                flows.updated_at,
                COUNT(flow_poses.id) AS num_poses
            FROM flows
                     LEFT JOIN flow_poses ON flows.id = flow_poses.flow_id
                     LEFT JOIN users ON flows.created_by = users.id
            GROUP BY
                flows.id,
                flows.name,
                users.username,
                flows.apparatus,
                flows.created_at,
                flows.updated_at
        `;

        const allFlows = await db.execute(query);

        const flowsFormatted = allFlows.rows.map((flow: any) => ({
            id: flow.id,
            name: flow.name,
            created_by: flow.created_by_username,  // updated key
            apparatus: flow.apparatus,
            created_at: flow.created_at,
            updated_at: flow.updated_at,
            num_poses: Number(flow.num_poses),
        }));

        res.json(flowsFormatted);

    } catch (e) {
        console.error("[AdminRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});

export default adminRouter;