// specify schema for all tables 

import { integer, pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name:text("name").notNull(),
    email:text("email").notNull().unique(),
    password:text("password").notNull(),
    createdAt:timestamp("created_at").defaultNow(),
    updatedAt:timestamp("updated_at").defaultNow(),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;


export const poses = pgTable("poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    title: text("title").notNull(),
    description: text("description").notNull(),
    color: text("color").notNull(),
    uid: uuid("uid").notNull().references(() => users.id, {onDelete: "cascade"}),
    dueAt: timestamp("due_at").$defaultFn(() => new Date(Date.now() + 7*24*60*60*1000)),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    // isSynced: integer("is_synced").notNull()
});


export type Pose = typeof poses.$inferSelect;
export type NewPose = typeof poses.$inferInsert;
