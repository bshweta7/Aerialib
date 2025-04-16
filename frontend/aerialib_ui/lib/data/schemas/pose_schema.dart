// lib/data/database/pose_schema.dart

const String poseTable = "poses";

const String createPoseTable = '''
  CREATE TABLE $poseTable (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    cues TEXT,
    apparatus TEXT NOT NULL,
    level INTEGER NOT NULL,
    created_by TEXT NOT NULL,
    updated_by TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    primary_image_id TEXT NOT NULL,
    primary_image_url TEXT NOT NULL,
    is_synced INTEGER NOT NULL
  )
''';

const String dropPoseTable = 'DROP TABLE IF EXISTS $poseTable';
