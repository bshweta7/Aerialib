ALTER TABLE "poses" RENAME COLUMN "grip_position" TO "hand_position";--> statement-breakpoint
ALTER TABLE "poses" RENAME COLUMN "media_id" TO "primary_media_id";--> statement-breakpoint
ALTER TABLE "poses" DROP CONSTRAINT "poses_media_id_media_id_fk";
--> statement-breakpoint
ALTER TABLE "poses" ADD CONSTRAINT "poses_primary_media_id_media_id_fk" FOREIGN KEY ("primary_media_id") REFERENCES "public"."media"("id") ON DELETE no action ON UPDATE no action;