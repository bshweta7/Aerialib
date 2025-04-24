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
