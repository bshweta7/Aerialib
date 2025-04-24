// lib/data/database/flow_pose_schema.dart

const String flowPoseTable = "flow_poses";

const String createFlowPoseTable = '''
  CREATE TABLE $flowPoseTable (
    id TEXT PRIMARY KEY,
    flow_id TEXT NOT NULL,
    pose_id TEXT NOT NULL,
    order INTEGER NOT NULL,
    transition_id TEXT, 
    is_synced INTEGER NOT NULL
  )
''';

/*
TODO : ADD THESE ?
  created_by TEXT NOT NULL,
  updated_by TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,

  Change transition ID to transition note or something
 */

const String dropFlowPoseTable = 'DROP TABLE IF EXISTS $flowPoseTable';

