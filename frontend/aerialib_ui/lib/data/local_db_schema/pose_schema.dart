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
    createdBy TEXT NOT NULL,
    updatedBy TEXT,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL,
    primaryImageId TEXT NOT NULL,
    primaryImageUrl TEXT NOT NULL,
    isSynced INTEGER NOT NULL
  )
''';

const String dropPoseTable = 'DROP TABLE IF EXISTS $poseTable';
