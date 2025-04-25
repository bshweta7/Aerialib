/*
  POSES
*/
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



/*
  FLOWS
*/

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

/*
  FLOW POSES
*/

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


/*
  MEDIA
*/

const String mediaTable = "media";

const String createMediaTable = '''
  CREATE TABLE $mediaTable (
    id TEXT PRIMARY KEY,
    mediaURL TEXT NOT NULL,
    name TEXT,
    description TEXT,
    apparatus TEXT,
    uploadedBy TEXT NOT NULL,
    uploadedAt TEXT NOT NULL,
    isSynced INTEGER NOT NULL
  )
''';

const String dropMediaTable = 'DROP TABLE IF EXISTS $mediaTable';


/*
  USERS
*/

const String userTable = "users";

const String createUserTable = '''
  CREATE TABLE $userTable (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL,
    token TEXT NOT NULL,
    name TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
  )
''';

const String dropUserTable = 'DROP TABLE IF EXISTS $userTable';