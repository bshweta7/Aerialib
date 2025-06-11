ALTER TABLE "flows" DROP CONSTRAINT "flows_thumbnail_image_id_media_id_fk";--> statement-breakpoint
ALTER TABLE "flows" RENAME COLUMN "thumbnail_image_id" TO "primary_media_id";--> statement-breakpoint
ALTER TABLE "flows" ADD COLUMN "modifications" text;--> statement-breakpoint
ALTER TABLE "flows" ADD COLUMN "common_errors" text;--> statement-breakpoint
ALTER TABLE "flows" ADD CONSTRAINT "flows_primary_media_id_media_id_fk" FOREIGN KEY ("primary_media_id") REFERENCES "public"."media"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint