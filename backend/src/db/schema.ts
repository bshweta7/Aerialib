// specify schema for all tables 

import { integer, pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const usersTable = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name:text("name").notNull(),
    email:text("email").notNull().unique(),
    password:text("password").notNull(),
    createdAt:timestamp("created_at").defaultNow(),
    updatedAt:timestamp("updated_at").defaultNow(),
});

export type User = typeof usersTable.$inferSelect;
export type NewUser = typeof usersTable.$inferInsert;


// TODO posesTable should store primaryImageID as foreign key to media.
export const posesTable = pgTable("poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    // TODO alternative names
    description: text("description"),
    cues: text("cues"),
    apparatus: text("apparatus").notNull(),
    level: integer("level").notNull(),
    // TODO contraindications 
    createdBy: uuid("created_by").notNull().references(() => usersTable.id, {onDelete: "cascade"}),
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    primaryImageId: uuid("primary_image_id").notNull().references(() => mediaTable.id),

});


export type Pose = typeof posesTable.$inferSelect;
export type NewPose = typeof posesTable.$inferInsert;


export const mediaTable = pgTable("media", {
    id: uuid("id").primaryKey().defaultRandom(),
    mediaURL: text("media_url").notNull(),
    name: text("name"),
    description: text("description"),
    apparatus: text("apparatus"),
    uploadedBy: uuid("uploaded_by").notNull().references(() => usersTable.id, {onDelete: "cascade"}),
    uploadedAt: timestamp("uploaded_at").defaultNow(),

    // TODO delete metadata EXIF (security)
});


export type Media = typeof mediaTable.$inferSelect;
export type NewMedia = typeof mediaTable.$inferInsert;


