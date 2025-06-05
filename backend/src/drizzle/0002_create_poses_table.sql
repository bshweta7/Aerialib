DROP TABLE IF EXISTS poses;
CREATE TABLE "poses" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
    "slug" text NOT NULL,
    "display_name" text NOT NULL,
    "alt_name" text,
    "base_name" text NOT NULL,
    "prefix" text,
    "suffix" text,
    "grip_position" text,
    "leg_position" text,
    "position_in_bar" text,
    "apparatus" text NOT NULL,
    "level" integer,
    "pose_type" text,
    "description" text,
    "teaching_cues" text,
    "safety_cues" text,
    "progressions" text,
    "modifications" text,
    "common_errors" text,
    "thumbnail_media_id" uuid,
    "media_id" uuid,
    "created_by" uuid NOT NULL,
    "updated_by" uuid,
    "created_at" timestamp DEFAULT now(),
    "updated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "poses" ADD CONSTRAINT "poses_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade;
ALTER TABLE "poses" ADD CONSTRAINT "poses_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id");
ALTER TABLE "poses" ADD CONSTRAINT "poses_thumbnail_media_id_media_id_fk" FOREIGN KEY ("thumbnail_media_id") REFERENCES "public"."media"("id");
ALTER TABLE "poses" ADD CONSTRAINT "poses_media_id_media_id_fk" FOREIGN KEY ("media_id") REFERENCES "public"."media"("id");