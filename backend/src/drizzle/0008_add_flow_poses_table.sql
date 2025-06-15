CREATE TABLE "flow_poses" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"flow_id" uuid NOT NULL,
	"pose_id" uuid NOT NULL,
	"pose_order" integer NOT NULL,
	"transition_id" uuid
);
--> statement-breakpoint
ALTER TABLE "flow_poses" ADD CONSTRAINT "flow_poses_flow_id_flows_id_fk" FOREIGN KEY ("flow_id") REFERENCES "public"."flows"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "flow_poses" ADD CONSTRAINT "flow_poses_pose_id_poses_id_fk" FOREIGN KEY ("pose_id") REFERENCES "public"."poses"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "flow_poses" ADD CONSTRAINT "flow_poses_transition_id_transitions_id_fk" FOREIGN KEY ("transition_id") REFERENCES "public"."transitions"("id") ON DELETE cascade ON UPDATE no action;