// specify schema for all tables 

import {doublePrecision, integer, jsonb, pgTable, text, timestamp, uuid} from "drizzle-orm/pg-core";


/* USERS */
export const usersTable = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),

    username: text("username").notNull().unique(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),

    firstName: text("first_name"),
    lastName: text("last_name"),
    bio: text("bio"),

    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    lastLogin: timestamp("last_login").defaultNow(),
});

export type User = typeof usersTable.$inferSelect;
export type NewUser = typeof usersTable.$inferInsert;


/* MEDIA */
export const mediaTable = pgTable("media", {
    id: uuid("id").primaryKey().defaultRandom(),
    mediaPath: text("media_path").notNull(),

    mediaType: text("media_type").notNull(),
    fileSize: integer("file_size"),

    name: text("name"),
    description: text("description"),
    apparatus: text("apparatus"),

    uploadedBy: uuid("uploaded_by").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
    uploadedAt: timestamp("uploaded_at").defaultNow(),

    // TODO delete metadata EXIF (security)
});


export type Media = typeof mediaTable.$inferSelect;
export type NewMedia = typeof mediaTable.$inferInsert;


/* POSES */
export const posesTable = pgTable("poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    primaryMediaId: uuid("primary_media_id").notNull().references(() => mediaTable.id),
    apparatus: text("apparatus").notNull(),
    level: doublePrecision("level").notNull(),

    description: text("description"),
    teachingCues: text("teaching_cues"),
    safetyCues: text("safety_cues"),
    progressions: text("progressions"),

    createdBy: uuid("created_by").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

export type Pose = typeof posesTable.$inferSelect;
export type NewPose = typeof posesTable.$inferInsert;


/* TRANSITIONS */
export const transitionsTable = pgTable("transitions", {
    id: uuid("id").primaryKey().defaultRandom(),

    fromPoseId: uuid("from_pose_id").notNull().references(() => posesTable.id),
    toPoseId: uuid("to_pose_id").notNull().references(() => posesTable.id),
    level: doublePrecision("level").notNull(),

    name: text("name"),
    description: text("description"),
    teachingCues: text("teaching_cues"),
    safetyCues: text("safety_cues"),
    progressions: text("progressions"),

    transitionType: text("transition_type"),
    startingGrip: text("starting_grip"),
    endingGrip: text("ending_grip"),

    createdBy: uuid("created_by").notNull().references(() => usersTable.id, { onDelete: "cascade" }),
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

export type Transition = typeof transitionsTable.$inferSelect;
export type NewTransition = typeof transitionsTable.$inferInsert;


/* FLOWS */
export const flowsTable = pgTable("flows", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(), // NOTE: Give suggestions in frontend (like April Flow) or default to date created
    thumbnailImageId: uuid("thumbnail_image_id").notNull().references(() => mediaTable.id),
    apparatus: text("apparatus").notNull(), // NOTE: this can be interpreted from poses contained within it, don't need to ask the user to enter it
    level: doublePrecision("level").notNull(),

    description: text("description"),
    teachingCues: text("teaching_cues"),
    safetyCues: text("safety_cues"),
    progressions: text("progressions"),

    createdBy: uuid("created_by").notNull().references(() => usersTable.id, { onDelete: "set default" }), // TODO Figure out what is set default
    updatedBy: uuid("updated_by").references(() => usersTable.id),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

export type Flow = typeof flowsTable.$inferSelect;
export type NewFlow = typeof flowsTable.$inferInsert;


/* FLOW POSES CONNECTOR */
export const flowPosesTable = pgTable("flow_poses", {
    id: uuid("id").primaryKey().defaultRandom(),
    flowId: uuid('flow_id').notNull().references(() => flowsTable.id, {
        onDelete: 'cascade',
        onUpdate: 'no action',
    }),
    poseId: uuid('pose_id').notNull().references(() => posesTable.id, {
        onDelete: 'cascade', // TODO check this - need better way of handling this
        onUpdate: 'no action',
    }),
    poseOrder: integer('pose_order').notNull(),
    transitionId: uuid('transition_id').references(() => transitionsTable.id, {
        onDelete: 'cascade',
        onUpdate: 'no action',
    }),
});


export type FlowPose = typeof flowPosesTable.$inferSelect;
export type NewFlowPose = typeof flowPosesTable.$inferInsert;


/* FEEDBACK */
export const feedbackTable = pgTable("feedback", {
    id: uuid("id").primaryKey().defaultRandom(),

    type: text("type").notNull(), // e.g., 'bug', 'feature', 'other'
    message: text("message").notNull(),
    email: text("email"), // Optional contact

    userId: uuid("user_id").references(() => usersTable.id, {
        onDelete: "set null",
    }),

    createdAt: timestamp("created_at").defaultNow(),
});

export type Feedback = typeof feedbackTable.$inferSelect;
export type NewFeedback = typeof feedbackTable.$inferInsert;


/* MUSIC */
export const musicTable = pgTable("music", {
    id: uuid("id").primaryKey().defaultRandom(),

    userId: uuid("user_id")
        .references(() => usersTable.id, {
            onDelete: "set null",
        }),

    name: text("name").notNull(), // song name or description
    artist: text("artist"), // optional
    mood: text("mood"), // e.g., "playful", "intense", "romantic"
    link: text("link"), // YouTube, Spotify, etc.
    performanceNotes: text("performance_notes"), // choreography/mood ideas
    tempoBpm: integer("tempo_bpm"), // optional: beats per minute
    durationSec: integer("duration_sec"), // optional: in seconds
    favorite: integer("favorite").default(0), // True or false

    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});


export type Music = typeof musicTable.$inferSelect;
export type NewMusic = typeof musicTable.$inferInsert;













/* TODO other tables:

RELATED TO USERS
Roles: UserID, Role (instructor student studioOwner), OR Instructors: UserID, Studio, Apparatus, Level
Classes: ClassName, Date, Time, Instructor, Apparatus, Level (used for attendance in future)
ProfilePicture: UserID, MediaID

RELATED TO POSES
Contraindications: PoseID, contraindication
MuscleGroupsEngaged:
Variations/PoseFamilies: BasePoseId, VariantPoseId

RELATED TO MEDIA
MediaSharing: MediaID, UserId(sharedTo)
ThumbnailId: videoMediaID and thumbnailImageID
AssociatedPoses / Flows : MediaID, PoseID

*/

/* GEMINI VERSION OF THE TABLES ABOVE

export const rolesTable = pgTable("roles", {
    userId: uuid("user_id").notNull().references(() => usersTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    role: text("role").notNull(), // e.g., 'instructor', 'student', 'studioOwner'
    // You might add a scope if roles can be specific to a studio or apparatus
    // scope: uuid("scope").references(...),
    primaryKey: primaryKey({ columns: [userId, role] }), // Ensures a user doesn't have the same role multiple times
});

export const instructorsTable = pgTable("instructors", {
    userId: uuid("user_id").primaryKey().references(() => usersTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    studio: text("studio"),
    apparatus: text("apparatus", { array: true }), // An instructor might teach on multiple apparatus
    level: text("level"), // Or perhaps a more structured way to represent levels they teach
});

export const classesTable = pgTable("classes", {
    id: uuid("id").primaryKey().defaultRandom(),
    className: text("class_name").notNull(),
    date: date("date").notNull(),
    time: time("time").notNull(),
    instructorId: uuid("instructor_id").references(() => instructorsTable.userId, { onDelete: "set null", onUpdate: "no action" }),
    apparatus: text("apparatus").notNull(),
    level: text("level"),
    // ... other class details
});

export const contraindicationsTable = pgTable("contraindications", {
    id: uuid("id").primaryKey().defaultRandom(),
    poseId: uuid("pose_id").notNull().references(() => posesTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    contraindication: text("contraindication").notNull(),
    // You might want to add a category for the contraindication (e.g., 'physical', 'medical')
});

export const muscleGroupsEngagedTable = pgTable("muscle_groups_engaged", {
    id: uuid("id").primaryKey().defaultRandom(),
    poseId: uuid("pose_id").notNull().references(() => posesTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    muscleGroup: text("muscle_group").notNull(),
});

export const poseVariationsTable = pgTable("pose_variations", {
    basePoseId: uuid("base_pose_id").notNull().references(() => posesTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    variantPoseId: uuid("variant_pose_id").notNull().references(() => posesTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    primaryKey: primaryKey({ columns: [basePoseId, variantPoseId] }),
    relationType: text("relation_type"), // e.g., 'variation', 'progression', 'regression'
    description: text("description"), // Optional description of the relationship
});

export const mediaSharingTable = pgTable("media_sharing", {
    mediaId: uuid("media_id").notNull().references(() => mediaTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    userId: uuid("user_id").notNull().references(() => usersTable.id, { onDelete: "cascade", onUpdate: "no action" }),
    sharedAt: timestamp("shared_at").defaultNow(),
    primaryKey: primaryKey({ columns: [mediaId, userId] }),
});

export const mediaTable = pgTable("media", {
    id: uuid("id").primaryKey().defaultRandom(),
    // ... other media fields
    thumbnailImageId: uuid("thumbnail_image_id").references(() => mediaTable.id),
    // For videos, you might also have a previewImageId
    previewImageId: uuid("preview_image_id").references(() => mediaTable.id),
});

 */

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