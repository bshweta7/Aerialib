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