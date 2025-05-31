/* USERS */
const String userTable = "users";

const String createUserTable = '''
  CREATE TABLE $userTable (
    id TEXT PRIMARY KEY,

    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,

    first_name TEXT,
    last_name TEXT,
    bio TEXT,
    
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    last_login TEXT NOT NULL,
    
    token TEXT NOT NULL
  )
''';

const String dropUserTable = 'DROP TABLE IF EXISTS $userTable';


/* MEDIA */
const String mediaTable = "media";

const String createMediaTable = '''
  CREATE TABLE $mediaTable (
    id TEXT PRIMARY KEY,
    media_path TEXT NOT NULL,
    
    media_type TEXT NOT NULL,
    file_size INTEGER,
    
    name TEXT,
    description TEXT,
    apparatus TEXT,
    
    uploaded_by TEXT NOT NULL, 
    uploaded_at TEXT NOT NULL,
    
    is_synced INTEGER NOT NULL
  )
''';
// TODO generate alt text and add into Media Model
const String dropMediaTable = 'DROP TABLE IF EXISTS $mediaTable';


/* POSES */
const String poseTable = "poses";

const String createPoseTable = '''
  CREATE TABLE $poseTable (  
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    apparatus TEXT NOT NULL,
    level REAL NOT NULL,
    
    primary_media_id TEXT NOT NULL,
    primary_media_path TEXT NOT NULL,
  
    description TEXT,
    teaching_cues TEXT,
    safety_cues TEXT,
    progressions TEXT,
  
    created_by TEXT NOT NULL,
    updated_by TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
  
    is_synced INTEGER NOT NULL
  )
''';

const String dropPoseTable = 'DROP TABLE IF EXISTS $poseTable';


/* TRANSITIONS */
const String transitionTable = "transitions";

const String createTransitionTable = '''
  CREATE TABLE $transitionTable (
    id TEXT PRIMARY KEY,
    
    from_pose_id TEXT NOT NULL,
    to_pose_id TEXT NOT NULL, 
    level REAL NOT NULL,
    
    name TEXT,
    description TEXT,
    teaching_cues TEXT,
    safety_cues TEXT,
    progressions TEXT,
    
    transition_type TEXT,
    starting_grip TEXT,
    ending_grip TEXT,
    
    created_by TEXT NOT NULL,
    updated_by TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    
    is_synced INTEGER NOT NULL
  )
''';

const String dropTransitionTable = 'DROP TABLE IF EXISTS $transitionTable';


/* FLOWS */
const String flowTable = "flows";

const String createFlowTable = '''
  CREATE TABLE $flowTable (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    thumbnail_image_id TEXT NOT NULL,
    thumbnail_image_path TEXT NOT NULL,
    apparatus TEXT NOT NULL,
    level REAL NOT NULL,
    
    description TEXT,
    teaching_cues TEXT,
    safety_cues TEXT,
    progressions TEXT,
    
    created_by TEXT NOT NULL,
    updated_by TEXT, 
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    
    is_synced INTEGER NOT NULL
  )
''';

const String dropFlowTable = 'DROP TABLE IF EXISTS $flowTable';


/* FLOW POSES CONNECTOR */
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
const String dropFlowPoseTable = 'DROP TABLE IF EXISTS $flowPoseTable';


/* MUSIC */
const String musicTable = "music";

const String createMusicTable = '''
  CREATE TABLE $musicTable (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    
    name TEXT NOT NULL,
    artist TEXT,
    mood TEXT,
    link TEXT,
    performance_notes TEXT,
    tempo_bpm INTEGER,
    duration_sec INTEGER,
    favorite INTEGER DEFAULT 0,
    
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    
    is_synced INTEGER NOT NULL
  )
''';

const String dropMusicTable = 'DROP TABLE IF EXISTS $musicTable';


/* TAGS */
const String tagsTable = "tags";

const String createTagsTable = '''
  CREATE TABLE $tagsTable (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    name TEXT NOT NULL,
    color TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
''';

const String dropTagsTable = 'DROP TABLE IF EXISTS $tagsTable';


/* POSE TAG CONNECTOR */
const String poseTagsTable = "pose_tags";

const String createPoseTagsTable = '''
  CREATE TABLE $poseTagsTable (
    id TEXT PRIMARY KEY,
    pose_id TEXT NOT NULL,
    tag_id TEXT NOT NULL,
    user_id TEXT NOT NULL
  )
''';

const String dropPoseTagsTable = 'DROP TABLE IF EXISTS $poseTagsTable';


/* FLOW TAG CONNECTOR */
const String flowTagsTable = "flow_tags";

const String createFlowTagsTable = '''
  CREATE TABLE $flowTagsTable (
    id TEXT PRIMARY KEY,
    flow_id TEXT NOT NULL,
    tag_id TEXT NOT NULL,
    user_id TEXT NOT NULL
  )
''';

const String dropFlowTagsTable = 'DROP TABLE IF EXISTS $flowTagsTable';
