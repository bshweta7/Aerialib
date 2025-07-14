// src/utils/rbac.ts
import { db } from "../db";
import { userRolesTable } from "../db/schema";
import { eq } from "drizzle-orm";

/// Get all role names for a user
export async function getUserRoles(userId: string): Promise<string[]> {
    const roles = await db
        .select({ role: userRolesTable.role })
        .from(userRolesTable)
        .where(eq(userRolesTable.userId, userId));

    return roles.map(r => r.role);
}

/// Is the root admin (e.g. Shweta)
export function isRootAdmin(userId: string): boolean {
    return userId === process.env.ADMIN_USER_ID;
}

/// Helper: does user have a specific role
export async function hasRole(userId: string, role: string): Promise<boolean> {
    const roles = await getUserRoles(userId);
    return roles.includes(role);
}

// TODO replace this with getUserRoles
export async function isInstructorOrAdmin(userId: string): Promise<boolean> {
    const roles = await db
        .select()
        .from(userRolesTable)
        .where(eq(userRolesTable.userId, userId));

    return roles.some(role =>
        role.role === "admin" || role.role === "instructor"
    );
}

export async function isAuthorizedAddNewUserRole(userId: string, role: string): Promise<boolean> {
    // TODO may need to add another table that defines each user_role and the permissions for each role

    const currentUserRoles = await getUserRoles(userId);
    const isRoot = isRootAdmin(userId);

    if (isRoot) {
        return ["admin", "instructor", "student"].includes(role);
    }

    if (currentUserRoles.includes("admin")) {
        return ["instructor", "student"].includes(role);
    }

    if (currentUserRoles.includes("instructor")) {
        return ["student"].includes(role);
    }

    return false;
}
