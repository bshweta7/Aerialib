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
    name: text("name").notNull(),
    // TODO alternative names
    description: text("description"),
    cues: text("cues"),
    apparatus: text("apparatus").notNull(),
    level: integer("level").notNull(),
    // TODO contraindications
    // TODO image info    
    createdBy: uuid("created_by").notNull().references(() => users.id, {onDelete: "cascade"}),
    updatedBy: uuid("updated_by").references(() => users.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    // isSynced: integer("is_synced").notNull()




});


export type Pose = typeof poses.$inferSelect;
export type NewPose = typeof poses.$inferInsert;
