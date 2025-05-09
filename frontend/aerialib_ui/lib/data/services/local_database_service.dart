import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:frontend/data/schema/database_schema.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

String _getDatabaseFileName() {
  if (kIsWeb) return 'aerialib_web.db';
  if (Platform.isAndroid || Platform.isIOS) return 'aerialib.db';
  if (Platform.isMacOS) return 'aerialib_macos.db';
  if (Platform.isLinux) return 'aerialib_linux.db';
  if (Platform.isWindows) return 'aerialib_windows.db';
  return 'aerialib.db'; // Fallback
}

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    // Use FFI only on desktop platforms
    if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _getDatabaseFileName());
    print('[DatabaseService] DB path: $path');

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute(createPoseTable);
          await db.execute(createFlowTable);
          await db.execute(createFlowPoseTable);
          await db.execute(createMediaTable);
          await db.execute(createUserTable);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Poses
          await db.execute(dropPoseTable); // Use drop command from schema
          await db.execute(createPoseTable); // Use create command from schema

          // Flows
          await db.execute(dropFlowTable);
          await db.execute(createFlowTable);

          // Flow Poses
          await db.execute(dropFlowPoseTable); // Use drop command from schema
          await db.execute(createFlowPoseTable); // Use create command from schema

          // Media
          await db.execute(dropMediaTable); // Use drop command from schema
          await db.execute(createMediaTable); // Use create command from schema

          // Users
          await db.execute(dropUserTable); // Use drop command from schema
          await db.execute(createUserTable); // Use create command from schema

        },
      ),
    );
  }
}
