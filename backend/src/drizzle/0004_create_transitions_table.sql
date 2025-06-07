DROP TABLE IF EXISTS flow_poses;
DROP TABLE IF EXISTS transitions;
CREATE TABLE "transitions" (
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
   "from_pose_id" uuid NOT NULL,
   "to_pose_id" uuid NOT NULL,

   "name" text,
   "apparatus" text NOT NULL,
   "level" integer,
   "transition_type" text,

   "description" text,
   "teaching_cues" text,
   "safety_cues" text,
   "progressions" text,
   "modifications" text,
   "common_errors" text,

   "primary_media_id" uuid,

   "created_by" uuid NOT NULL,
   "updated_by" uuid,
   "created_at" timestamp DEFAULT now(),
   "updated_at" timestamp DEFAULT now()
);

ALTER TABLE "transitions" ADD CONSTRAINT "transitions_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade;
ALTER TABLE "transitions" ADD CONSTRAINT "transitions_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id");
ALTER TABLE "transitions" ADD CONSTRAINT "transitions_primary_media_id_media_id_fk" FOREIGN KEY ("primary_media_id") REFERENCES "public"."media"("id");
ALTER TABLE "transitions" ADD CONSTRAINT "transitions_from_pose_id_pose_id_fk" FOREIGN KEY ("from_pose_id") REFERENCES "public"."poses"("id");
ALTER TABLE "transitions" ADD CONSTRAINT "transitions_to_pose_id_pose_id_fk" FOREIGN KEY ("to_pose_id") REFERENCES "public"."poses"("id");
