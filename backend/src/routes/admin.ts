// src/routes/admin.ts

import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import {usersTable, flowsTable, flowPosesTable, userRolesTable, posesTable, NewPose, NewUserRole} from "../db/schema";
import {and, eq, sql} from "drizzle-orm";
import {getUserRoles, hasRole, isInstructorOrAdmin, isRootAdmin, isAuthorizedAddNewUserRole} from "../utils/rbac";
import poseRouter from "./pose";

const adminRouter = Router();

// TODO remove this and replace with just roster (below)
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

/// Get all users' info
adminRouter.get("/studentRoster", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user is staff (admin or instructor)
        const isStaff = await isInstructorOrAdmin(req.user!);
        if (!isStaff && req.user !== process.env.ADMIN_USER_ID) { // TODO update this to check if user's roles contain root, admin, instructor
            res.status(403).json({ error: "Unauthorized" });
            return
        }

        // Step 1: Get studio_id of requesting user
        const requesterRoles = await db
            .select({
                studioId: userRolesTable.studioId,
            })
            .from(userRolesTable)
            .where(eq(userRolesTable.userId, req.user!));

        if (!requesterRoles.length || !requesterRoles[0].studioId) {
            res.status(400).json({ error: "Requesting user has no studio assigned" });
            return;
        }

        const studioId = requesterRoles[0].studioId;

        // Step 2: Join and filter by studio + student role
        const usersWithRoles = await db
            .select({
                id: usersTable.id,
                username: usersTable.username,
                email: usersTable.email,
                firstName: usersTable.firstName,
                lastName: usersTable.lastName,
                bio: usersTable.bio,
                role: userRolesTable.role,
                apparatus: userRolesTable.apparatus,
                level: userRolesTable.level,
            })
            .from(usersTable)
            .leftJoin(
                userRolesTable,
                eq(usersTable.id, userRolesTable.userId)
            )
            .where(
                and(
                    eq(userRolesTable.studioId, studioId),
                    eq(userRolesTable.role, "student")
                )
            );

        const usersFormatted = usersWithRoles.map((entry) => ({
            token: "",
            id: entry.id,
            username: entry.username,
            email: entry.email,
            firstName: entry.firstName,
            lastName: entry.lastName,
            bio: entry.bio,
            role: entry.role,
            apparatus: entry.apparatus,
            level: entry.level,
        }));

        res.json(usersFormatted);
    } catch (e) {
        console.error("[AdminRouter] Get error", e);
        res.status(500).json({ error: e });
    }
});


// TODO remove this after the "share status" is implemented for flows
/// Get all users' flows
adminRouter.get("/flows", auth, async (req: AuthRequest, res) => {
    try {
        // Verify user is admin user
        if (req.user !== process.env.ADMIN_USER_ID) {
            console.log('[AdminRouter] Unauthorized user');
            res.status(401).json({ error: "Unauthorized" });
            return;
        }

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


/// Add new user role
adminRouter.post("/userRole", auth, async (req: AuthRequest, res) => {
    try {
        // // TODO apparatus and level are nullable
        // if (!userId || !role || !apparatus || !level) {
        //     res.status(400).json({ error: "Missing required fields" });
        //     return;
        // }

        // TODO add function to validate the role
        // Validate role
        // if (!process.env.VALID_USER_ROLES.includes(role)) {
        //     res.status(400).json({ error: "Invalid role" });
        //     return;
        // }

        const isAuthorized = isAuthorizedAddNewUserRole(req.user!, req.body.role);

        if (!isAuthorized) {
            res.status(403).json({ error: "Unauthorized" });
            return;
        }

        const newUserRole: NewUserRole = {
            ...req.body,
            createdAt: new Date(req.body.createdAt),
            updatedAt: new Date(req.body.updatedAt),
        };
        console.log(newUserRole);

        const [userRole] = await db.insert(userRolesTable).values(newUserRole).returning();

        // Verify userRole was added
        if (userRole) {
            res.status(201).json(userRole);
        } else {
            res.status(500).json({ error: "User role was not created" });
        }

    } catch (e) {
        console.error("[AdminRouter] Add user role error", e);
        res.status(500).json({ error: e });
    }
});

export default adminRouter;