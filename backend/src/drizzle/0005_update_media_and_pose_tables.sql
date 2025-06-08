ALTER TABLE "poses" DROP COLUMN "thumbnail_media_id";--> statement-breakpoint
ALTER TABLE "media" RENAME COLUMN "uploaded_by" TO "created_by";--> statement-breakpoint
ALTER TABLE "media" RENAME COLUMN "uploaded_at" TO "created_at";--> statement-breakpoint
ALTER TABLE "media" DROP CONSTRAINT "media_uploaded_by_users_id_fk";
--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "has_thumbnail" integer;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "duration_seconds" integer;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "origin" text;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "taken_time" timestamp;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "taken_location" text;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "updated_by" uuid;--> statement-breakpoint
ALTER TABLE "media" ADD COLUMN "updated_at" timestamp DEFAULT now();--> statement-breakpoint
ALTER TABLE "media" ADD CONSTRAINT "media_created_by_users_id_fk" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "media" ADD CONSTRAINT "media_updated_by_users_id_fk" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;