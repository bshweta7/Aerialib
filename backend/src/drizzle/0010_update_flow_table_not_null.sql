ALTER TABLE "flows" ALTER COLUMN "level" SET DATA TYPE integer;--> statement-breakpoint
ALTER TABLE "flows" ALTER COLUMN "level" DROP NOT NULL;
ALTER TABLE "flows" ALTER COLUMN "apparatus" DROP NOT NULL;