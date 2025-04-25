const String flowTable = "flows";

const String createFlowTable = '''
  CREATE TABLE $flowTable (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    apparatus TEXT,    
    created_by TEXT NOT NULL,
    updated_by TEXT, 
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    primary_image_id TEXT NOT NULL,
    primary_image_url TEXT NOT NULL,
    is_synced INTEGER NOT NULL
  )
''';

const String dropFlowTable = 'DROP TABLE IF EXISTS $flowTable';





// lib/data/database/flow_pose_schema.dart

const String flowPoseTable = "flow_poses";

const String createFlowPoseTable = '''
  CREATE TABLE $flowPoseTable (
    id TEXT PRIMARY KEY,
    flow_id TEXT NOT NULL,
    pose_id TEXT NOT NULL,
    pose_order INTEGER NOT NULL,
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

