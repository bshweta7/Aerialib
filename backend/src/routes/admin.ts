// src/routes/transitions.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { usersTable, flowsTable, flowPosesTable } from "../db/schema";
import { eq, sql } from "drizzle-orm";

const adminRouter = Router();

/// Get all user info and flows
adminRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user is admin user
        if (req.user !== process.env.ADMIN_USER_ID) {
            console.log('[TransitionRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }
        // TODO add "user_roles" and make a function in auth.ts that verifies if user is admin, instead of verifying against the one known admin

        // Get all users
        const allUsers = await db.select().from(usersTable);

        const usersFormatted = allUsers.map((user) => ({
            id: user.id,
            username: user.username,
            email: user.email,
            first_name: user.firstName,
            last_name: user.lastName,
            last_logged_in: user.lastLogin,
        }));

        // Get all flows with pose count
        const query = sql`
            SELECT
                flows.id,
                flows.name,
                flows.created_by,
                COUNT(flow_poses.id) AS num_poses
            FROM flows
            LEFT JOIN flow_poses
                AS flow_poses
                ON flows.id = flow_poses.flow_id
            GROUP BY flows.id
        `;

        const allFlows = await db.execute(query);

        const flowsFormatted = allFlows.rows.map((flow: any) => ({
            id: flow.id,
            name: flow.name,
            created_by: flow.created_by,
            num_poses: Number(flow.num_poses),
        }));

        res.send({
            users: usersFormatted,
            flows: flowsFormatted,
        });

    } catch (e) {
        console.error("[TransitionRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});

export default adminRouter;