// specify schema for all tables 

import { doublePrecision, integer, pgTable, primaryKey, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const usersTable = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

export type User = typeof usersTable.$inferSelect;
export type NewUser = typeof usersTable.$inferInsert;


export const posesTable = pgTable("poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    // TODO alternative names
    description: text("description"),
    cues: text("cues"),
    apparatus: text("apparatus").notNull(),
    level: integer("level").notNull(), // TODO update this to real or add difficulty field -> may need to modify filter in frontend
    // TODO contraindications 
    createdBy: uuid("created_by").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    primaryImageId: uuid("primary_image_id").notNull().references(() => mediaTable.id),

});


export type Pose = typeof posesTable.$inferSelect;
export type NewPose = typeof posesTable.$inferInsert;


export const mediaTable = pgTable("media", {
    id: uuid("id").primaryKey().defaultRandom(),
    mediaURL: text("media_url").notNull(), // TODO should this be mediaPath instead? 
    name: text("name"),
    description: text("description"),
    apparatus: text("apparatus"),
    uploadedBy: uuid("uploaded_by").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
    uploadedAt: timestamp("uploaded_at").defaultNow(),

    // TODO delete metadata EXIF (security)
});


export type Media = typeof mediaTable.$inferSelect;
export type NewMedia = typeof mediaTable.$inferInsert;


export const transitionsTable = pgTable("transitions", {
    id: uuid("id").primaryKey().defaultRandom(),

    fromPoseId: uuid("from_pose_id").notNull().references(() => posesTable.id),
    toPoseId: uuid("to_pose_id").notNull().references(() => posesTable.id),

    name: text("name"),
    description: text("description"),
    cues: text("cues"),
    difficulty: integer("difficulty"),
    duration: doublePrecision("duration"),

    primaryVideoId: uuid("primary_video_id").references(() => mediaTable.id),

    // TODO add types (separate regular transitions from rolls - rolls cant be in poses because they can have different start and end, and they take time)
    // TODO contraindications 

    // TODO is this needed
    // createdBy: uuid("created_by").notNull().references(() => usersTable.id, {onDelete: "cascade"}),
    // updatedBy: uuid("updated_by").references(() => usersTable.id),
    // createdAt: timestamp("created_at").defaultNow(),
    // updatedAt: timestamp("updated_at").defaultNow(),

});


export type Transition = typeof transitionsTable.$inferSelect;
export type NewTransition = typeof transitionsTable.$inferInsert;



export const flowsTable = pgTable("flows", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),

    description: text("description"),
    apparatus: text("apparatus"),// TODO should this be nullable? 

    createdBy: uuid("created_by").notNull().references(() => usersTable.id, { onDelete: "set default" }), // TODO Figure out what is set default
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),

    primaryImageId: uuid("primary_image_id").notNull().references(() => mediaTable.id), 
});

export type Flow = typeof flowsTable.$inferSelect;
export type NewFlow = typeof flowsTable.$inferInsert;

// TODO may need a "media Connector table" that converts pose uuid and flow uuid into a standard uuid that can be put into media? or add a column in media for flow id ? 

export const flowPosesTable = pgTable("flow_poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    flowId: uuid('flow_id')
        .notNull()
        .references(() => flowsTable.id, {
            onDelete: 'cascade',
            onUpdate: 'no action',
        }),
    poseId: uuid('pose_id')
        .notNull()
        .references(() => posesTable.id, {
            onDelete: 'cascade', // TODO check this - need better way of handling this  
            onUpdate: 'no action',
        }),
    order: integer('order').notNull(),
    transitionId: uuid('transition_id')
        .references(() => transitionsTable.id, {
            onDelete: 'cascade',
            onUpdate: 'no action',
        }),
},
    // TODO Can add which pose was added by which user (if sharing collections)
);


export type FlowPose = typeof flowPosesTable.$inferSelect;
export type NewFlowPose = typeof flowPosesTable.$inferInsert;





// TODO Collections - can store things like "favorites" or "Goals"
// 
// export const collectionsTable = pgTable("collections", {
//     id: uuid("id").primaryKey().defaultRandom(),
//     name: text("name").notNull(),

//     description: text("description"),
//     apparatus: text("apparatus"),

//     createdBy: uuid("created_by").notNull().references(() => usersTable.id, {onDelete: "cascade"}),
//     updatedBy: uuid("updated_by").references(() => usersTable.id),
//     createdAt: timestamp("created_at").defaultNow(),
//     updatedAt: timestamp("updated_at").defaultNow(),

//     primaryImageId: uuid("primary_image_id").notNull().references(() => mediaTable.id),
// });

// export type Collection = typeof collectionsTable.$inferSelect;
// export type NewCollection = typeof collectionsTable.$inferInsert;


// export const collectionPosesTable = pgTable("collection_poses", {
//     collectionId: uuid('collection_id')
//       .notNull()
//       .references(() => collectionsTable.id, {
//         onDelete: 'cascade',
//         onUpdate: 'no action',
//       }),
//     poseId: uuid('pose_id')
//       .notNull()
//       .references(() => posesTable.id, {
//         onDelete: 'cascade',
//         onUpdate: 'no action',
//       }),
//     // order: integer('order').notNull(),
//   },
//   // TODO Can add which pose was added by which user (if sharing collections)
//   (table) => {
//     return {
//       pk: primaryKey({ columns: [table.collectionId, table.poseId] }),
//     };
//   }
// );


// export type CollectionPose = typeof collectionPosesTable.$inferSelect;
// export type NewCollectionPose = typeof collectionPosesTable.$inferInsert;